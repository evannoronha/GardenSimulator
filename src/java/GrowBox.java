
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

    @DatabaseField(generatedId = true, columnName = "box_id")
    protected int boxid;
    @DatabaseField(columnName = "user_id", foreign = true, foreignAutoCreate = true, foreignAutoRefresh = true)
    protected User userid;
    @DatabaseField(columnName = "plant_id")
    protected int plantid;
    @DatabaseField
    protected int location;
    @DatabaseField()
    protected int day_planted;

    public GrowBox() {
    }

    public GrowBox(User userid, int plantid, int location, int day_planted) {
        this.userid = userid;
        this.plantid = plantid;
        this.location = location;
        this.day_planted = day_planted;
    }

    public static Dao<GrowBox, Integer> getDao(ConnectionSource cs) throws SQLException {
        return DaoManager.createDao(cs, GrowBox.class);
    }

    public String create() throws SQLException, ParseException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, Integer> growBoxDao = getDao(cs);

        GrowBox box = new GrowBox();
        box.setUserid(userid);
        box.setPlantid(plantid);
        box.setLocation(location);
        box.setDay_planted(userid.farmAge);

        growBoxDao.create(box);
        cs.close();
        return "createGardenBox";
    }

    public int getBoxid() {
        return boxid;
    }

    public void setBoxid(int boxid) {
        this.boxid = boxid;
    }

    public User getUserid() {
        return userid;
    }

    public void setUserid(User userid) {
        this.userid = userid;
    }

    public int getPlantid() {
        return plantid;
    }

    public void setPlantid(int plantid) {
        this.plantid = plantid;
    }

    public int getLocation() {
        return location;
    }

    public void setLocation(int location) {
        this.location = location;
    }

    public int getDay_planted() {
        return day_planted;
    }

    public void setDay_planted(int day_planted) {
        this.day_planted = day_planted;
    }

    public GrowBox get() throws SQLException, IOException {
        ConnectionSource cs = DBConnect.getConnectionSource();
        Dao<GrowBox, Integer> growBoxDao = getDao(cs);

        GrowBox result = growBoxDao.queryForId(boxid);
        cs.close();
        return result;
    }
}
