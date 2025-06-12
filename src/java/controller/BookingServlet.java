package controller;

import java.io.IOException;
import java.sql.Date;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.Booking;
import dao.BookingDAO;
import dao.CarDAO;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        int carId = Integer.parseInt(request.getParameter("carId"));
        Date startDate = Date.valueOf(request.getParameter("startDate"));
        Date endDate = Date.valueOf(request.getParameter("endDate"));
        
        BookingDAO dao = new BookingDAO();
        if (dao.isCarBooked(carId, startDate, endDate)) {
            request.setAttribute("error", "This car is already booked during the selected dates.");
            request.getRequestDispatcher("bookCar.jsp?carId=" + carId).forward(request, response);
            return;
        }
 
        long days = (endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24) + 1;

        CarDAO carDAO = new CarDAO();
        model.Car car = carDAO.getCarById(carId);
        if (car == null) {
            response.getWriter().println("Car not found.");
            return;
        }

        double totalCost = car.getPricePerDay() * days;

        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setCarId(carId);
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);
        booking.setTotalCost(totalCost);
        booking.setStatus("confirmed");

        int bookingId = dao.createBooking(booking);
        if (bookingId > 0) {
            booking.setBookingId(bookingId);
            carDAO.updateCarStatus(carId, "rented");

            response.sendRedirect("payment.jsp?bookingId=" + bookingId + "&amount=" + booking.getTotalCost());
        } else {
            request.setAttribute("error", "Booking failed.");
            request.getRequestDispatcher("bookCar.jsp").forward(request, response);
        }
        
    }
}

