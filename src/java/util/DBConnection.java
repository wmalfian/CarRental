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
            
            // Direct connection string from Railway
            String railwayUrl = "jdbc:mysql://ballast.proxy.rlwy.net:11092/railway" +
                               "?useSSL=true" +
                               "&requireSSL=true" +
                               "&verifyServerCertificate=false" +
                               "&allowPublicKeyRetrieval=true" +
                               "&serverTimezone=UTC";
            
            String railwayUser = "root";
            String railwayPassword = "ZqoHyWravfzvDSUbgmgynlCRuLbqfChU";
            
            // Attempt Railway connection
            System.out.println("Using Railway direct connection");
            conn = DriverManager.getConnection(railwayUrl, railwayUser, railwayPassword);
            System.out.println("Successfully connected to Railway MySQL database!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ SQL Connection Error: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            
            // Fallback to local if Railway fails
            System.out.println("Attempting local fallback...");
            try {
                String localUrl = "jdbc:mysql://localhost:3306/car_rental?useSSL=false";
                conn = DriverManager.getConnection(localUrl, "root", "admin");
                System.out.println("Connected to local MySQL database!");
            } catch (SQLException localEx) {
                System.err.println("Local fallback failed: " + localEx.getMessage());
            }
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