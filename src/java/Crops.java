
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

@Named(value = "crops")
@SessionScoped
@ManagedBean
public class Crops implements Serializable {

    private DBConnect dbConnect = new DBConnect();
    protected PlantSpecies plantSpecies;
    protected Integer quantity;
    protected Integer saleQuantity;
    protected Double salePrice;
    protected Integer saleSpeciesId;

    public Crops() {
        plantSpecies = null;
        quantity = 0;
        this.saleQuantity = 0;
        this.salePrice = 0.0;
        this.saleSpeciesId = null;
    }

    public Crops(PlantSpecies ps, int quantity) {
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

    public List<Crops> getCrops() throws SQLException {
        int userid = Util.getIDFromLogin();
        System.out.println("user id" + userid);
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);
        ArrayList<Crops> cropsList = new ArrayList<>();

        PreparedStatement ps = con.prepareStatement(
                "select * from crops_inventory join plant_species "
                + "on crops_inventory.crop_id = plant_species.species_id "
                + "where crops_inventory.user_id = ?");

        ps.setInt(1, userid);

        ResultSet result = ps.executeQuery();
        while (result.next()) {
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

            Crops newCrops = new Crops(thisPlant, result.getInt("quantity"));

            cropsList.add(newCrops);
        }

        result.close();
        con.close();

        return cropsList;
    }

    public String showCropInventory() {
        return "showCropInventory";
    }

    public String home() {
        return "home";
    }

    public String toString() {
        return String.valueOf(quantity) + " " + "of  " + plantSpecies.toString();
    }

    public String sellCrops() throws SQLException {
        if (!userHasCropQuantity()) {
            return "fail";
        }

        int userid = Util.getIDFromLogin();
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        PreparedStatement ps = con.prepareStatement(
                "update crops_inventory set quantity = quantity - ? "
                + "where user_id = ? and "
                + "crop_id = ?");

        ps.setInt(1, saleQuantity);
        ps.setInt(2, userid);
        ps.setInt(3, saleSpeciesId);

        ps.executeUpdate();

        PreparedStatement ps2 = con.prepareStatement("insert into market_listings values(DEFAULT,?,?,?,?,?)");

        ps2.setInt(1, userid);
        ps2.setInt(2, saleSpeciesId);
        ps2.setDouble(3, salePrice);
        ps2.setInt(4, saleQuantity);
        ps2.setObject(5, "crops", Types.OTHER);

        ps2.executeUpdate();

        con.commit();
        con.close();

        return "success";
    }

    //validate that the user can sell this many seeds
    public boolean userHasCropQuantity() throws SQLException {
        int userid = Util.getIDFromLogin();
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        PreparedStatement ps = con.prepareStatement(
                "select * from crops_inventory where user_id = ? and crop_id = ?");

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
