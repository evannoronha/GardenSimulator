
import Models.GrowBox;
import Models.PlantSpecies;
import Models.SeedInventory;
import Models.User;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
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

    private static Util instance;

    private User loggedInUser;

    public static Util getInstance() {
        if (instance == null) {
            instance = new Util();
        }

        return instance;
    }

    public String invalidateUserSession() {
        //invalidate user session
        FacesContext context = FacesContext.getCurrentInstance();
        HttpSession session = (HttpSession) context.getExternalContext().getSession(false);
        session.invalidate();
        return "Logout";
    }

    public User getLoggedInUser() {
        if (this.loggedInUser != null) {
            return this.loggedInUser;
        }

        try {
            ELContext elContext = FacesContext.getCurrentInstance().getELContext();
            Login elLogin = (Login) elContext.getELResolver().getValue(elContext, null, "login");

            ConnectionSource cs = DBConnect.getConnectionSource();
            Dao<User, Integer> userDao = new User().getDao(cs);

            List<User> users = userDao.queryForEq("login", elLogin.getLogin());
            try {
                cs.close();
            } catch (IOException ex) {
                Logger.getLogger(Util.class.getName()).log(Level.SEVERE, null, ex);
                return null;
            }
            this.loggedInUser = users.get(0);
            return users.get(0);
        } catch (SQLException ex) {
            Logger.getLogger(Util.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    public int getIDFromLogin() {
        if (this.loggedInUser != null) {
            return this.loggedInUser.getUser_id();
        }

        return this.getLoggedInUser().getUser_id();
    }

    public static String getBoxesJson() throws JSONException, SQLException, IOException {
        JSONArray array = new JSONArray();
        JSONObject json = new JSONObject();

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<User, Integer> userDao = new User().getDao(cs);
        Dao<PlantSpecies, Integer> plantSpeciesDao = new PlantSpecies().getDao(cs);

        json.put("farm_age", userDao.queryForId(Util.getInstance().getIDFromLogin()).getFarmAge());
        Garden garden = new Garden();
        List<GrowBox> growBoxList = garden.getBoxes();
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
        Dao<PlantSpecies, Integer> plantSpeciesDao = new PlantSpecies().getDao(cs);

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
