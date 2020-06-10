
/**
 *
 * @author robert
 */
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.DatabaseTable;
import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

@Named(value = "growbox")
@SessionScoped
@ManagedBean
@DatabaseTable(tableName = "grow_boxes")
public class GrowBox extends LiveObject implements Serializable {

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
