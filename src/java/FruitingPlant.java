
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

@Named(value = "fruitingPlant")
@SessionScoped
@ManagedBean
public class FruitingPlant extends PlantSpecies implements Serializable {

    private DBConnect dbConnect = new DBConnect();

    public FruitingPlant() {
        super();
    }

    public FruitingPlant(Integer speciesid, String name, String lifespanType, Integer harvestQuantity, String imageURL, Integer daysToHarvest) {
        super(speciesid, name, lifespanType, harvestQuantity, imageURL, daysToHarvest);
    }

    public DBConnect getDbConnect() {
        return dbConnect;
    }

    public void setDbConnect(DBConnect dbConnect) {
        this.dbConnect = dbConnect;
    }

    @Override
    public String create() throws SQLException, ParseException {
        super.create();
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        PreparedStatement preparedStatement = con.prepareStatement("Insert into fruiting_plants values(?)");
        preparedStatement.setInt(1, super.speciesId);
        preparedStatement.executeUpdate();
        con.commit();
        con.close();

        return "main";
    }

    public FruitingPlant getFruitingPlant() throws SQLException {
        super.get();
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps
                = con.prepareStatement(
                        "select * from fruiting_plants where fruiting_plants.species_id = " + super.speciesId);

        //get customer data from database
        ResultSet result = ps.executeQuery();

        result.next();

        return this;
    }

    public PlantSpecies getInstance() {
        return this;
    }

    public static boolean isInstance(int id) throws SQLException {
        DBConnect tempDBConnect = new DBConnect();
        Connection con = tempDBConnect.getConnection();
        PreparedStatement ps = con.prepareStatement(
                "select count(*) from fruiting_plants "
                + "where species_id = ?");
        ps.setInt(1, id);
        ResultSet result = ps.executeQuery();

        if (result.next() && result.getInt(1) == 1) {
            return true;
        }
        return false;
    }
}
