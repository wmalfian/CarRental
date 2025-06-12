package controller;

import dao.BookingDAO;
import model.Booking;
import util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

@WebServlet("/RequestCancelBookingServlet")
public class RequestCancelBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT status, end_date FROM bookings WHERE booking_id = ?");
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");
                Date endDate = rs.getDate("end_date");
                LocalDate today = LocalDate.now();

                if ("paid".equalsIgnoreCase(status) && !endDate.toLocalDate().isBefore(today)) {
                    PreparedStatement update = conn.prepareStatement(
                        "UPDATE bookings SET status = 'cancellation_requested' WHERE booking_id = ?"
                    );
                    update.setInt(1, bookingId);
                    update.executeUpdate();

                    response.sendRedirect("bookingHistory.jsp?success=true");
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("bookingHistory.jsp?error=not_found");
    }
}




