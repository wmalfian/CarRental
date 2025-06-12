package controller;

import dao.PaymentDAO;
import dao.BookingDAO; 
import model.Payment;
import util.DBConnection;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String method = request.getParameter("paymentMethod");

        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setUserId(userId);
        payment.setAmount(amount);
        payment.setPaymentMethod(method);
        payment.setReceiptUrl("receipt_" + bookingId + ".pdf"); // Placeholder

        PaymentDAO dao = new PaymentDAO();
        boolean success = dao.addPayment(payment);

        if (success) {
            try (Connection conn = DBConnection.getConnection()) {
                String updateStatus = method.equalsIgnoreCase("Cash") ? "confirmed" : "paid";

                PreparedStatement stmt = conn.prepareStatement(
                    "UPDATE bookings SET status = ? WHERE booking_id = ?");
                stmt.setString(1, updateStatus);
                stmt.setInt(2, bookingId);
                stmt.executeUpdate();
                stmt.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (method.equalsIgnoreCase("Cash")) {
                response.sendRedirect("cashPending.jsp?bookingId=" + bookingId + "&pending=true");
            } else {
                response.sendRedirect("paymentSuccess.jsp?bookingId=" + bookingId);
            }

        } else {
            request.setAttribute("error", "Payment failed.");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
        }
    }
}

