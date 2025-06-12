<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat, model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");

    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (request.getAttribute("userCount") == null) {
        response.sendRedirect("AdminDashboardServlet");
        return;
    }

    Integer userCount = (Integer) request.getAttribute("userCount");
    Integer carCount = (Integer) request.getAttribute("carCount");
    Integer bookingCount = (Integer) request.getAttribute("bookingCount");
    Double totalRevenue = (Double) request.getAttribute("totalRevenue");

    int users = userCount != null ? userCount : 0;
    int cars = carCount != null ? carCount : 0;
    int bookings = bookingCount != null ? bookingCount : 0;
    double revenue = totalRevenue != null ? totalRevenue : 0.0;

    DecimalFormat df = new DecimalFormat("RM#,##0.00");
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="js/admin-dashboard.js"></script>
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-4">
            <div class="row mb-4">
                <div class="col-md-3"><strong>Total Users:</strong> <%= users %></div>
                <div class="col-md-3"><strong>Total Cars:</strong> <%= cars %></div>
                <div class="col-md-3"><strong>Bookings:</strong> <%= bookings %></div>
                <div class="col-md-3"><strong>Revenue:</strong> <%= df.format(revenue) %></div>
            </div>

            <h2>Dashboard</h2>
            <div class="row mt-4">
                <div class="col-md-4">
                    <div class="card text-white bg-primary mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Manage Users</h5>
                            <a href="viewUsers.jsp" class="btn btn-light">Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-success mb-3">
                        <div class="card-body">
                            <h5 class="card-title">View Reports</h5>
                            <a href="viewReports.jsp" class="btn btn-light">Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-white bg-warning mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Manage Cars</h5>
                            <a href="manageCars.jsp" class="btn btn-light">Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                <div class="card text-white bg-danger mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Confirm Cash Payments</h5>
                            <a href="confirmCashPayments.jsp" class="btn btn-light">Go</a>
                        </div>
                    </div>
                </div>
 
                <div class="col-md-4">
                    <div class="card text-white bg-dark mb-3">
                        <div class="card-body">
                            <h5 class="card-title">Create Admin</h5>
                            <a href="createAdmin.jsp" class="btn btn-light">Go</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card bg-teal mb-3">
                        <div class="card-body">
                            <h5 class="card-title">View Rented Cars</h5>
                            <a href="rentedCars.jsp" class="btn btn-light">Go</a>
                        </div>
                    </div>
                </div>
            </div>

            <h3 class="mt-4">System Summary Chart</h3>
            <canvas id="dashboardChart" width="400" height="150"></canvas>
        </div>
    </main>
    <%@ include file="footer.jsp" %>

    <script>
        renderDashboardChart(<%= users %>, <%= cars %>, <%= bookings %>, <%= revenue %>);
    </script>
</body>
</html>
