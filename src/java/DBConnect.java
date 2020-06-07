
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    public Connection getConnection() {
        Connection connection = null;

        try {
            connection = DriverManager.getConnection(
                    "jdbc:postgresql://ambari-node5.csc.calpoly.edu/team1", "team1",
                    "csc366"); //Was going to make .env for token but private repo so who cares

        } catch (SQLException e) {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return null;
        }
        return connection;
    }

    public DBConnect() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Where is your PostgreSQL JDBC Driver? "
                    + "Include in your library path!");
            e.printStackTrace();
            return;
        }
    }
}
