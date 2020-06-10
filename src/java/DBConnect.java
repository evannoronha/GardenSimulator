
import com.j256.ormlite.jdbc.JdbcConnectionSource;
import com.j256.ormlite.support.ConnectionSource;
import java.sql.SQLException;

public class DBConnect {

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

    public static ConnectionSource getConnectionSource() throws SQLException {
        String databaseUrl = "jdbc:postgresql://ambari-node5.csc.calpoly.edu/team1";
        // create a connection source to our database
        return new JdbcConnectionSource(databaseUrl, "team1", "csc366");
    }
}
