/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author wmalf
 */
import java.sql.*;
import util.DBConnection;

public class AdminDAO {

    public int countUsers() {
        return getCount("SELECT COUNT(*) FROM users");
    }

    public int countCars() {
        return getCount("SELECT COUNT(*) FROM cars");
    }

    public int countBookings() {
        return getCount("SELECT COUNT(*) FROM bookings");
    }

    public double sumPayments() {
        double total = 0.0;
        String sql = "SELECT SUM(p.amount) FROM payments p " +
                     "JOIN bookings b ON p.booking_id = b.booking_id " +
                     "WHERE b.status = 'paid'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                total = rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
