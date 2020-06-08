
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
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

    public Crops() {
        super();
    }

    public Crops(PlantSpecies ps, int quantity) {
        super(ps, quantity);
    }

    public List<CropInventory> getCrops() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<CropInventory, Integer> inventoryDao = getDao(cs);
        int userid = Util.getIDFromLogin();
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

        int userid = Util.getIDFromLogin();

        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao
                = DaoManager.createDao(cs, MarketListing.class);

        Dao<PlantSpecies, Integer> plantDao
                = DaoManager.createDao(cs, PlantSpecies.class);
        PlantSpecies saleSpecies = plantDao.queryForId(saleSpeciesId);

        MarketListing listing = new MarketListing();

        listing.setSeller_id(userid);
        listing.setPlant_id(saleSpecies);
        listing.setPrice(salePrice);
        listing.setQuantity(saleQuantity);
        listing.setListing_type(this.typeName);
        listingDao.create(listing);

        Dao<CropInventory, Integer> inventoryDao = getDao(cs);

        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(this.plantIdColumn, saleSpeciesId);
        CropInventory inv = inventoryDao.queryForFieldValues(params).get(0);
        inv.setQuantity(inv.getQuantity() - saleQuantity);
        inventoryDao.update(inv);

        cs.close();
        return "success";
    }

    public Dao<CropInventory, Integer> getDao(ConnectionSource cs) throws SQLException {
        return DaoManager.createDao(cs, CropInventory.class);
    }

    public void userOwnsCrops(FacesContext context, UIComponent componentToValidate, Object value) throws SQLException, ValidatorException, IOException {
        int userid = Util.getIDFromLogin();
        int seedId = (Integer) (value);

        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();

        Dao<CropInventory, Integer> inventoryDao = getDao(cs);

        params.put("user_id", userid);
        params.put("crop_id", seedId);
        List<CropInventory> result = inventoryDao.queryForFieldValues(params);
        if (result.size() == 0) {
            FacesMessage errorMessage = new FacesMessage("You don't have any of those.");
            throw new ValidatorException(errorMessage);
        }
        cs.close();
    }

    public boolean userHasQuantity() throws SQLException, IOException {
        int userid = Util.getIDFromLogin();

        ConnectionSource cs = DBConnect.getConnectionSource();
        HashMap<String, Object> params = new HashMap();

        Dao<CropInventory, Integer> inventoryDao = getDao(cs);

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

    @Override
    public void addToInventory() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        int userid = Util.getIDFromLogin();
        Dao<CropInventory, Integer> inventoryDao
                = DaoManager.createDao(cs, CropInventory.class);
        HashMap<String, Object> params = new HashMap();
        params.put("user_id", userid);
        params.put(plantIdColumn, plantSpecies.getSpecies_id());
        CropInventory inv = inventoryDao.queryForFieldValues(params).get(0);
        inv.setQuantity(inv.getQuantity() + quantity);
        inventoryDao.update(inv);
        cs.close();
    }
}
