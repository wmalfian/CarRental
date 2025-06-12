package controller;

import dao.CarDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Car;

@WebServlet("/EditCarServlet")
public class EditCarServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int carId = Integer.parseInt(request.getParameter("carId"));
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String type = request.getParameter("type");
        String fuel = request.getParameter("fuel");
        double price = Double.parseDouble(request.getParameter("price"));
        String image = request.getParameter("image");

        Car car = new Car();
        car.setCarId(carId);
        car.setBrand(brand);
        car.setModel(model);
        car.setType(type);
        car.setFuelType(fuel);
        car.setPricePerDay(price);
        car.setImagePath(image);

        CarDAO dao = new CarDAO();
        boolean success = dao.updateCar(car);

        if (success) {
            response.sendRedirect("manageCars.jsp?edited=true");
        } else {
            response.sendRedirect("manageCars.jsp?error=edit");
        }
    }
}
 
