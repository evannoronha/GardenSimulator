
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
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

    public List<SeedInventory> getSeeds() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<SeedInventory, Integer> inventoryDao = new SeedInventory().getDao(cs);
        List<SeedInventory> listSeeds = inventoryDao.queryForEq("user_id", userid);
        cs.close();
        return listSeeds;
    }

    public String toString() {
        return String.valueOf(quantity) + " " + "of  " + plantSpecies.toString();
    }

    public String sell() throws SQLException, IOException {
        if (!this.userHasQuantity()) {
            return "fail";
        }

        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao = new MarketListing().getDao(cs);
        Dao<PlantSpecies, Integer> plantSpeciesDao = new PlantSpecies().getDao(cs);

        PlantSpecies saleSpecies = plantSpeciesDao.queryForId(saleSpeciesId);

        MarketListing listing = new MarketListing();
        listing.setSeller_id(User.getByUserid(userid));
        listing.setPlant_id(saleSpecies);
        listing.setPrice(salePrice);
        listing.setQuantity(saleQuantity);
        listing.setListing_type(this.typeName);
        listingDao.create(listing);

        Dao<SeedInventory, Integer> inventoryDao = new SeedInventory().getDao(cs);

        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(this.plantIdColumn, saleSpeciesId);
        SeedInventory inv = inventoryDao.queryForFieldValues(params).get(0);
        inv.setQuantity(inv.getQuantity() - saleQuantity);
        inventoryDao.update(inv);

        cs.close();
        return "success";
    }

    public void userOwnsSeeds(FacesContext context, UIComponent componentToValidate, Object value) throws SQLException, ValidatorException, IOException {
        int seedId = (Integer) (value);

        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();

        Dao<SeedInventory, Integer> inventoryDao = new SeedInventory().getDao(cs);

        params.put("user_id", userid);
        params.put(this.plantIdColumn, seedId);
        List<SeedInventory> result = inventoryDao.queryForFieldValues(params);
        cs.close();
        if (result.size() == 0) {
            FacesMessage errorMessage = new FacesMessage("You don't have any of those.");
            throw new ValidatorException(errorMessage);
        }
    }

    //validate that the user can sell this many seeds
    public boolean userHasQuantity() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();
        Dao<SeedInventory, Integer> inventoryDao = new SeedInventory().getDao(cs);
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

    @Override
    public void addToInventory() throws SQLException, IOException {
        //do I do quantity here? or pass in quantity as a variable
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<SeedInventory, Integer> inventoryDao = new SeedInventory().getDao(cs);
        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(plantIdColumn, plantSpecies.getSpecies_id());
        List<SeedInventory> invList = inventoryDao.queryForFieldValues(params);

        if (invList.isEmpty()) {
            SeedInventory newInv = new SeedInventory();
            newInv.setQuantity(quantity);
            newInv.setSeed_id(plantSpecies);
            newInv.setUser_id(userid);
            inventoryDao.create(newInv);
        } else {
            SeedInventory inv = invList.get(0);
            inv.setQuantity(inv.getQuantity() + quantity);
            inventoryDao.update(inv);
        }
        cs.close();
    }
}
