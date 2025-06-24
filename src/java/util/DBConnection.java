package util;

import java.sql.*;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Get environment variables from Railway
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String dbName = System.getenv("MYSQLDATABASE");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");

            // Construct JDBC URL
            String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false";

            // Create connection
            conn = DriverManager.getConnection(url, user, pass);
            System.out.println("✅ Database connection established successfully!");
            return conn;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ SQL Connection Error: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Unexpected DB error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
