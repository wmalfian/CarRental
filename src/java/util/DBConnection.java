package util;

import java.sql.*;

public class DBConnection {
    public static Connection getConnection() {
        System.out.println("Attempting to connect to database...");
        Connection conn = null;
        
        try {
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully");
            
            // Get Railway environment variables
            String railwayHost = System.getenv("MySQLHOST");
            String railwayPort = System.getenv("MySQLPORT");
            String railwayDB = System.getenv("MySQLDATABASE");
            String railwayUser = System.getenv("MySQLUSER");
            String railwayPassword = System.getenv("MySQLPASSWORD");
            
            // Use 'railway' as default database name if not specified
            if (railwayDB == null || railwayDB.isEmpty()) {
                railwayDB = "railway";
                System.out.println("Using default database name: railway");
            }
            
            // Log obtained environment variables
            System.out.println("Railway Host: " + railwayHost);
            System.out.println("Railway Port: " + railwayPort);
            System.out.println("Railway DB: " + railwayDB);
            System.out.println("Railway User: " + railwayUser);
            // Don't log password in production!
            
            // Check if we're in Railway environment
            if (railwayHost != null && railwayPort != null) {
                System.out.println("Detected Railway environment");
                
                // Construct JDBC URL with required parameters
                String jdbcUrl = "jdbc:mysql://" + railwayHost + ":" + railwayPort + 
                                 "/" + railwayDB +
                                 "?useSSL=true" +
                                 "&requireSSL=true" +
                                 "&verifyServerCertificate=false" +
                                 "&allowPublicKeyRetrieval=true" +
                                 "&serverTimezone=UTC";
                
                System.out.println("Using JDBC URL: " + jdbcUrl);
                
                // Attempt connection
                conn = DriverManager.getConnection(jdbcUrl, railwayUser, railwayPassword);
                System.out.println("Successfully connected to Railway MySQL database!");
            } else {
                System.out.println("Falling back to local development");
                
                // Local connection
                String localUrl = "jdbc:mysql://localhost:3306/car_rental?useSSL=false";
                conn = DriverManager.getConnection(localUrl, "root", "admin");
                System.out.println("Connected to local MySQL database!");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("❌ JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ SQL Connection Error: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }
        
        if (conn == null) {
            System.err.println("⚠️⚠️⚠️ CRITICAL: Database connection is NULL ⚠️⚠️⚠️");
        }
        
        return conn;
    }
}