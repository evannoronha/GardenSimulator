
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

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

    @DatabaseField(generatedId = true)
    private Integer user_id;
    @DatabaseField(canBeNull = false)
    private Integer seed_id;
    @DatabaseField(canBeNull = false)
    private Integer quantity;

    public SeedInventory() {
    }

    public SeedInventory(Integer user_id, Integer seed_id, Integer quantity) {
        this.user_id = user_id;
        this.seed_id = seed_id;
        this.quantity = quantity;
    }

    public Integer getUser_id() {
        return user_id;
    }

    public void setUser_id(Integer user_id) {
        this.user_id = user_id;
    }

    public Integer getSeed_id() {
        return seed_id;
    }

    public void setSeed_id(Integer seed_id) {
        this.seed_id = seed_id;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

}