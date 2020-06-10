package Models;


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
@DatabaseTable(tableName = "market_listings")
public class MarketListing extends LiveObject {

    @DatabaseField(generatedId = true, readOnly = true)
    private Integer listing_id;
    @DatabaseField(canBeNull = false, foreign = true, columnName = "seller_id", foreignAutoRefresh = true)
    private User seller_id;
    @DatabaseField(canBeNull = false, foreign = true, columnName = "plant_id", foreignAutoRefresh = true)
    private PlantSpecies plant_id;
    @DatabaseField(canBeNull = false)
    private Double price;
    @DatabaseField(canBeNull = false)
    private Integer quantity;
    @DatabaseField(canBeNull = false)
    private String listing_type;

    public MarketListing() {

    }

    public Integer getListing_id() {
        return listing_id;
    }

    public void setListing_id(Integer listing_id) {
        this.listing_id = listing_id;
    }

    public User getSeller_id() {
        return seller_id;
    }

    public void setSeller_id(User seller_id) {
        this.seller_id = seller_id;
    }

    public PlantSpecies getPlant_id() {
        return plant_id;
    }

    public void setPlant_id(PlantSpecies plant_id) {
        this.plant_id = plant_id;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getListing_type() {
        return listing_type;
    }

    public void setListing_type(String listing_type) {
        this.listing_type = listing_type;
    }

}
