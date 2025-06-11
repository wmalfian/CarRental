<%-- 
    Document   : index.jsp
    Created on : May 26, 2025, 2:35:39 PM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Car, dao.CarDAO"%>
<%
    CarDAO carDao = new CarDAO();

    List<String> brandOptions = carDao.getAvailableBrands();

    // Get filter parameters from request
    String selectedBrand = request.getParameter("brand");
    String selectedType = request.getParameter("type");
    String selectedFuel = request.getParameter("fuel");

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
    <title>Car Rental System</title>
    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="style.css">
    <style>
        .car-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .car-card:hover {
            transform: scale(1.03);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            z-index: 10;
        }
    </style>
 
</head>
<body class="d-flex flex-column min-vh-100">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.jsp">CarRental</a>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp">Register</a></li>
                </ul>
            </div>
        </div>
    </nav>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-5">
            <div class="text-center mb-4">
                <h1>Welcome to Our Car Rental System</h1>
                <p class="lead">Browse our selection of reliable rental vehicles and enjoy hassle-free service!</p>
            </div>

            <div class="row">
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
    <footer class="bg-dark text-light text-center py-3 mt-5">
        <p class="mb-0">&copy; 2025 Car Rental System. All rights reserved.</p>
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
