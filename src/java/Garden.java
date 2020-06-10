
import Models.CropInventory;
import Models.GrowBox;
import Models.PlantSpecies;
import Models.SeedInventory;
import Models.User;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import javax.annotation.ManagedBean;
import javax.faces.application.FacesMessage;
import javax.faces.bean.SessionScoped;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;

/**
 *
 * @author robert
 */
@Named(value = "garden")
@SessionScoped
@ManagedBean
public class Garden implements Serializable {

    public final static Integer PENALTY_FOR_ADVANCING_DAYS = 1;
    private User user = Util.getInstance().getLoggedInUser();

    public Integer getPENALTY_FOR_ADVANCING_DAYS() {
        return PENALTY_FOR_ADVANCING_DAYS;
    }

    public static void initalizeGarden(User userid) throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = new GrowBox().getDao(cs);
        Dao<PlantSpecies, Integer> plantSpeciesDao = new PlantSpecies().getDao(cs);
        int startingGardenSize = User.STARTING_GARDEN_SIZE;
        for (int i = 1; i <= startingGardenSize * startingGardenSize; i++) {
            GrowBox box = new GrowBox();
            box.setUserid(userid);
            box.setLocation(i);
            box.setDay_planted(userid.getFarmAge());

            growBoxDao.create(box);
        }
        cs.close();
    }

    public String advanceTime() throws SQLException, IOException {
        if (user.getScore() == 0) {
            FacesMessage errorMessage = new FacesMessage("You do not have any points. Eat something.");
            throw new ValidatorException(errorMessage);
        } else {
            user.setScore(user.getScore() - Garden.PENALTY_FOR_ADVANCING_DAYS);
            user.setFarmAge(user.getFarmAge() + 1);
            ConnectionSource cs = DBConnect.getConnectionSource();
            Dao<User, Integer> userDao = new User().getDao(cs);
            userDao.update(user);
            cs.close();
            return "ViewGarden";
        }
    }

    public boolean canNotAdvance() {
        return user.getScore() < Garden.PENALTY_FOR_ADVANCING_DAYS;
    }
    private int userid = Util.getInstance().getIDFromLogin();

    public List<GrowBox> getBoxes() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = new GrowBox().getDao(cs);

        List<GrowBox> result = growBoxDao.queryForEq("user_id", userid);
        cs.close();
        return result;
    }

    private int updateLocation;
    private int updateSeedId;

    public void plantSeed() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = new GrowBox().getDao(cs);
        Dao<SeedInventory, Integer> seedInventoryDao = new SeedInventory().getDao(cs);
        Dao<PlantSpecies, Integer> plantSpeciesDao = new PlantSpecies().getDao(cs);

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
            box.setPlantid(plantSpeciesDao.queryForId(updateSeedId));
            box.setDay_planted(Util.getInstance().getLoggedInUser().getFarmAge());
            growBoxDao.update(box);

            SeedInventory inv = seedResult.get(0);
            inv.setQuantity(inv.getQuantity() - 1);
            seedInventoryDao.update(inv);
            cs.close();
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
        Dao<PlantSpecies, Integer> plantSpeciesDao = new PlantSpecies().getDao(cs);

        HashMap<String, Object> boxParams = new HashMap();
        boxParams.put("user_id", userid);
        boxParams.put("location", harvestLocation);
        List<GrowBox> boxes = growBoxDao.queryForFieldValues(boxParams);

        if (boxes.isEmpty()) {
            cs.close();
            return;
        }

        GrowBox box = boxes.get(0);

        PlantSpecies species = plantSpeciesDao.queryForId(box.getPlantid().getSpecies_id());

        box.setDay_planted(null);
        box.setPlantid(null);
        growBoxDao.update(box);

        HashMap<String, Object> cropParams = new HashMap();
        cropParams.put("user_id", userid);
        cropParams.put("crop_id", species.getSpecies_id());
        List<CropInventory> invs = inventoryDao.queryForFieldValuesArgs(cropParams);
        if (invs.isEmpty()) {
            CropInventory harvested = new CropInventory();
            harvested.setCrop_id(species);
            harvested.setQuantity(species.getHarvest_quantity());
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
