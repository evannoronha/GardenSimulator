
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.ManagedBean;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;

@Named(value = "rootPlant")
@SessionScoped
@ManagedBean
public class RootPlant extends PlantSpecies implements Serializable {

    private DBConnect dbConnect = new DBConnect();

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

        PreparedStatement preparedStatement = con.prepareStatement("Insert into root_plants values(?)");
        preparedStatement.setInt(1, super.speciesid);
        preparedStatement.executeUpdate();
        con.commit();
        con.close();

        return "main";
    }

    public RootPlant getRootPlant() throws SQLException {
        super.get();
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps
                = con.prepareStatement(
                        "select * from root_plants where root_plants.species_id = " + super.speciesid);

        //get customer data from database
        ResultSet result = ps.executeQuery();

        result.next();

        return this;
    }
}
