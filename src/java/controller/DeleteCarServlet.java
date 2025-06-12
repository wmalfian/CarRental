package controller;

import dao.CarDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteCarServlet")
public class DeleteCarServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int carId = Integer.parseInt(request.getParameter("carId"));
        CarDAO dao = new CarDAO();
        boolean success = dao.deleteCar(carId);

        if (success) {
            response.sendRedirect("manageCars.jsp?success=Car deleted successfully.");
        } else {
            response.sendRedirect("manageCars.jsp?error=Failed to delete car.");
        }
    }
}

