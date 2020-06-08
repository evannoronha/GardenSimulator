
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "plant_species")
public class PlantSpecies {

    @DatabaseField(generatedId = true)
    protected Integer species_id;
    @DatabaseField(canBeNull = false)
    protected String name;
    @DatabaseField(canBeNull = false)
    protected String lifespan_type;
    @DatabaseField(canBeNull = false)
    protected Integer harvest_quantity;
    @DatabaseField(canBeNull = false)
    protected Integer days_to_harvest;
    @DatabaseField
    protected String plant_image_url;

    public PlantSpecies() {
    }

    public PlantSpecies(Integer species_id, String name, String lifespan_type, Integer harvest_quantity, Integer days_to_harvest, String plant_image_url) {
        this.species_id = species_id;
        this.name = name;
        this.lifespan_type = lifespan_type;
        this.harvest_quantity = harvest_quantity;
        this.days_to_harvest = days_to_harvest;
        this.plant_image_url = plant_image_url;
    }

    public Integer getSpecies_id() {
        return species_id;
    }

    public void setSpecies_id(Integer species_id) {
        this.species_id = species_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLifespan_type() {
        return lifespan_type;
    }

    public void setLifespan_type(String lifespan_type) {
        this.lifespan_type = lifespan_type;
    }

    public Integer getHarvest_quantity() {
        return harvest_quantity;
    }

    public void setHarvest_quantity(Integer harvest_quantity) {
        this.harvest_quantity = harvest_quantity;
    }

    public Integer getDays_to_harvest() {
        return days_to_harvest;
    }

    public void setDays_to_harvest(Integer days_to_harvest) {
        this.days_to_harvest = days_to_harvest;
    }

    public String getPlant_image_url() {
        return plant_image_url;
    }

    public void setPlant_image_url(String plant_image_url) {
        this.plant_image_url = plant_image_url;
    }
}
