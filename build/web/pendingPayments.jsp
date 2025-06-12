<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Booking, model.Car, model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Booking> pendingBookings = (List<Booking>) request.getAttribute("pendingBookings");
    Map<Integer, Car> carMap = (Map<Integer, Car>) request.getAttribute("carMap");
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Pending Payments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-4">
            <h2>Pending Cash Payments</h2>

            <%
                if (pendingBookings == null || pendingBookings.isEmpty()) {
            %>
                <div class="alert alert-info">No pending cash payments.</div>
            <%
                } else {
            %>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>User ID</th>
                        <th>Car</th>
                        <th>Start</th>
                        <th>End</th>
                        <th>Total (RM)</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Booking b : pendingBookings) {
                        Car car = carMap.get(b.getCarId());
                %>
                    <tr>
                        <td><%= b.getBookingId() %></td>
                        <td><%= b.getUserId() %></td>
                        <td><%= car != null ? car.getBrand() + " " + car.getModel() : "Unknown" %></td>
                        <td><%= b.getStartDate() %></td>
                        <td><%= b.getEndDate() %></td>
                        <td><%= String.format("%.2f", b.getTotalCost()) %></td>
                        <td>
                            <form action="ConfirmCashPaymentServlet" method="post">
                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                <button class="btn btn-sm btn-success">Confirm Payment</button>
                            </form>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
            <% } %>

            <a href="dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
        </div>
    </main>
<%@ include file="footer.jsp" %>
</body>
</html>