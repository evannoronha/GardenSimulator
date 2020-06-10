
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
        Dao<GrowBox, String> growBoxDao = new GrowBox().getDao(cs);
        Dao<PlantSpecies, Integer> plantSpeciesDao = new PlantSpecies().getDao(cs);

        for (int i = 1; i <= startingGardenSize * startingGardenSize; i++) {
            GrowBox box = new GrowBox();
            box.setUserid(userid);
            box.setLocation(i);
            box.setDay_planted(userid.getFarmAge());

            growBoxDao.create(box);
        }
        cs.close();
    }

    private int userid = Util.getInstance().getIDFromLogin();

    public List<GrowBox> getBoxes() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = new GrowBox().getDao(cs);

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
        Dao<GrowBox, String> growBoxDao = new GrowBox().getDao(cs);
        Dao<SeedInventory, Integer> seedInventoryDao = new SeedInventory().getDao(cs);

        HashMap<String, Object> boxParams = new HashMap();
        boxParams.put("user_id", userid);
        boxParams.put("location", updateLocation);

        HashMap<String, Object> seedParams = new HashMap();
        seedParams.put("user_id", userid);
        seedParams.put("seed_id", updateSeedId);

        List<GrowBox> boxResult = growBoxDao.queryForFieldValues(boxParams);
        List<SeedInventory> seedResult = seedInventoryDao.queryForFieldValues(seedParams);

        Dao<User, Integer> userDao = new User().getDao(cs);
        if (boxResult.isEmpty() || seedResult.isEmpty()) {
            cs.close();
            return;
        } else {
            GrowBox box = boxResult.get(0);
            box.setPlantid(PlantSpecies.getPlantSpeciesByID(updateSeedId));
            box.setDay_planted(Util.getInstance().getLoggedInUser().getFarmAge());
            growBoxDao.update(box);

            SeedInventory inv = seedResult.get(0);
            inv.setQuantity(inv.getQuantity() - 1);
            seedInventoryDao.update(inv);
            cs.close();
            System.out.println("\n\n\n" + updateLocation + "    " + updateSeedId + "   " + box.boxid);
        }
    }

    private Integer harvestLocation;

    public Integer getHarvestLocation() {
        return harvestLocation;
    }

    public void setHarvestLocation(Integer harvestLocation) {
        this.harvestLocation = harvestLocation;
    }

    public void harvestPlant() throws SQLException, IOException {
        if (harvestLocation == null) {
            return;
        }

        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = new GrowBox().getDao(cs);
        Dao<CropInventory, Integer> inventoryDao = new CropInventory().getDao(cs);

        HashMap<String, Object> boxParams = new HashMap();
        boxParams.put("user_id", userid);
        boxParams.put("location", harvestLocation);
        List<GrowBox> boxes = growBoxDao.queryForFieldValues(boxParams);

        if (boxes.isEmpty()) {
            cs.close();
            return;
        }

        PlantSpecies species;
        GrowBox box = boxes.get(0);
        try {
            species = (PlantSpecies) new PlantSpecies().getDao(cs).queryForId(box.getPlantid().getSpecies_id());
        } catch (NullPointerException e) {
            return;
        }

        box.setDay_planted(null);
        box.setPlantid(null);
        growBoxDao.update(box);

        HashMap<String, Object> cropParams = new HashMap();
        cropParams.put("user_id", userid);
        cropParams.put("crop_id", species.species_id);
        List<CropInventory> invs = inventoryDao.queryForFieldValuesArgs(cropParams);
        if (invs.isEmpty()) {
            CropInventory harvested = new CropInventory();
            harvested.setCrop_id(species);
            harvested.setQuantity(species.harvest_quantity);
            harvested.setUser_id(userid);
            inventoryDao.create(harvested);
        } else {
            CropInventory harvested = invs.get(0);
            harvested.setQuantity(harvested.getQuantity() + species.getHarvest_quantity());
            inventoryDao.update(harvested);
        }
        cs.close();
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
