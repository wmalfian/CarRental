package controller;

import dao.PaymentDAO;
import dao.BookingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/CancelCashServlet")
public class CancelCashServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        PaymentDAO paymentDAO = new PaymentDAO();
        BookingDAO bookingDAO = new BookingDAO();

        paymentDAO.cancelPayment(bookingId);
        bookingDAO.updateBookingStatus(bookingId, "cancelled");

        response.sendRedirect("confirmCashPayments.jsp?msg=canceled");
    }
}


