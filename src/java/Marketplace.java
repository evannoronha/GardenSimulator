
import Models.MarketListing;
import Models.PlantSpecies;
import Models.User;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Evan
 */
@Named(value = "marketplace")
@SessionScoped
@ManagedBean
public class Marketplace {

    public Integer purchaseListingId;
    private int userid = Util.getInstance().getIDFromLogin();

    public void setPurchaseListingId(Integer i) {
        purchaseListingId = i;
    }

    public Integer getPurchaseListingId() {
        return purchaseListingId;
    }

    public String visitMarketplace() {
        return "visitMarketplace";
    }

    public List<MarketListing> getListings() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();

        QueryBuilder<MarketListing, Integer> listingQb = new MarketListing().getDao(cs).queryBuilder();
        QueryBuilder<PlantSpecies, Integer> plantQb = new PlantSpecies().getDao(cs).queryBuilder();
        QueryBuilder<User, Integer> userQb = new User().getDao(cs).queryBuilder();
        userQb.where().ne("user_id", userid);

        List<MarketListing> listings = listingQb.join(plantQb).join(userQb).query();
        cs.close();
        return new MarketListing().getDao(cs).queryForAll();
    }

    public String purchaseListing() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao = new MarketListing().getDao(cs);
        MarketListing thisListing = listingDao.queryForId(purchaseListingId);

        Double salePrice = thisListing.getPrice();
        String type = thisListing.getListing_type();
        PlantSpecies species = thisListing.getPlant_id();
        Integer speciesId = species.getSpecies_id();
        Integer quantity = thisListing.getQuantity();
        Integer sellerId = thisListing.getSeller_id().getUser_id();

        //add to the current user's seed or crops
        if (type.equals("seeds")) {
            Seeds s = new Seeds(new PlantSpecies(speciesId), quantity);
            s.addToInventory();
        } else if (type.equals("crops")) {
            Crops c = new Crops(new PlantSpecies(speciesId), quantity);
            c.addToInventory();
        }

        //pay the seller
        Dao<User, Integer> userDao = new User().getDao(cs);
        User seller = userDao.queryForId(sellerId);
        seller.setCash(seller.getCash() + salePrice);
        userDao.update(seller);
        User buyer = Util.getInstance().getLoggedInUser();
        buyer.setCash(buyer.getCash() - salePrice);
        userDao.update(buyer);

        listingDao.deleteById(purchaseListingId);

        cs.close();

        return "success";
    }
}
