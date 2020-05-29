
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    private DBConnect dbConnect = new DBConnect();

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
            throws ValidatorException, SQLException {
        this.login = loginUI.getLocalValue().toString();
        this.password = value.toString();

        Connection con = dbConnect.getConnection();
        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        PreparedStatement ps = con.prepareStatement("select password from users where login = ?");
        ps.setString(1, this.login);
        ResultSet result = ps.executeQuery();

        if (result.next()) {
            if (!password.equals(result.getString("password"))) {
                result.close();
                con.close();
                FacesMessage errorMessage = new FacesMessage("Wrong login/password");
                throw new ValidatorException(errorMessage);
            }
        }
        result.close();
        con.close();
    }


    public String go() throws SQLException {
        return "success";
    }

    public String createAccount() {
        return "createAccount";
    }
}
