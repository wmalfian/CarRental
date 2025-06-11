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
import java.util.List;
import model.Payment;
import util.DBConnection;

public class PaymentDAO {

    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO payments (booking_id, user_id, amount, payment_method, receipt_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payment.getBookingId());
            stmt.setInt(2, payment.getUserId());
            stmt.setDouble(3, payment.getAmount());
            stmt.setString(4, payment.getPaymentMethod());
            stmt.setString(5, payment.getReceiptUrl());

            stmt.executeUpdate();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setUserId(rs.getInt("user_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Payment> getPendingCashPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payments p JOIN bookings b ON p.booking_id = b.booking_id " +
             "WHERE p.payment_method = 'Cash' AND b.status = 'confirmed'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setBookingId(rs.getInt("booking_id"));
                p.setUserId(rs.getInt("user_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setReceiptUrl(rs.getString("receipt_url"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean markAsPaid(int bookingId) {
        String sql = "UPDATE bookings SET status = 'paid' WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelPayment(int bookingId) {
        String sql = "UPDATE bookings SET status = 'cancelled' WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }



}