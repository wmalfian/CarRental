/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CarDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateCarStatusServlet")
public class UpdateCarStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int carId = Integer.parseInt(request.getParameter("carId"));
        String newStatus = request.getParameter("newStatus");

        CarDAO dao = new CarDAO();
        boolean result = dao.updateCarStatus(carId, newStatus);

        if (result) {
            response.sendRedirect("manageCars.jsp?success=Car status updated successfully.");
        } else {
            response.sendRedirect("manageCars.jsp?error=Failed to update car status.");
        }
    }
}

