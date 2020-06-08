
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;

//@Named(value = "plantSpecies")
//@SessionScoped
//@ManagedBean
public abstract class PlantSpecies implements Serializable {

    private DBConnect dbConnect = new DBConnect();
    protected Integer speciesid;
    protected String name;
    protected String lifespanType;
    protected Integer harvestQuantity;
    protected String imageURL;

    public PlantSpecies(int speciesid, String name, String lifespanType, int harvestQuantity, String imageURL) {
        this.speciesid = speciesid;
        this.name = name;
        this.lifespanType = lifespanType;
        this.harvestQuantity = harvestQuantity;
        this.imageURL = imageURL;
    }

    public PlantSpecies() {
        this.speciesid = null;
        this.name = null;
        this.lifespanType = null;
        this.harvestQuantity = null;
        this.imageURL = null;
    }

    public static PlantSpecies makePlant(int speciesid, String name, String lifespanType, int harvestQuantity, String imageURL) throws SQLException {

        PlantSpecies newPlant = null;
        switch (getPlantType(speciesid)) {
            case ROOT:
                newPlant = new RootPlant(speciesid, name, lifespanType, harvestQuantity, imageURL);
                break;
            case DECORATIVE:
                newPlant = new DecorativePlant(speciesid, name, lifespanType, harvestQuantity, imageURL);
                break;
            case FRUITING:
                newPlant = new FruitingPlant(speciesid, name, lifespanType, harvestQuantity, imageURL);
                break;
            default:
                System.out.println("Couldn't find any plant in subtable with that id");
        }

        return newPlant;
    }

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

    //public abstract String create() throws SQLException, ParseException;
    //should NEVER insert into plant species without inserting into the sub table.
    //also, this should never be called? not sure how to do that
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

    abstract PlantSpecies getInstance();

    //cant have static classes implement abstract method
    //abstract boolean isInstance() throws SQLException;
    public static PlantType getPlantType(int id) throws SQLException {
        if (RootPlant.isInstance(id)) {
            return PlantType.ROOT;
        } else if (DecorativePlant.isInstance(id)) {
            return PlantType.DECORATIVE;
        } else if (FruitingPlant.isInstance(id)) {
            return PlantType.FRUITING;
        }
        return null;
    }

    public String toString() {
        return speciesid + " " + name + " " + lifespanType + " " + harvestQuantity + " " + imageURL;
    }

}
