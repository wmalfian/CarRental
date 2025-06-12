<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, java.sql.Date, model.Car, model.User, dao.CarDAO" %>

<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    int carId = Integer.parseInt(request.getParameter("carId"));
    CarDAO carDao = new CarDAO();
    Car car = carDao.getCarById(carId);
    if (car == null) {
        out.println("<h3>Car not found.</h3>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Book Car</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-5">
            <h2>Book <%= car.getBrand() %> <%= car.getModel() %></h2>

            <div class="row mt-4">
                <div class="col-md-6">
                    <img src="images/<%= car.getImagePath() %>" class="img-fluid" alt="<%= car.getModel() %>">
                </div>
                <div class="col-md-6">
                    <form action="BookingServlet" method="post">
                        <input type="hidden" name="carId" value="<%= car.getCarId() %>">
                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">

                        <div class="mb-3">
                            <label>Start Date</label>
                            <input type="date" name="startDate" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>End Date</label>
                            <input type="date" name="endDate" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>Price per Day</label>
                            <input type="text" value="RM <%= String.format("%.2f", car.getPricePerDay()) %>" class="form-control" readonly>
                        </div>
                        <button type="submit" class="btn btn-primary">Confirm Booking</button>
                        <a href="customerDashboard.jsp" class="btn btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </div>
    </main>
    <%@ include file="footer.jsp" %>           
</body>
</html>
