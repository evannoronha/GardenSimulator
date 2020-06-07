
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import javax.annotation.ManagedBean;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;

@Named(value = "plantSpecies")
@SessionScoped
@ManagedBean
public class PlantSpecies implements Serializable {

    private DBConnect dbConnect = new DBConnect();
    protected int speciesid;
    protected String name;
    protected String lifespanType;
    protected int harvestQuantity;
    protected String imageURL;

    public Integer getSpeciesid() {
        return speciesid;
    }

    public void setSpeciesid(Integer speciesid) {
        this.speciesid = speciesid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLifespanType() {
        return lifespanType;
    }

    public void setLifespanType(String lifespanType) {
        this.lifespanType = lifespanType;
    }

    public Integer getHarvestQuantity() {
        return harvestQuantity;
    }

    public void setHarvestQuantity(Integer harvestQuantity) {
        this.harvestQuantity = harvestQuantity;
    }

    public String getImageURL() {
        return this.imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String create() throws SQLException, ParseException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        //DEFAULT accounts for serial column
        PreparedStatement preparedStatement = con.prepareStatement("Insert into plant_species values(DEFAULT,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);

        preparedStatement.setString(1, name);
        preparedStatement.setString(2, lifespanType);
        preparedStatement.setInt(3, harvestQuantity);
        preparedStatement.setString(4, imageURL);

        preparedStatement.executeUpdate();

        ResultSet rs = preparedStatement.getGeneratedKeys();

        if (rs.next()) {
            speciesid = rs.getInt(1);
        }

        con.commit();
        con.close();

        return "main";
    }

    public PlantSpecies get() throws SQLException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps
                = con.prepareStatement(
                        "select * from plant_species where plant_species.species_id = " + speciesid);

        //get user data from database
        ResultSet result = ps.executeQuery();

        result.next();

        name = result.getString("name");
        lifespanType = result.getString("lifespan_type");
        harvestQuantity = result.getInt("harvest_quantity");
        imageURL = result.getString("plant_image_url");

        return this;
    }

    public String delete() throws SQLException, ParseException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        Statement statement = con.createStatement();
        statement.executeUpdate("Delete from plant_species where plant_species.species_id = " + speciesid);
        statement.close();
        con.commit();
        con.close();

        return "main";
    }

    public void speciesIDExists(FacesContext context, UIComponent componentToValidate, Object value)
            throws ValidatorException, SQLException {

        if (!existSpeciesId((Integer) value)) {
            FacesMessage errorMessage = new FacesMessage("ID does not exist");
            throw new ValidatorException(errorMessage);
        }
    }

    private boolean existSpeciesId(int id) throws SQLException {
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps = con.prepareStatement("select * plant_species where plant_species.species_id = " + id);

        ResultSet result = ps.executeQuery();
        if (result.next()) {
            result.close();
            con.close();
            return true;
        }
        result.close();
        con.close();
        return false;
    }

}
