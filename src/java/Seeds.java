
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.annotation.ManagedBean;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;

@Named(value = "seeds")
@SessionScoped
@ManagedBean
public class Seeds extends Harvestable implements Serializable {

    public static String typeName = "seeds";
    public static String plantIdColumn = "seed_id";

    public Seeds() {
        super();
    }

    public Seeds(PlantSpecies ps, int quantity) {
        super(ps, quantity);
    }

    public List<Seeds> getSeeds() throws SQLException {
        int userid = Util.getIDFromLogin();
        System.out.println("user id" + userid);
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);
        ArrayList<Seeds> seedsList = new ArrayList<>();

        PreparedStatement ps = con.prepareStatement(
                "select * from has_seeds join plant_species "
                + "on has_seeds.seed_id = plant_species.species_id "
                + "where has_seeds.user_id = ?");

        ps.setInt(1, userid);

        System.out.println("Sucessful seed query");

        ResultSet result = ps.executeQuery();
        while (result.next()) {
            System.out.println("starting to make a new seed");
            System.out.println(result.toString());
            System.out.println();
            PlantSpecies thisPlant;
            Integer speciesId = result.getInt("species_id");
            String name = result.getString("name");
            String lifespan = result.getString("lifespan_type");
            Integer harvestQuantity = result.getInt("harvest_quantity");
            String url = result.getString("plant_image_url");
            Integer daysToHarvest = result.getInt("days_to_harvest");

            thisPlant = PlantSpecies.makePlant(speciesId, name, lifespan, harvestQuantity, url, daysToHarvest);

            System.out.print(thisPlant);

            Seeds newSeeds = new Seeds(thisPlant, result.getInt("quantity"));

            System.out.println(newSeeds);
            seedsList.add(newSeeds);
        }

        result.close();
        con.close();

        System.out.println("bout to return a seeds list." + seedsList.size());

        return seedsList;
    }

    public String showSeedInventory() {
        return "showSeedInventory";
    }

    public String toString() {
        return String.valueOf(quantity) + " " + "of  " + plantSpecies.toString();
    }

    //TODO
    public void plantSeeds() {
        //set the current type of seed to active
        return;
    }

    public String sell() throws SQLException, IOException {
        if (!this.userHasQuantity()) {
            return "fail";
        }

        int userid = Util.getIDFromLogin();

        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao
                = DaoManager.createDao(cs, MarketListing.class);

        MarketListing listing = new MarketListing();

        listing.setSeller_id(userid);
        listing.setPlant_id(saleSpeciesId);
        listing.setPrice(salePrice);
        listing.setQuantity(saleQuantity);
        listing.setListing_type(this.typeName);
        listingDao.create(listing);

        Dao<SeedInventory, Integer> inventoryDao = getDao(cs);

        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(this.plantIdColumn, saleSpeciesId);
        SeedInventory inv = inventoryDao.queryForFieldValues(params).get(0);
        inv.setQuantity(inv.getQuantity() - saleQuantity);
        inventoryDao.update(inv);

        cs.close();
        return "success";
    }

    public Dao<SeedInventory, Integer> getDao(ConnectionSource cs) throws SQLException {
        return DaoManager.createDao(cs, SeedInventory.class);
    }

    public void userOwnsSeeds(FacesContext context, UIComponent componentToValidate, Object value) throws SQLException, ValidatorException, IOException {
        int userid = Util.getIDFromLogin();
        int seedId = (Integer) (value);

        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();

        Dao<SeedInventory, Integer> inventoryDao = getDao(cs);

        params.put("user_id", userid);
        params.put(this.plantIdColumn, seedId);
        List<SeedInventory> result = inventoryDao.queryForFieldValues(params);
        if (result.size() == 0) {
            FacesMessage errorMessage = new FacesMessage("You don't have any of those.");
            throw new ValidatorException(errorMessage);
        }
        cs.close();
    }

    //validate that the user can sell this many seeds
    public boolean userHasQuantity() throws SQLException, IOException {
        int userid = Util.getIDFromLogin();
        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();
        Dao<SeedInventory, Integer> inventoryDao = getDao(cs);
        params.put("user_id", userid);
        params.put(this.plantIdColumn, saleSpeciesId);
        List<SeedInventory> result = inventoryDao.queryForFieldValues(params);
        cs.close();
        if (result.size() == 0) {
            return false;
        } else if (result.get(0).getQuantity() < saleQuantity) {
            return false;
        } else {
            return true;
        }
    }
}
