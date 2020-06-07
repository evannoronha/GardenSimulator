
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.util.ArrayList;
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

    public Seeds(PlantSpecies ps, int quantity){
        this.ps = ps;
        this.quantity = quantity;
    }

    public String getName() {
        return ps.getName();
    }

    public String getLifespanType() {
        return ps.getLifespanType();
    }

    public Integer getHarvestQuantity() {
        return ps.getHarvestQuantity();
    }

    public Integer getQuantity(){
        return quantity;
    }

    public ArrayList<Seeds> getSeeds() throws SQLException
    {
        int userid = Util.getIDFromLogin();
        Connection con = dbConnect.getConnection();
        ArrayList<Seeds> seedsList = new ArrayList<>();

        PreparedStatement ps = con.prepareStatement(
                        "select * from has_seeds join plant_species "
                                + "on has_seeds.seed_id = plant_species.species_id"
                                + "where has_seeds.user_id = ?");

        ps.setInt(1, userid);

        ResultSet result = ps.executeQuery();
        while(result.next())
        {
            PlantSpecies thisPlant;
            Integer speciesId = result.getInt("speciesId");
            String name = result.getString("name");
            String lifespan = result.getString("lifespan_type");
            Integer harvestQuantity = result.getInt("harvest_quantity");
            String url = result.getString("plant_image_url");

            thisPlant = PlantSpecies.makePlant(speciesId, name, lifespan, harvestQuantity, url);

            Seeds newSeeds = new Seeds(thisPlant, result.getInt("quantity"));
            seedsList.add(newSeeds);
        }

       return seedsList;
    }

    public String showSeedInventory(){
        return "showSeedInventory";
    }



}