
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
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.ValidatorException;
import javax.inject.Named;

@Named(value = "crops")
@SessionScoped
@ManagedBean
public class Crops extends Harvestable implements Serializable {

    public static String typeName = "crops";
    public static String plantIdColumn = "crop_id";

    private Integer eatSpeciesId;
    private Integer eatQuantity;

    public Integer getEatSpeciesId() {
        return eatSpeciesId;
    }

    public void setEatSpeciesId(Integer eatSpeciesId) {
        this.eatSpeciesId = eatSpeciesId;
    }

    public Integer getEatQuantity() {
        return eatQuantity;
    }

    public void setEatQuantity(Integer eatQuantity) {
        this.eatQuantity = eatQuantity;
    }

    public Crops() {
        super();
    }

    public Crops(PlantSpecies ps, int quantity) {
        super(ps, quantity);
    }

    public List<CropInventory> getCrops() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<CropInventory, Integer> inventoryDao = new CropInventory().getDao(cs);
        List<CropInventory> result = inventoryDao.queryForEq("user_id", userid);
        cs.close();
        return result;
    }

    public String showCropInventory() {
        return "showCropInventory";
    }

    public String sell() throws SQLException, IOException {
        if (!this.userHasQuantity()) {
            return "fail";
        }

        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao = new MarketListing().getDao(cs);
        Dao<PlantSpecies, Integer> plantDao = new PlantSpecies().getDao(cs);

        PlantSpecies saleSpecies = plantDao.queryForId(saleSpeciesId);

        MarketListing listing = new MarketListing();

        listing.setSeller_id(User.getByUserid(userid));
        listing.setPlant_id(saleSpecies);
        listing.setPrice(salePrice);
        listing.setQuantity(saleQuantity);
        listing.setListing_type(this.typeName);
        listingDao.create(listing);

        Dao<CropInventory, Integer> inventoryDao = new CropInventory().getDao(cs);

        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(this.plantIdColumn, saleSpeciesId);
        CropInventory inv = inventoryDao.queryForFieldValues(params).get(0);
        inv.setQuantity(inv.getQuantity() - saleQuantity);
        inventoryDao.update(inv);

        cs.close();
        return "success";
    }

    public void userOwnsCrops(FacesContext context, UIComponent componentToValidate, Object value) throws SQLException, ValidatorException, IOException {
        int seedId = (Integer) (value);

        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();

        Dao<CropInventory, Integer> inventoryDao = new CropInventory().getDao(cs);

        params.put("user_id", userid);
        params.put("crop_id", seedId);
        List<CropInventory> result = inventoryDao.queryForFieldValues(params);
        if (result.size() == 0) {
            cs.close();
            FacesMessage errorMessage = new FacesMessage("You don't have any of those.");
            throw new ValidatorException(errorMessage);
        }
        cs.close();
    }

    public boolean userHasQuantity() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();

        Dao<CropInventory, Integer> inventoryDao = new CropInventory().getDao(cs);

        params.put("user_id", userid);
        params.put("crop_id", saleSpeciesId);
        List<CropInventory> result = inventoryDao.queryForFieldValues(params);
        cs.close();
        if (result.size() == 0) {
            return false;
        } else if (result.get(0).getQuantity() < saleQuantity) {
            return false;
        } else {
            return true;
        }
    }

    public void addToInventory() throws SQLException, IOException {
        //do I do quantity here? or pass in quantity as a variable
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<CropInventory, Integer> inventoryDao = new CropInventory().getDao(cs);
        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(plantIdColumn, plantSpecies.getSpecies_id());
        List<CropInventory> invList = inventoryDao.queryForFieldValues(params);

        if (invList.isEmpty()) {
            CropInventory newInv = new CropInventory();
            newInv.setQuantity(quantity);
            newInv.setCrop_id(plantSpecies);
            newInv.setUser_id(userid);
            inventoryDao.create(newInv);
        } else {
            CropInventory inv = invList.get(0);
            inv.setQuantity(inv.getQuantity() + quantity);
            inventoryDao.update(inv);
        }
        cs.close();
    }

    public String eatCrops() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<CropInventory, Integer> inventoryDao = new CropInventory().getDao(cs);
        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(plantIdColumn, eatSpeciesId);
        CropInventory inv = inventoryDao.queryForFieldValues(params).get(0);
        Integer pointsForEating = inv.getCrop_id().getPointsForEating() * this.eatQuantity;

        inv.setQuantity(inv.getQuantity() - eatQuantity);
        inventoryDao.update(inv);

        Dao<User, Integer> userDao = new User().getDao(cs);
        User thisUser = Util.getInstance().getLoggedInUser();
        thisUser.setScore(thisUser.getScore() + pointsForEating);
        userDao.update(thisUser);
        cs.close();
        return "success";
    }
}
