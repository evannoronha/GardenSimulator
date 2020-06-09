
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.dao.DaoManager;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.DatabaseTable;
import java.sql.SQLException;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Evan
 */
@DatabaseTable(tableName = "has_seeds")
public class SeedInventory {

    @DatabaseField(generatedId = true, readOnly = true)
    private Integer seed_inventory_id;
    @DatabaseField
    private Integer user_id;
    @DatabaseField(canBeNull = false, foreign = true, foreignAutoCreate = false, foreignAutoRefresh = true, columnName = "seed_id")
    private PlantSpecies seed_id;
    @DatabaseField(canBeNull = false)
    private Integer quantity;

    public SeedInventory() {
    }

    public SeedInventory(Integer user_id, PlantSpecies seed_id, Integer quantity) {
        this.user_id = user_id;
        this.seed_id = seed_id;
        this.quantity = quantity;
    }

    public static Dao<SeedInventory, Integer> getDao(ConnectionSource cs) throws SQLException {
        return DaoManager.createDao(cs, SeedInventory.class);
    }

    public Integer getUser_id() {
        return user_id;
    }

    public void setUser_id(Integer user_id) {
        this.user_id = user_id;
    }

    public PlantSpecies getSeed_id() {
        return seed_id;
    }

    public void setSeed_id(PlantSpecies seed_id) {
        this.seed_id = seed_id;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

}
