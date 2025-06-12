package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.AdminDAO;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminDAO dao = new AdminDAO();

        request.setAttribute("userCount", dao.countUsers());
        request.setAttribute("carCount", dao.countCars());
        request.setAttribute("bookingCount", dao.countBookings());
        request.setAttribute("totalRevenue", dao.sumPayments());

        RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
