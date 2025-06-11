<%-- 
    Document   : addCar
    Created on : May 26, 2025, 3:00:25 PM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Add New Car</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>
<main class="container my-4 flex-grow-1">
    <h2>Add New Car</h2>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    <form action="AddCarServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to add this car?');">
        <div class="mb-3">
            <label>Brand</label>
            <input type="text" name="brand" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Model</label>
            <input type="text" name="model" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Type</label>
                <select name="type" class="form-select" required>
                    <option value="">-- Select Transmission --</option>
                    <option value="Automatic">Automatic</option>
                    <option value="Manual">Manual</option>
                </select>
        </div>

        <div class="mb-3">
            <label>Price Per Day</label>
            <input type="number" step="0.01" name="price" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Fuel Type</label>
            <select name="fuel" class="form-select">
                <option value="">-- Select Fuel Type --</option>
                <option value="Petrol">Petrol</option>
                <option value="Diesel">Diesel</option>
                <option value="Hybrid">Hybrid</option>
                <option value="Electric">Electric</option>
            </select>
        </div>
        <div class="mb-3">
            <label>Image File Name (e.g. axia.png)</label>
            <input type="text" name="image" class="form-control">
        </div>
        <button type="submit" class="btn btn-success">Add Car</button>
        <a href="manageCars.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>