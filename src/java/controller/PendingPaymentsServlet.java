package controller;

import dao.BookingDAO;
import dao.CarDAO;
import model.Booking;
import model.Car;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/PendingPaymentsServlet")
public class PendingPaymentsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookingDAO bookingDao = new BookingDAO();
        List<Booking> pendingBookings = bookingDao.getBookingsByStatus("pending");

        // Optional: fetch car info for display
        CarDAO carDao = new CarDAO();
        Map<Integer, Car> carMap = new HashMap<>();
        for (Booking b : pendingBookings) {
            if (!carMap.containsKey(b.getCarId())) {
                carMap.put(b.getCarId(), carDao.getCarById(b.getCarId()));
            }
        }

        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("carMap", carMap);
        request.getRequestDispatcher("pendingPayments.jsp").forward(request, response);
    }
}
