
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.support.ConnectionSource;
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

    public String visitMarketplace() {
        return "visitMarketplace";
    }

    public List<MarketListing> getListings() throws SQLException {
        ConnectionSource cs = DBConnect.getConnectionSource();

        Dao<MarketListing, Integer> listingDao
                = DaoManager.createDao(cs, MarketListing.class);

        return listingDao.queryForAll();
    }
}
