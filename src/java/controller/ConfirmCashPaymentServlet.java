package controller;

import dao.BookingDAO;
import dao.CarDAO;
import dao.PaymentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ConfirmCashPaymentServlet")
public class ConfirmCashPaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        PaymentDAO paymentDAO = new PaymentDAO();
        BookingDAO bookingDAO = new BookingDAO();
        CarDAO carDAO = new CarDAO();

        paymentDAO.markAsPaid(bookingId);
        bookingDAO.updateBookingStatus(bookingId, "paid");

        int carId = bookingDAO.getBookingById(bookingId).getCarId();
        carDAO.updateCarStatus(carId, "rented");

        response.sendRedirect("confirmCashPayments.jsp?msg=confirmed");
    }
}


