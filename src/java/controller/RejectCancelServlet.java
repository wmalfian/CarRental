package controller;

import dao.BookingDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RejectCancelServlet")
public class RejectCancelServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO dao = new BookingDAO();

        dao.updateBookingStatus(bookingId, "paid");

        response.sendRedirect("rentedCars.jsp?msg=rejected");
    }
}
