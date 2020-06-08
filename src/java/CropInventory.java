
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "crops_inventory")

public class CropInventory {

    @DatabaseField(generatedId = true)
    private Integer user_id;
    @DatabaseField(canBeNull = false)
    private Integer crop_id;
    @DatabaseField(canBeNull = false)
    private Integer quantity;

    public CropInventory() {
    }

    public CropInventory(Integer user_id, Integer crop_id, Integer quantity) {
        this.user_id = user_id;
        this.crop_id = crop_id;
        this.quantity = quantity;
    }

    public Integer getUser_id() {
        return user_id;
    }

    public void setUser_id(Integer user_id) {
        this.user_id = user_id;
    }

    public Integer getCrop_id() {
        return crop_id;
    }

    public void setCrop_id(Integer crop_id) {
        this.crop_id = crop_id;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
