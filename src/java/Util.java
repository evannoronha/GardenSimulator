
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
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

    public static String getBoxesJson() throws JSONException, SQLException, IOException {
        JSONArray array = new JSONArray();
        JSONObject json = new JSONObject();
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<PlantSpecies, Integer> plantSpeciesDao = PlantSpecies.getDao(cs);

        List<GrowBox> growBoxList = Garden.getBoxes();
        for (GrowBox box : growBoxList) {
            JSONObject item = new JSONObject();
            item.put("plant_id", box.plantid);
            item.put("day_planted", box.day_planted);
            item.put("plant_url", box.plantid.getPlant_image_url());
            json.put(Integer.toString(box.location), item);
        }
        cs.close();
        return json.toString();
    }
}
