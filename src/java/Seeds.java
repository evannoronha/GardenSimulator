
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
    ///int userid = Util.getIDFromLogin();
    protected PlantSpecies ps;
    protected Integer quantity;
    protected Integer sellQuantity;

    public Seeds() {
        ps = null;
        quantity = 0;
    }

    public Seeds(PlantSpecies ps, int quantity) {
        this.ps = ps;
        this.quantity = quantity;
    }

    public void setQuantity(Integer q) {
        this.quantity = q;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setSellQuantity(Integer q) {
        this.sellQuantity = q;
    }

    public Integer getSellQuantity() {
        return sellQuantity;
    }

    public PlantSpecies getPlantSpecies() {
        return ps;
    }

    public List<Seeds> getSeeds() throws SQLException {
        int userid = Util.getIDFromLogin();
        System.out.println("user id" + userid);
        Connection con = dbConnect.getConnection();
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
        return quantity + " " + "of  " + ps.toString();
    }

    //TODO
    public void plantSeeds() {
        //set the current type of seed to active
        return;
    }

    //TODO
    public void sellSeeds() {
        //subtract this amount of seeds from the database
        return;
    }

    public void userOwnsSeeds(FacesContext context, UIComponent componentToValidate, Object value) throws SQLException, ValidatorException {
        int currentUserId = Util.getIDFromLogin();
        int seedId = (Integer) (value);

        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        Statement statement = con.createStatement();

        //DEFAULT accounts for serial column
        PreparedStatement preparedStatement = con.prepareStatement("select * from has_seeds where seed_id = ? ");
        preparedStatement.setInt(1, seedId);

        ResultSet result = preparedStatement.executeQuery();
        if (!result.next()) {
            FacesMessage errorMessage = new FacesMessage("User does not own any of this seed");
            throw new ValidatorException(errorMessage);
        }
    }

    public void userHasSeedQuantity() {

    }

}
