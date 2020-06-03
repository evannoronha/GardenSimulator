
import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
public class Garden implements Serializable{

    private static DBConnect dbConnect = new DBConnect();

    public static void initalizeGarden(int userid, int startingGardenSize) throws SQLException
    {
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
        String bulkInsert = "Insert into grow_boxes (box_id, user_id, plant_id, location, water_level) values";

        for (int i = 1; i < startingGardenSize * startingGardenSize; i++)
        {

            bulkInsert += ("(DEFAULT, " + userid + ", " + startingPlantId + ", " + i + ", " + startingWaterLevel + "),");
        }

        bulkInsert += ("(DEFAULT, " + userid + ", " + startingPlantId + ", " +
                (startingGardenSize * startingGardenSize) + ", " + startingWaterLevel + ");");


       PreparedStatement preparedStatement = con.prepareStatement(bulkInsert);
       preparedStatement.executeUpdate();

       con.commit();
       con.close();
    }

}
