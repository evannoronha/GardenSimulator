
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.DatabaseTable;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
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
    public final static Integer PENALTY_FOR_ADVANCING_DAYS = 1;

    public Integer getPENALTY_FOR_ADVANCING_DAYS() {
        return PENALTY_FOR_ADVANCING_DAYS;
    }
    private final static int STARTING_GARDEN_SIZE = 5;
    private final static int STARTING_SCORE = 5;

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

    public String create() throws SQLException, ParseException, IOException {
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
        cs.close();
        Garden.initalizeGarden(user, STARTING_GARDEN_SIZE);
        return "createUser";
    }

    public User getLoggedIn() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = getDao(cs);
        User user = userDao.queryForId(Util.getIDFromLogin());
        cs.close();
        return user;
    }

    public static User getByUserid(Integer userid) throws SQLException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = getDao(cs);

        return userDao.queryForId(userid);
    }

    public void validateUniqueLogin(FacesContext context, UIComponent componentToValidate, Object value)
            throws ValidatorException, SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = getDao(cs);

        if (userDao.queryForEq("login", value).size() > 0) {
            FacesMessage errorMessage = new FacesMessage("Login is not unique");
            cs.close();
            throw new ValidatorException(errorMessage);
        } else {
            cs.close();
        }
    }

    public String advanceTime() throws SQLException {
        if (this.score == 0) {
            FacesMessage errorMessage = new FacesMessage("You do not have any points. Eat something.");
            throw new ValidatorException(errorMessage);
        } else {
            this.score -= this.PENALTY_FOR_ADVANCING_DAYS;
            this.farmAge += 1;
            ConnectionSource cs = DBConnect.getConnectionSource();
            Dao<User, Integer> userDao = getDao(cs);
            userDao.update(this);
            return "ViewGarden";
        }
    }

        userDao.update(this);
        return "ViewGarden";
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
