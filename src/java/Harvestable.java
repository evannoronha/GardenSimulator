
public abstract class Harvestable {

    public static String typeName;

    protected DBConnect dbConnect = new DBConnect();
    protected PlantSpecies plantSpecies;
    protected Integer quantity;
    protected Integer saleQuantity;
    protected Double salePrice;
    protected Integer saleSpeciesId;

    public Harvestable() {
        plantSpecies = null;
        quantity = 0;
        this.saleQuantity = 0;
        this.salePrice = 0.0;
        this.saleSpeciesId = null;
    }

    public Harvestable(PlantSpecies ps, int quantity) {
        this.plantSpecies = ps;
        this.quantity = quantity;
        this.saleQuantity = 0;
        this.salePrice = 0.0;
        this.saleSpeciesId = null;
    }

    public void setQuantity(Integer q) {
        this.quantity = q;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setSaleQuantity(Integer q) {
        this.saleQuantity = q;
    }

    public Integer getSaleQuantity() {
        return saleQuantity;
    }

    public PlantSpecies getPlantSpecies() {
        return plantSpecies;
    }

    public Double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(Double s) {
        salePrice = s;
    }

    public Integer getSaleSpeciesId() {
        return this.saleSpeciesId;
    }

    public void setSaleSpeciesId(Integer s) {
        this.saleSpeciesId = s;
    }

    public String home() {
        return "home";
    }

}
