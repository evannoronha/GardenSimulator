
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.support.ConnectionSource;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
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

    public void setPurchaseListingId(Integer i) {
        purchaseListingId = i;
    }

    public Integer getPurchaseListingId() {
        return purchaseListingId;
    }

    public String visitMarketplace() {
        return "visitMarketplace";
    }

    public List<MarketListing> getCurrentUserListings() throws SQLException, IOException {
        int userid = Util.getIDFromLogin();
        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao
                = DaoManager.createDao(cs, MarketListing.class);

        //unsure how to query for not this user
        List<MarketListing> allListings = listingDao.queryForAll();
        List<MarketListing> myListings = new ArrayList<>();
        for (MarketListing ml : allListings) {
            if (ml.getSeller_id() == userid) {
                myListings.add(ml);
            }
        }
        cs.close();
        return myListings;
    }

    public List<MarketListing> getOtherUserListings() throws SQLException, IOException {
        int userid = Util.getIDFromLogin();
        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao = MarketListing.getDao(cs);

        List<MarketListing> allListings = listingDao.queryForAll();
        List<MarketListing> otherUserListings = new ArrayList<>();
        for (MarketListing ml : allListings) {
            if (ml.getSeller_id().user_id != userid) {
                otherUserListings.add(ml);
            }
        }
        cs.close();
        return otherUserListings;
    }

    public String purchaseListing() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();

        int userid = Util.getIDFromLogin();
        System.out.println(purchaseListingId);

        //get values from current listing
        Dao<MarketListing, Integer> listingDao
                = DaoManager.createDao(cs, MarketListing.class);

        MarketListing thisListing = listingDao.queryForId(purchaseListingId);

        Double salePrice = thisListing.getPrice();
        String type = thisListing.getListing_type();
        PlantSpecies species = thisListing.getPlant_id();
        Integer speciesId = species.getSpecies_id();
        Integer quantity = thisListing.getQuantity();
        Integer sellerId = thisListing.getSeller_id().user_id;

        //add to the current user's seed or crops
        if (type.equals("seeds")) {
            Seeds s = new Seeds(new PlantSpecies(speciesId), quantity);
            s.addToInventory();
        } else if (type.equals("crops")) {
            Crops c = new Crops(new PlantSpecies(speciesId), quantity);
            c.addToInventory();
        }

        //pay the seller
        Dao<User, Integer> userDao
                = DaoManager.createDao(cs, User.class);
        User seller = userDao.queryForId(sellerId);
        seller.setCash(seller.getCash() + salePrice);
        userDao.update(seller);
        User buyer = userDao.queryForId(userid);
        buyer.setCash(buyer.getCash() - salePrice);
        userDao.update(buyer);

        listingDao.deleteById(purchaseListingId);

        cs.close();

        return "success";
    }

}
