
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

@Named(value = "user")
@SessionScoped
@ManagedBean
public class User implements Serializable {

    private final Double STARTING_CASH = 1000.00;
    private final static int STARTING_GARDEN_SIZE = 5;

    private DBConnect dbConnect = new DBConnect();
    protected static int userid;
    protected String login;
    protected String password;
    protected Double cash;
    protected int farmAge;
    protected static int gardenSize;

    public String create() throws SQLException, ParseException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        //DEFAULT accounts for serial column
        PreparedStatement preparedStatement = con.prepareStatement("Insert into users values(DEFAULT,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);

        preparedStatement.setString(1, login);
        preparedStatement.setString(2, password);
        preparedStatement.setDouble(3, STARTING_CASH);
        preparedStatement.setInt(4, 0); //Starting Day
        preparedStatement.setInt(5, STARTING_GARDEN_SIZE);

        preparedStatement.executeUpdate();

        ResultSet rs = preparedStatement.getGeneratedKeys();
        if (rs.next()) {
            userid = rs.getInt(1);
        }

        con.commit();
        con.close();

        Garden.initalizeGarden(userid, STARTING_GARDEN_SIZE);
        return "createUser";
    }

    public User get() throws SQLException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps
                = con.prepareStatement(
                        "select * from users where users.id = " + Util.getIDFromLogin());

        //get user data from database
        ResultSet result = ps.executeQuery();
        result.next();

        userid = result.getInt("id");
        login = result.getString("login");
        password = result.getString("password");
        cash = result.getDouble("cash");
        farmAge = result.getInt("farm_age");
        gardenSize = result.getInt("garden_size");

        return this;
    }

    public String delete() throws SQLException, ParseException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        Statement statement = con.createStatement();
        statement.executeUpdate("Delete from users where users.id = " + userid);
        statement.close();
        con.commit();
        con.close();

        return "main";
    }

    public void userIDExists(FacesContext context, UIComponent componentToValidate, Object value)
            throws ValidatorException, SQLException {

        if (!existsUserId((Integer) value)) {
            FacesMessage errorMessage = new FacesMessage("ID does not exist");
            throw new ValidatorException(errorMessage);
        }
    }

    private boolean existsUserId(int id) throws SQLException {
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps = con.prepareStatement("select * from users where users.id = " + id);

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

    private boolean loginExists(String login) throws SQLException {
        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps = con.prepareStatement("select * from users where users.login = ?");
        ps.setString(1, login);
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

    public void validateUniqueLogin(FacesContext context, UIComponent componentToValidate, Object value)
            throws ValidatorException, SQLException {

        if (loginExists((value.toString()))) {
            FacesMessage errorMessage = new FacesMessage("Login is not unique");
            throw new ValidatorException(errorMessage);
        }
    }

    public Integer getUserid() {
        return userid;
    }

    public void setUserid(Integer userid) {
        this.userid = userid;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getGardenSize() {
        return gardenSize;
    }

}
