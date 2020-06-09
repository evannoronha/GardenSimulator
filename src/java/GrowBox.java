
/**
 *
 * @author robert
 */
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.DatabaseTable;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import java.text.ParseException;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

@Named(value = "growbox")
@SessionScoped
@ManagedBean
@DatabaseTable(tableName = "grow_boxes")
public class GrowBox implements Serializable {

    @DatabaseField(id = true, columnName = "box_uuid", canBeNull = true, readOnly = true)
    protected String boxid;
    @DatabaseField(columnName = "user_id", foreign = true, foreignAutoCreate = false, foreignAutoRefresh = false)
    protected User userid;
    @DatabaseField(columnName = "plant_id", foreign = true, foreignAutoCreate = false, foreignAutoRefresh = false, canBeNull = true)
    protected PlantSpecies plantid;
    @DatabaseField
    protected int location;
    @DatabaseField(canBeNull = true)
    protected Integer day_planted;

    public GrowBox() {

    }

    public GrowBox(User userid, PlantSpecies plantid, int location, int day_planted) {
        this.userid = userid;
        this.plantid = plantid;
        this.location = location;
        this.day_planted = day_planted;
    }

    public static Dao<GrowBox, String> getDao(ConnectionSource cs) throws SQLException {
        return DaoManager.createDao(cs, GrowBox.class);
    }

    public String create() throws SQLException, ParseException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = getDao(cs);

        GrowBox box = new GrowBox();
        box.setUserid(userid);
        box.setPlantid(plantid);
        box.setLocation(location);
        box.setDay_planted(userid.farmAge);

        growBoxDao.create(box);
        cs.close();
        return "createGardenBox";
    }

    public String getBoxid() {
        return boxid;
    }

    public void setBoxid(String boxid) {
        this.boxid = boxid;
    }

    public User getUserid() {
        return userid;
    }

    public void setUserid(User userid) {
        this.userid = userid;
    }

    public PlantSpecies getPlantid() {
        return plantid;
    }

    public void setPlantid(PlantSpecies plantid) {
        this.plantid = plantid;
    }

    public Integer getLocation() {
        return location;
    }

    public void setLocation(Integer location) {
        this.location = location;
    }

    public Integer getDay_planted() {
        return day_planted;
    }

    public void setDay_planted(Integer day_planted) {
        this.day_planted = day_planted;
    }

    public GrowBox get() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, String> growBoxDao = getDao(cs);

        GrowBox result = growBoxDao.queryForId(this.boxid);
        cs.close();
        return result;
    }
}
