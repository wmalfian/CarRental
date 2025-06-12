package controller;

import dao.BookingDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ApproveCancelServlet")
public class ApproveCancelServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO dao = new BookingDAO();
        dao.updateBookingStatus(bookingId, "cancelled");

        // Set car status to 'available' as well
        dao.cancelBooking(bookingId); // Optional, if you want to also free the car

        response.sendRedirect("rentedCars.jsp?msg=approved");
    }
}


