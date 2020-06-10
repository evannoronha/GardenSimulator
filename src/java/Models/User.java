package Models;

import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = "users")
public class User extends LiveObject {

    public final static Double STARTING_CASH = 1000.00;
    public final static Integer STARTING_FARM_AGE = 0;
    public final static int STARTING_GARDEN_SIZE = 5;
    public final static int STARTING_SCORE = 5;

    @DatabaseField(generatedId = true, readOnly = true)
    protected int user_id;
    @DatabaseField
    protected String login;
    @DatabaseField
    protected String password;
    @DatabaseField
    protected Double cash;
    @DatabaseField(columnName = "farm_age")
    protected int farmAge;
    @DatabaseField(columnName = "garden_size")
    protected int gardenSize;
    @DatabaseField
    protected int score;

    public User() {
    }

    public String getCashAsDecimal() {
        return String.format("%.2f", this.cash);
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Double getCash() {
        return cash;
    }

    public void setCash(Double cash) {
        this.cash = cash;
    }

    public int getFarmAge() {
        return farmAge;
    }

    public void setFarmAge(int farmAge) {
        this.farmAge = farmAge;
    }

    public int getGardenSize() {
        return gardenSize;
    }

    public void setGardenSize(int gardenSize) {
        this.gardenSize = gardenSize;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

}
