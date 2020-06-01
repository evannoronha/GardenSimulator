
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.*;
import java.text.SimpleDateFormat;
import javax.annotation.ManagedBean;
import javax.el.ELContext;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;
import javax.servlet.http.HttpSession;

@Named(value = "util")
@SessionScoped
@ManagedBean
public class Util implements Serializable {

    public static void invalidateUserSession() {
        //invalidate user session
        FacesContext context = FacesContext.getCurrentInstance();
        HttpSession session = (HttpSession) context.getExternalContext().getSession(false);
        session.invalidate();
    }

    public void validateDate(FacesContext context, UIComponent component, Object value)
            throws Exception {

        try {
           Date d = (Date) value;
        } catch (Exception e) {
            FacesMessage errorMessage = new FacesMessage("Input is not a valid date");
            throw new ValidatorException(errorMessage);
        }
    }

    public static int getIDFromLogin() throws SQLException
    {
        ELContext elContext = FacesContext.getCurrentInstance().getELContext();
        Login elLogin = (Login) elContext.getELResolver().getValue(elContext, null, "login");

        DBConnect dbConnect = new DBConnect();
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        //DEFAULT accounts for serial column
        PreparedStatement preparedStatement = con.prepareStatement("select id from users where users.login = ?;");

        preparedStatement.setString(1, elLogin.getLogin());
        ResultSet result = preparedStatement.executeQuery();

        if (!result.next())
            return -1;
        return result.getInt("id");

    }
}
