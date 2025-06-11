<%-- 
    Document   : editCar
    Created on : Jun 1, 2025, 1:27:33 AM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Car, dao.CarDAO" %>
<%
User user = (User) session.getAttribute("currentUser");
if (user == null || !"admin".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
}

int carId = Integer.parseInt(request.getParameter("carId"));
CarDAO dao = new CarDAO();
Car car = dao.getCarById(carId);
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Edit Car</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>
<main class="container my-4 flex-grow-1">
    <h2>Edit Car</h2>
    <form action="EditCarServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to edit this car?');">
        <input type="hidden" name="carId" value="<%= car.getCarId() %>">
        <div class="mb-3">
            <label>Brand</label>
            <input type="text" name="brand" value="<%= car.getBrand() %>" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Model</label>
            <input type="text" name="model" value="<%= car.getModel() %>" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Type</label>
            <input type="text" name="type" value="<%= car.getType() %>" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Price Per Day</label>
            <input type="number" step="0.01" name="price" value="<%= car.getPricePerDay() %>" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Status</label>
            <select name="status" class="form-select">
                <option value="available" <%= "available".equals(car.getStatus()) ? "selected" : "" %>>Available</option>
                <option value="rented" <%= "rented".equals(car.getStatus()) ? "selected" : "" %>>Rented</option>
                <option value="maintenance" <%= "maintenance".equals(car.getStatus()) ? "selected" : "" %>>Maintenance</option>
            </select>
        </div>
        <div class="mb-3">
            <label>Fuel Type</label>
            <input type="text" name="fuel" value="<%= car.getFuelType() %>" class="form-control">
        </div>
        <div class="mb-3">
            <label>Image File Name</label>
            <input type="text" name="image" value="<%= car.getImagePath() %>" class="form-control">
        </div>
        <button type="submit" class="btn btn-primary">Update Car</button>
        <a href="manageCars.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>