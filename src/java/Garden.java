
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

/**
 *
 * @author robert
 */
@Named(value = "garden")
@SessionScoped
@ManagedBean
public class Garden implements Serializable {

    private static ArrayList<GrowBox> growBoxList;

    public static void initalizeGarden(User userid, int startingGardenSize) throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = GrowBox.getDao(cs);
        Dao<PlantSpecies, Integer> plantSpeciesDao = PlantSpecies.getDao(cs);

        for (int i = 1; i <= startingGardenSize * startingGardenSize; i++) {
            GrowBox box = new GrowBox();
            box.setUserid(userid);
            box.setLocation(i);
            box.setDay_planted(userid.getFarmAge());

            growBoxDao.create(box);
        }
        cs.close();
    }

    public static List<GrowBox> getBoxes() throws SQLException, IOException {
        int userid = Util.getIDFromLogin();
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = GrowBox.getDao(cs);

        List<GrowBox> result = growBoxDao.queryForEq("user_id", userid);
        cs.close();
        return result;
    }

    public String viewGarden() {
        return "ViewGarden";
    }

    private int updateLocation;
    private int updateSeedId;

    public void updatePlant() throws SQLException, IOException {

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = GrowBox.getDao(cs);

        HashMap<String, Object> params = new HashMap();

        params.put("user_id", Util.getIDFromLogin());

        params.put("location", updateLocation);
        List<GrowBox> result = growBoxDao.queryForFieldValues(params);

        if (result.isEmpty()) {
            cs.close();
            return;
        } else {
            GrowBox box = result.get(0);
            box.setPlantid(PlantSpecies.getPlantSpeciesByID(updateSeedId));

            growBoxDao.update(box);
            cs.close();
            System.out.println("\n\n\n" + updateLocation + "    " + updateSeedId + "   " + box.boxid);
        }
    }

    public int getUpdateLocation() {
        return updateLocation;
    }

    public void setUpdateLocation(int updateLocation) {
        this.updateLocation = updateLocation;
    }

    public int getUpdateSeedId() {
        return updateSeedId;
    }

    public void setUpdateSeedId(int updateSeedId) {
        this.updateSeedId = updateSeedId;
    }

}
