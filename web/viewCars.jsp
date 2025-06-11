<%-- 
    Document   : viewCars
    Created on : May 26, 2025, 3:01:31 PM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Car, model.User, dao.CarDAO" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Available Cars</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container mt-5">
        <h2>Available Cars for Rent</h2>
        <div class="row mt-4">
            <%
                CarDAO dao = new CarDAO();
                List<Car> cars = dao.getAvailableCars();
                for (Car car : cars) {
            %>
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title"><%= car.getBrand() + " " + car.getModel() %></h5>
                        <p>Type: <%= car.getType() %><br>
                        RM<%= car.getPricePerDay() %> / day</p>
                        <form action="bookCar.jsp" method="get">
                            <input type="hidden" name="carId" value="<%= car.getCarId() %>">
                            <input type="hidden" name="price" value="<%= car.getPricePerDay() %>">
                            <button type="submit" class="btn btn-success">Book Now</button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
</body>
</html>