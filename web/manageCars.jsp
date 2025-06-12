<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Car, model.User, dao.CarDAO" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    CarDAO carDao = new CarDAO();
    List<Car> carList = carDao.getAllCars();

    String typeFilter = request.getParameter("type");
    String statusFilter = request.getParameter("status");

    if ((typeFilter != null && !typeFilter.isEmpty()) || (statusFilter != null && !statusFilter.isEmpty())) {
        List<Car> filteredList = new java.util.ArrayList<>();
        for (Car c : carList) {
            boolean match = true;
            if (typeFilter != null && !typeFilter.isEmpty() && !c.getType().equalsIgnoreCase(typeFilter)) {
                match = false;
            }
            if (statusFilter != null && !statusFilter.isEmpty() && !c.getStatus().equalsIgnoreCase(statusFilter)) {
                match = false;
            }
            if (match) filteredList.add(c);
        }
        carList = filteredList;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Manage Cars</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>

<main class="container my-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Manage Cars</h2>
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");

            if (success != null) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ✅ <%= success %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            } else if (error != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>

        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ✅ Car added successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("true".equals(request.getParameter("edited"))) { %>
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                ✏️ Car details updated successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("deleted".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                🗑️ Car deleted successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("error".equals(request.getParameter("status"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ Failed to delete car.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if ("edit".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ Failed to update car.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <a href="addCar.jsp" class="btn btn-success">Add New Car</a>
    </div>
    <form method="get" class="row g-3 mb-4">
        <div class="col-md-4">
            <label for="type" class="form-label">Filter by Type</label>
            <select name="type" id="type" class="form-select">
                <option value="">All</option>
                <option value="Automatic" <%= "Automatic".equals(typeFilter) ? "selected" : "" %>>Automatic</option>
                <option value="Manual" <%= "Manual".equals(typeFilter) ? "selected" : "" %>>Manual</option>
            </select>
        </div>
        <div class="col-md-4">
            <label for="status" class="form-label">Filter by Status</label>
            <select name="status" id="status" class="form-select">
                <option value="">All</option>
                <option value="available" <%= "available".equals(statusFilter) ? "selected" : "" %>>Available</option>
                <option value="rented" <%= "rented".equals(statusFilter) ? "selected" : "" %>>Rented</option>
            </select>
        </div>
        <div class="col-md-4 d-flex align-items-end">
            <button type="submit" class="btn btn-primary me-2">Apply</button>
            <a href="manageCars.jsp" class="btn btn-secondary">Reset</a>
        </div>
    </form>

    <table class="table table-striped">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Brand</th>
                <th>Model</th>
                <th>Type</th>
                <th>Price/Day (RM)</th>
                <th>Fuel</th>
                <th>Status</th>
                <th>Image</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (Car c : carList) {
        %>
            <tr>
                <td><%= c.getCarId() %></td>
                <td><%= c.getBrand() %></td>
                <td><%= c.getModel() %></td>
                <td><%= c.getType() %></td>
                <td><%= String.format("%.2f", c.getPricePerDay()) %></td>
                <td><%= c.getFuelType() %></td>
                <td>
                    <form action="UpdateCarStatusServlet" method="post" class="d-flex flex-column flex-sm-row gap-1" style="display:inline;" onsubmit="return confirm('Are you sure you want to update this car status?');">
                        <input type="hidden" name="carId" value="<%= c.getCarId() %>">
                        <select name="newStatus" class="form-select form-select-sm w-auto">
                            <option value="available" <%= "available".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Available</option>
                            <option value="rented" <%= "rented".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Rented</option>
                            <option value="maintenance" <%= "maintenance".equalsIgnoreCase(c.getStatus()) ? "selected" : "" %>>Maintenance</option>
                        </select>
                        <button type="submit" class="btn btn-sm btn-outline-primary">Update</button>
                    </form>
                </td>

                <td>
                    <img src="images/<%= c.getImagePath() %>" width="60" height="40" alt="car image">
                </td>
                <td>
                    <a href="editCar.jsp?carId=<%= c.getCarId() %>" class="btn btn-sm btn-warning">Edit</a>
                    <form action="DeleteCarServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this car?');">
                        <input type="hidden" name="carId" value="<%= c.getCarId() %>">
                        <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                    </form>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <a href="dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>

