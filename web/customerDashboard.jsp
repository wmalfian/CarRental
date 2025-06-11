<%-- 
    Document   : customerDashboard
    Created on : May 30, 2025, 2:48:51 AM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Car, dao.CarDAO, model.User"%>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String selectedBrand = request.getParameter("brand");
    String selectedType = request.getParameter("type");
    String selectedFuel = request.getParameter("fuel");

    CarDAO carDao = new CarDAO();

    // Get distinct brand list for dropdown
    List<String> brandOptions = carDao.getAvailableBrands();

    List<Car> carList;
    if ((selectedBrand != null && !selectedBrand.isEmpty()) ||
        (selectedType != null && !selectedType.isEmpty()) ||
        (selectedFuel != null && !selectedFuel.isEmpty())) {
        carList = carDao.filterAvailableCars(selectedBrand, selectedType, selectedFuel);
    } else {
        carList = carDao.getAvailableCars();
    }
%>

<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Customer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %> 
    <main class="container my-4 flex-grow-1">

        <div class="container mt-4">
            <h2>Dashboard</h2>
            <p>Welcome to your dashboard. Here’s what you can do:</p>

            <div class="row mt-4">

                <div class="col-md-4">
                    <div class="card text-white bg-success mb-3">
                        <div class="card-body">
                            <h5 class="card-title">My Bookings</h5>
                            <p class="card-text">View your booking history or cancel a booking.</p>
                            <a href="bookingHistory.jsp" class="btn btn-light">Go</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <form method="get" class="row mb-4">
                    <div class="col-md-3">
                        <label>Brand</label>
                        <select name="brand" class="form-select">
                            <option value="">All Brands</option>
                            <% for (String b : brandOptions) { %>
                                <option value="<%= b %>" <%= b.equals(selectedBrand) ? "selected" : "" %>><%= b %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label>Type</label>
                        <select name="type" class="form-select">
                            <option value="">All Types</option>
                            <option value="Manual" <%= "Manual".equals(selectedType) ? "selected" : "" %>>Manual</option>
                            <option value="Automatic" <%= "Automatic".equals(selectedType) ? "selected" : "" %>>Automatic</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label>Fuel Type</label>
                        <select name="fuel" class="form-select">
                            <option value="">All Fuels</option>
                            <option value="Petrol" <%= "Petrol".equals(selectedFuel) ? "selected" : "" %>>Petrol</option>
                            <option value="Diesel" <%= "Diesel".equals(selectedFuel) ? "selected" : "" %>>Diesel</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">Filter</button>
                    </div>
                </form>

            <% if (carList.isEmpty()) { %>
                <div class="alert alert-info">🚫 No available cars at the moment. Please check back later.</div>
            <% } else { 
                for (Car car : carList) {
            %>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 car-card">
                        <img src="images/<%= car.getImagePath() != null ? car.getImagePath() : "default.png" %>" class="card-img-top" alt="<%= car.getModel() %>">
                        <div class="card-body">
                            <h5 class="card-title"><%= car.getBrand() %> <%= car.getModel() %></h5>
                            <p class="card-text">
                                RM<%= String.format("%.2f", car.getPricePerDay()) %>/day • 
                                <%= car.getType() %> • 
                                <%= car.getFuelType() != null ? car.getFuelType() : "Petrol" %>
                            </p>
                            <a href="bookCar.jsp?carId=<%= car.getCarId() %>" class="btn btn-primary">Book Now</a>
                        </div>
                    </div>
                </div>
            <%
                }
            } %>
            </div>

        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>
