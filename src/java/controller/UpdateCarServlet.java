package controller;

import dao.CarDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Car;

@WebServlet("/UpdateCarServlet")
public class UpdateCarServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        Car car = new Car();
        car.setCarId(Integer.parseInt(request.getParameter("carId")));
        car.setBrand(request.getParameter("brand"));
        car.setModel(request.getParameter("model"));
        car.setType(request.getParameter("type"));
        car.setPricePerDay(Double.parseDouble(request.getParameter("price")));
        car.setStatus(request.getParameter("status"));

        CarDAO dao = new CarDAO();
        dao.updateCar(car);
        response.sendRedirect("viewCars.jsp");
    }
}
