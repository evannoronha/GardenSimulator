
/**
 *
 * @author robert
 */
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import javax.annotation.ManagedBean;
import javax.el.ELContext;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;

@Named(value = "growbox")
@SessionScoped
@ManagedBean
public class GrowBox implements Serializable {

    private DBConnect dbConnect = new DBConnect();
    protected int boxid;
    protected int userid;
    protected int plantid;
    protected int location;
    protected int waterlevel;

    public GrowBox(int userid, int plantid, int location, int waterlevel)
    {
        this.userid = userid;
        this.plantid = plantid;
        this.location = location;
        this.waterlevel = waterlevel;
    }

    public String create() throws SQLException, ParseException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        //DEFAULT accounts for serial column
        PreparedStatement preparedStatement = con.prepareStatement("Insert into grow_boxes values(DEFAULT,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);

        preparedStatement.setInt(1, userid);
        preparedStatement.setInt(2, plantid);
        preparedStatement.setInt(3, location);
        preparedStatement.setInt(4, waterlevel);


        preparedStatement.executeUpdate();

        ResultSet rs = preparedStatement.getGeneratedKeys();
        if (rs.next()) {
            boxid = rs.getInt(1);
        }

        con.commit();
        con.close();

        return "createGardenBox";
    }

    public GrowBox get() throws SQLException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps
                = con.prepareStatement(
                        "select * from grow_boxes where grow_boxes.box_id = ?");

        ps.setInt(1, boxid);

        ResultSet result = ps.executeQuery();
        result.next();

        userid = result.getInt("user_id");
        plantid = result.getInt("plant_id");
        location = result.getInt("location");
        waterlevel = result.getInt("water_level");


        return this;
    }



}
