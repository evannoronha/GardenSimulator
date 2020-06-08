
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
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
public class Seeds implements Serializable {

    private DBConnect dbConnect = new DBConnect();
    protected PlantSpecies plantSpecies;
    protected Integer quantity;
    protected Integer saleQuantity;
    protected Double salePrice;
    protected Integer saleSpeciesId;

    public Seeds() {
        plantSpecies = null;
        quantity = 0;
        this.saleQuantity = 0;
        this.salePrice = 0.0;
        this.saleSpeciesId = null;
    }

    public Seeds(PlantSpecies ps, int quantity) {
        this.plantSpecies = ps;
        this.quantity = quantity;
        this.saleQuantity = 0;
        this.salePrice = 0.0;
        this.saleSpeciesId = null;
    }

    public void setQuantity(Integer q) {
        this.quantity = q;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setSaleQuantity(Integer q) {
        this.saleQuantity = q;
    }

    public Integer getSaleQuantity() {
        return saleQuantity;
    }

    public PlantSpecies getPlantSpecies() {
        return plantSpecies;
    }

    public Double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(Double s) {
        salePrice = s;
    }

    public Integer getSaleSpeciesId() {
        return this.saleSpeciesId;
    }

    public void setSaleSpeciesId(Integer s) {
        this.saleSpeciesId = s;
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

    public String home() {
        return "home";
    }

    public String toString() {
        return String.valueOf(quantity) + " " + "of  " + plantSpecies.toString();
    }

    //TODO
    public void plantSeeds() {
        //set the current type of seed to active
        return;
    }

    public String sellSeeds() throws SQLException {
        if (!userHasSeedQuantity()) {
            return "fail";
        }

        int userid = Util.getIDFromLogin();
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        PreparedStatement ps = con.prepareStatement(
                "update has_seeds set quantity = quantity - ? "
                + "where user_id = ? and "
                + "seed_id = ?");

        ps.setInt(1, saleQuantity);
        ps.setInt(2, userid);
        ps.setInt(3, saleSpeciesId);

        ps.executeUpdate();

        PreparedStatement ps2 = con.prepareStatement("insert into market_listings values(DEFAULT,?,?,?,?,?)");

        ps2.setInt(1, userid);
        ps2.setInt(2, saleSpeciesId);
        ps2.setDouble(3, salePrice);
        ps2.setInt(4, saleQuantity);
        ps2.setObject(5, "seeds", Types.OTHER);

        ps2.executeUpdate();

        con.commit();
        con.close();

        System.out.println("Sucessful seed query");
        return "success";
    }

    public void userOwnsSeeds(FacesContext context, UIComponent componentToValidate, Object value) throws SQLException, ValidatorException {
        int currentUserId = Util.getIDFromLogin();
        int seedId = (Integer) (value);

        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        //DEFAULT accounts for serial column
        PreparedStatement preparedStatement = con.prepareStatement("select * from has_seeds where seed_id = ? ");
        preparedStatement.setInt(1, seedId);

        ResultSet result = preparedStatement.executeQuery();
        if (!result.next()) {
            FacesMessage errorMessage = new FacesMessage("User does not own any of this seed");
            throw new ValidatorException(errorMessage);
        }
    }

    //validate that the user can sell this many seeds
    public boolean userHasSeedQuantity() throws SQLException {
        int userid = Util.getIDFromLogin();
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        PreparedStatement ps = con.prepareStatement(
                "select * from has_seeds where user_id = ? and seed_id = ?");

        ps.setInt(1, userid);
        ps.setInt(2, saleSpeciesId);

        ResultSet result = ps.executeQuery();

        while (result.next()) {
            Integer seedQuantity = result.getInt("quantity");
            if (seedQuantity >= saleQuantity) {
                return true;
            }
        }
        con.close();
        return false;
    }
}
