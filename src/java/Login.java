
import Models.User;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import javax.annotation.ManagedBean;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.component.UIComponent;
import javax.faces.component.UIInput;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;

@Named(value = "login")
@SessionScoped
@ManagedBean
public class Login implements Serializable {

    private String login;

    private String password;
    private UIInput loginUI;

    public UIInput getLoginUI() {
        return loginUI;
    }

    public void setLoginUI(UIInput loginUI) {
        this.loginUI = loginUI;
    }

    public String getLogin() {
        return this.login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getPassword() {
        return this.password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void validate(FacesContext context, UIComponent component, Object value)
            throws ValidatorException, SQLException, IOException {
        this.login = loginUI.getLocalValue().toString();
        this.password = value.toString();

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = new User().getDao(cs);

        List<User> user = userDao.queryForEq("login", this.login);
        cs.close();
        if (user.size() == 0) {
            FacesMessage errorMessage = new FacesMessage("Login not found");
            throw new ValidatorException(errorMessage);
        } else if (!user.get(0).getPassword().equals(this.password)) {
            FacesMessage errorMessage = new FacesMessage("Wrong login/password");
            throw new ValidatorException(errorMessage);
        }
    }

    public void validateUniqueLogin(FacesContext context, UIComponent componentToValidate, Object value)
            throws ValidatorException, SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = new User().getDao(cs);

        if (userDao.queryForEq("login", value).size() > 0) {
            FacesMessage errorMessage = new FacesMessage("Login is not unique");
            cs.close();
            throw new ValidatorException(errorMessage);
        } else {
            cs.close();
        }
    }

    public String createUser() throws SQLException, ParseException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = new User().getDao(cs);

        User user = new User();
        user.setLogin(login);
        user.setPassword(password);
        user.setCash(User.STARTING_CASH);
        user.setFarmAge(User.STARTING_FARM_AGE);
        user.setGardenSize(User.STARTING_GARDEN_SIZE);
        user.setScore(User.STARTING_SCORE);

        userDao.create(user);
        cs.close();
        Garden.initalizeGarden(user);
        return "createUser";
    }

    public String go() throws SQLException {
        return "success";
    }

    public String createAccount() {
        return "createAccount";
    }

}
