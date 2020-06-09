
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.*;
import javax.annotation.ManagedBean;
import javax.el.ELContext;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.inject.Named;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@Named(value = "util")
@SessionScoped
@ManagedBean
public class Util implements Serializable {

    public static String invalidateUserSession() {
        //invalidate user session
        FacesContext context = FacesContext.getCurrentInstance();
        HttpSession session = (HttpSession) context.getExternalContext().getSession(false);
        session.invalidate();
        return "Logout";
    }

    public static int getIDFromLogin() throws SQLException, IOException {
        ELContext elContext = FacesContext.getCurrentInstance().getELContext();
        Login elLogin = (Login) elContext.getELResolver().getValue(elContext, null, "login");

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = User.getDao(cs);

        List<User> users = userDao.queryForEq("login", elLogin.getLogin());
        cs.close();
        return users.get(0).user_id;
    }

    public static String getBoxesJson() throws JSONException, SQLException, IOException {
        JSONArray array = new JSONArray();
        JSONObject json = new JSONObject();

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = User.getDao(cs);
        Dao<PlantSpecies, Integer> plantSpeciesDao = PlantSpecies.getDao(cs);

        json.put("farm_age", userDao.queryForId(Util.getIDFromLogin()).getFarmAge());
        List<GrowBox> growBoxList = Garden.getBoxes();
        for (GrowBox box : growBoxList) {
            JSONObject item = new JSONObject();

            item.put("plant_id", box.plantid);
            item.put("day_planted", box.day_planted);

            if (box.plantid != null) {
                PlantSpecies species = plantSpeciesDao.queryForId(box.plantid.species_id);
                item.put("plant_url", species.getPlant_image_url());
                item.put("daysToHarvest", species.getDays_to_harvest());
            }
            json.put(Integer.toString(box.location), item);
        }
        cs.close();
        return json.toString();
    }

    public static String getSeedsJson() throws JSONException, SQLException, IOException {
        JSONObject json = new JSONObject();
        Seeds s = new Seeds();

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<PlantSpecies, Integer> plantSpeciesDao = PlantSpecies.getDao(cs);

        List<SeedInventory> inventoryList = s.getSeeds();
        for (SeedInventory seed : inventoryList) {
            JSONObject item = new JSONObject();

            PlantSpecies species = plantSpeciesDao.queryForId(seed.getSeed_id().species_id);
            item.put("name", species.getName());
            item.put("quantity", seed.getQuantity());
            item.put("image_url", species.getPlant_image_url());
            json.put(Integer.toString(species.species_id), item);
        }
        cs.close();
        return json.toString();
    }
}
