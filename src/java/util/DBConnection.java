package util;

import java.sql.*;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Try to get Railway environment variables first
            String railwayDB = System.getenv("MySQLDATABASE");
            String railwayHost = System.getenv("MySQLHOST");
            String railwayPort = System.getenv("MySQLPORT");
            String railwayUser = System.getenv("MySQLUSER");
            String railwayPassword = System.getenv("MySQLPASSWORD");
            
            if (railwayHost != null && railwayPort != null && railwayDB != null) {
                // Connect to Railway database
                String jdbcUrl = "jdbc:mysql://" + railwayHost + ":" + railwayPort + "/" + railwayDB;
                conn = DriverManager.getConnection(jdbcUrl, railwayUser, railwayPassword);
                System.out.println("Connected to Railway MySQL database!");
            } else {
                // Fallback to local database
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/car_rental", "root", "admin");
                System.out.println("Connected to local MySQL database!");
            }
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("SQL Connection Error: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
