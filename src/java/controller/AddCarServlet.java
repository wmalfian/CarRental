/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.Car;
import dao.CarDAO;

@WebServlet("/AddCarServlet")
public class AddCarServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Car car = new Car();
        car.setBrand(request.getParameter("brand"));
        car.setModel(request.getParameter("model"));
        car.setType(request.getParameter("type"));
        car.setPricePerDay(Double.parseDouble(request.getParameter("price")));
        car.setStatus("available");
        car.setFuelType(request.getParameter("fuel"));
        car.setImagePath(request.getParameter("image"));

        CarDAO dao = new CarDAO();
        boolean success = dao.addCar(car);

        if (success) {
            response.sendRedirect("manageCars.jsp?success=Car added successfully.");
        } else {
            request.setAttribute("error", "❌ Failed to add car. Please try again.");
            request.getRequestDispatcher("addCar.jsp").forward(request, response);
        }
    }
}


