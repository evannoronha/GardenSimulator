package Models;


import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "crops_inventory")

public class CropInventory extends LiveObject {

    @DatabaseField(generatedId = true, readOnly = true)
    private Integer crops_inventory_id;
    @DatabaseField(canBeNull = false)
    private Integer user_id;
    @DatabaseField(canBeNull = false, foreign = true, foreignAutoRefresh = true, columnName = "crop_id")
    private PlantSpecies crop_id;
    @DatabaseField(canBeNull = false)
    private Integer quantity;

    public CropInventory() {
    }

    public Integer getUser_id() {
        return user_id;
    }

    public void setUser_id(Integer user_id) {
        this.user_id = user_id;
    }

    public PlantSpecies getCrop_id() {
        return crop_id;
    }

    public void setCrop_id(PlantSpecies crop_id) {
        this.crop_id = crop_id;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
