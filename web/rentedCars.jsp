<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, dao.BookingDAO, model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    BookingDAO bookingDao = new BookingDAO();
    List<Map<String, Object>> rentedCars = bookingDao.getRentedCarDetails();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Rented Cars Info</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>
<main class="container my-4 flex-grow-1">
    <h2>Currently Rented Cars</h2>
    <% String msg = request.getParameter("msg"); %>
    <% if ("approved".equals(msg)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ✅ Cancellation request approved.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } else if ("rejected".equals(msg)) { %>
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            ⚠️ Cancellation request rejected.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <% if (rentedCars.isEmpty()) { %>
        <div class="alert alert-info">No cars currently rented.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered table-striped mt-3">
                <thead class="table-light">
                    <tr>
                        <th>Booking ID</th>
                        <th>Renter</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Car</th>
                        <th>Rental Period</th>
                        <th>Total Cost</th>
                        <th>Status</th>
                        <th>Cancellation Request</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Map<String, Object> entry : rentedCars) { 
                    String status = (String) entry.get("status");
                %>
                    <tr>
                        <td><%= entry.get("bookingId") %></td>
                        <td><%= entry.get("username") %></td>
                        <td><%= entry.get("phone") %></td>
                        <td><%= entry.get("email") %></td>
                        <td><%= entry.get("brand") %> <%= entry.get("model") %></td>
                        <td><%= entry.get("startDate") %> to <%= entry.get("endDate") %></td>
                        <td>RM <%= String.format("%.2f", entry.get("totalCost")) %></td>
                        <td><%= status %></td>
                        <td>
                            <% if ("cancellation_requested".equalsIgnoreCase(status)) { %>
                                <div class="d-flex gap-2 align-items-center">
                                    <form action="ApproveCancelServlet" method="post" onsubmit="return confirm('Approve cancellation request?');">
                                        <input type="hidden" name="bookingId" value="<%= entry.get("bookingId") %>">
                                        <button type="submit" class="btn btn-success btn-sm">Approve</button>
                                    </form>
                                    <form action="RejectCancelServlet" method="post" onsubmit="return confirm('Reject cancellation request?');">
                                        <input type="hidden" name="bookingId" value="<%= entry.get("bookingId") %>">
                                        <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                    </form>
                                </div>
                            <% } else { %>
                                -
                            <% } %>
                        </td>


                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    <% } %>

    <a href="dashboard.jsp" class="btn btn-secondary mt-4">Back to Dashboard</a>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>


