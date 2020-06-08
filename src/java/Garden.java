
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.annotation.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.inject.Named;

/**
 *
 * @author robert
 */
@Named(value = "garden")
@SessionScoped
@ManagedBean
public class Garden implements Serializable {

    private static DBConnect dbConnect = new DBConnect();
    private static ArrayList<GrowBox> growBoxList;

    public static void initalizeGarden(int userid, int startingGardenSize) throws SQLException {
        Connection con = dbConnect.getConnection();

        if (con == null) {
            try {
                throw new SQLException("Can't get database connection");
            } catch (SQLException ex) {
                System.out.println("SQLException");
            }
        }

        int startingPlantId = 0;
        int startingWaterLevel = 0;

        System.out.println(startingGardenSize);
        con.setAutoCommit(false);
        String bulkInsert = "Insert into grow_boxes (box_id, user_id, plant_id, location, day_planted) values";

        for (int i = 1; i < startingGardenSize * startingGardenSize; i++) {
            bulkInsert += ("(DEFAULT, "
                    + userid
                    + ", "
                    + startingPlantId
                    + ", "
                    + i
                    + ", "
                    + User.getByUserid(userid).farmAge
                    + "),");
        }

        bulkInsert += ("(DEFAULT, "
                + userid
                + ", "
                + startingPlantId
                + ", "
                + (startingGardenSize * startingGardenSize)
                + ", "
                + User.getByUserid(userid).farmAge
                + ");");

        PreparedStatement preparedStatement = con.prepareStatement(bulkInsert);
        preparedStatement.executeUpdate();

        con.commit();
        con.close();
    }

    public static ArrayList<GrowBox> getBoxes() throws SQLException {
        int userid = Util.getIDFromLogin();
        Connection con = dbConnect.getConnection();
        growBoxList = new ArrayList<>();

        PreparedStatement ps = con.prepareStatement(
                "select * from grow_boxes where grow_boxes.user_id = ?");

        ps.setInt(1, userid);

        ResultSet result = ps.executeQuery();
        while (result.next()) {
            int boxid = result.getInt("box_id");
            int plantid = result.getInt("plant_id");
            int location = result.getInt("location");
            int whenPlanted = result.getInt("location");

            GrowBox growBoxToCreate = new GrowBox(boxid, userid, plantid, location);
            growBoxList.add(growBoxToCreate);
        }

        for (GrowBox box : growBoxList) {
            System.out.println(box.boxid + " " + box.userid + " " + box.plantid + " " + box.location);
        }

        return growBoxList;
    }

}
