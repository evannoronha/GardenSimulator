
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import javax.annotation.ManagedBean;
import javax.el.ELContext;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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

    public static int getIDFromLogin() throws SQLException {
        ELContext elContext = FacesContext.getCurrentInstance().getELContext();
        Login elLogin = (Login) elContext.getELResolver().getValue(elContext, null, "login");

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = User.getDao(cs);

        List<User> users = userDao.queryForEq("login", elLogin.getLogin());
        return users.get(0).user_id;
    }

    public static String getBoxesJson() throws JSONException, SQLException {
        DBConnect dbConnect = new DBConnect();
        Connection con = dbConnect.getConnection();

        if (con == null) {
            throw new SQLException("Can't get database connection");
        }

        //DEFAULT accounts for serial column
        PreparedStatement preparedStatement = con.prepareStatement("select species_id, plant_image_url from plant_species;");

        ResultSet result = preparedStatement.executeQuery();

        HashMap<Integer, String> plantImgMap = new HashMap<>();

        while (result.next()) {
            plantImgMap.put(result.getInt("species_id"), result.getString("plant_image_url"));
        }

        JSONArray array = new JSONArray();
        JSONObject json = new JSONObject();

        ArrayList<GrowBox> growBoxList = Garden.getBoxes();
        for (GrowBox box : growBoxList) {
            JSONObject item = new JSONObject();
            item.put("plant_id", box.plantid);
            item.put("whenPlanted", box.whenPlanted);
            item.put("plant_url", plantImgMap.get(box.plantid));
            json.put(Integer.toString(box.location), item);
        }

//        item.put("url", "https://s3.amazonaws.com/pix.iemoji.com/images/emoji/apple/ios-12/256/ballot-box-with-check.png");
//        item.put("url", "https://imgur.com/fJORZNV");
        return json.toString();
    }
}
