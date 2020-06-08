
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.DatabaseTable;
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
@DatabaseTable(tableName = "users")
public class User implements Serializable {

    private final static Double STARTING_CASH = 1000.00;
    private final static int STARTING_GARDEN_SIZE = 5;
    private final static int STARTING_SCORE = 5;

    private DBConnect dbConnect = new DBConnect();

    @DatabaseField(generatedId = true)
    protected int user_id;
    @DatabaseField
    protected String login;
    @DatabaseField
    protected String password;
    @DatabaseField
    protected Double cash;
    @DatabaseField(columnName = "farm_age")
    protected int farmAge;
    @DatabaseField(columnName = "garden_size")
    protected int gardenSize;
    @DatabaseField
    protected int score;

    public static Dao<User, Integer> getDao(ConnectionSource cs) throws SQLException {
        return DaoManager.createDao(cs, User.class);
    }

    public String create() throws SQLException, ParseException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = getDao(cs);

        User user = new User();
        user.setLogin(login);
        user.setPassword(password);
        user.setCash(STARTING_CASH);
        user.setFarmAge(farmAge);
        user.setGardenSize(STARTING_GARDEN_SIZE);
        user.setScore(STARTING_SCORE);

        userDao.create(user);
        Garden.initalizeGarden(user.user_id, STARTING_GARDEN_SIZE);
        return "createUser";
    }

    public User getLoggedIn() throws SQLException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps
                = con.prepareStatement(
                        "select * from users where users.user_id = " + Util.getIDFromLogin());

        //get user data from database
        ResultSet result = ps.executeQuery();
        result.next();

        user_id = result.getInt("user_id");
        login = result.getString("login");
        password = result.getString("password");
        cash = result.getDouble("cash");
        farmAge = result.getInt("farm_age");
        gardenSize = result.getInt("garden_size");
        score = result.getInt("score");

        return this;
    }

    public static User getByUserid(Integer userid) throws SQLException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = getDao(cs);

        return userDao.queryForId(userid);
    }

    public String delete() throws SQLException, ParseException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }
        con.setAutoCommit(false);

        Statement statement = con.createStatement();
        statement.executeUpdate("Delete from users where users.id = " + user_id);
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

    public void validateUniqueLogin(FacesContext context, UIComponent componentToValidate, Object value)
            throws ValidatorException, SQLException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = getDao(cs);

        if (userDao.queryForEq("login", value).size() > 0) {
            FacesMessage errorMessage = new FacesMessage("Login is not unique");
            throw new ValidatorException(errorMessage);
        }
    }

    public String getCashAsDecimal() {
        return String.format("%.2f", this.cash);
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
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

    public Double getCash() {
        return cash;
    }

    public void setCash(Double cash) {
        this.cash = cash;
    }

    public int getFarmAge() {
        return farmAge;
    }

    public void setFarmAge(int farmAge) {
        this.farmAge = farmAge;
    }

    public int getGardenSize() {
        return gardenSize;
    }

    public void setGardenSize(int gardenSize) {
        this.gardenSize = gardenSize;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

}
