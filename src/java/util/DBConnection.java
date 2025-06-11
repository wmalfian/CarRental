/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author wmalf
 */
import java.sql.*;

public class DBConnection {
    public static Connection getConnection() {
        Connection conn = null; // Initialize conn to null
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/car_rental", "root", "admin");
            System.out.println("Database connection established successfully!"); // Add this line
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("SQL Connection Error: " + e.getMessage());
            // For more detail, print the SQLState and ErrorCode
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) { // Catch any other unexpected exceptions
            System.err.println("An unexpected error occurred during DB connection: " + e.getMessage());
            e.printStackTrace();
        }
        return null; // Ensure null is returned if any exception occurs
    }
}

/*
public class DBConnection {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/car_rental", "admin1", "admin123");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
*/