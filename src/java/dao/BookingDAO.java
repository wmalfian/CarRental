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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Booking;
import util.DBConnection;

public class BookingDAO {

    public int createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (user_id, car_id, start_date, end_date, total_cost, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getCarId());
            stmt.setDate(3, booking.getStartDate());
            stmt.setDate(4, booking.getEndDate());
            stmt.setDouble(5, booking.getTotalCost());
            stmt.setString(6, booking.getStatus());

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1); // return generated booking_id
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // or throw exception if you prefer
    }

    
    public void cancelBooking(int bookingId) {
        String getCarIdSql = "SELECT car_id FROM bookings WHERE booking_id=?";
        String cancelSql = "UPDATE bookings SET status='cancelled' WHERE booking_id=?";
        String updateCarSql = "UPDATE cars SET status='available' WHERE car_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement getCarStmt = conn.prepareStatement(getCarIdSql);
             PreparedStatement cancelStmt = conn.prepareStatement(cancelSql);
             PreparedStatement updateCarStmt = conn.prepareStatement(updateCarSql)) {

            // Step 1: Get the car_id
            getCarStmt.setInt(1, bookingId);
            ResultSet rs = getCarStmt.executeQuery();

            if (rs.next()) {
                int carId = rs.getInt("car_id");

                // Step 2: Cancel the booking
                cancelStmt.setInt(1, bookingId);
                cancelStmt.executeUpdate();

                // Step 3: Update the car's status
                updateCarStmt.setInt(1, carId);
                updateCarStmt.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public boolean isCarBooked(int carId, Date startDate, Date endDate) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE car_id = ? AND status IN ('confirmed', 'completed') AND "
                   + "(start_date <= ? AND end_date >= ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setDate(2, endDate);
            stmt.setDate(3, startDate);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true; // fail-safe: assume booked
    }
    
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_id = ? ORDER BY start_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setCarId(rs.getInt("car_id"));
                    b.setStartDate(rs.getDate("start_date"));
                    b.setEndDate(rs.getDate("end_date"));
                    b.setTotalCost(rs.getDouble("total_cost"));
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Booking> getBookingsByUserIdAndStatus(int userId, String status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_id = ? AND status = ? ORDER BY start_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, status);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setCarId(rs.getInt("car_id"));
                    b.setStartDate(rs.getDate("start_date"));
                    b.setEndDate(rs.getDate("end_date"));
                    b.setTotalCost(rs.getDouble("total_cost"));
                    b.setStatus(rs.getString("status"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingById(int bookingId) {
    String sql = "SELECT * FROM bookings WHERE booking_id=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, bookingId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Booking booking = new Booking();
            booking.setBookingId(rs.getInt("booking_id"));
            booking.setUserId(rs.getInt("user_id"));
            booking.setCarId(rs.getInt("car_id"));
            booking.setStartDate(rs.getDate("start_date"));
            booking.setEndDate(rs.getDate("end_date"));
            booking.setTotalCost(rs.getDouble("total_cost"));
            booking.setStatus(rs.getString("status"));
            return booking;
        }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public void updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public List<Booking> getBookingsByStatus(String status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingId(rs.getInt("booking_id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setCarId(rs.getInt("car_id"));
                    booking.setStartDate(rs.getDate("start_date"));
                    booking.setEndDate(rs.getDate("end_date"));
                    booking.setTotalCost(rs.getDouble("total_cost"));
                    booking.setStatus(rs.getString("status"));
                    list.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Map<String, Object>> getRentedCarDetails() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.start_date, b.end_date, b.total_cost, b.status, " +
                     "u.username, u.phone, u.email, " +
                     "c.car_id, c.brand, c.model, c.type " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.user_id " +
                     "JOIN cars c ON b.car_id = c.car_id " +
                     "WHERE b.status IN ('paid', 'rented', 'cancellation_requested')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("bookingId", rs.getInt("booking_id"));
                row.put("startDate", rs.getDate("start_date"));
                row.put("endDate", rs.getDate("end_date"));
                row.put("totalCost", rs.getDouble("total_cost"));
                row.put("status", rs.getString("status")); // ✅ Add this line
                row.put("username", rs.getString("username"));
                row.put("phone", rs.getString("phone"));
                row.put("email", rs.getString("email"));
                row.put("carId", rs.getInt("car_id"));
                row.put("brand", rs.getString("brand"));
                row.put("model", rs.getString("model"));
                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }





}
