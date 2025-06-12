<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, model.User, model.Booking, dao.BookingDAO, dao.CarDAO, model.Car, java.util.List" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    BookingDAO bookingDao = new BookingDAO();
    CarDAO carDao = new CarDAO();

    String statusFilter = request.getParameter("status");
    List<Booking> bookingList;

    if (statusFilter != null && !statusFilter.isEmpty()) {
        bookingList = bookingDao.getBookingsByUserIdAndStatus(user.getUserId(), statusFilter);
    } else {
        bookingList = bookingDao.getBookingsByUserId(user.getUserId());
    }

    LocalDate today = LocalDate.now();
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>My Bookings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>
<main class="container my-4 flex-grow-1">
    <div class="container mt-4">
        <h2>My Booking History</h2>

        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">✅ Cancellation request submitted.</div>
        <% } else if ("not_found".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">❌ Failed to request cancellation.</div>
        <% } %>

        <% if (bookingList.isEmpty()) { %>
            <p>You have not made any bookings yet.</p>
        <% } else { %>
        <form method="get" class="mb-3">
            <label for="statusFilter" class="form-label">Filter by Status:</label>
            <select name="status" id="statusFilter" class="form-select w-auto d-inline-block">
                <option value="">All</option>
                <option value="confirmed" <%= "confirmed".equals(statusFilter) ? "selected" : "" %>>Upcoming</option>
                <option value="paid" <%= "paid".equals(statusFilter) ? "selected" : "" %>>Paid</option>
                <option value="cancellation_requested" <%= "cancellation_requested".equals(statusFilter) ? "selected" : "" %>>Cancellation Requested</option>
                <option value="cancelled" <%= "cancelled".equals(statusFilter) ? "selected" : "" %>>Cancelled</option>
                <option value="completed" <%= "completed".equals(statusFilter) ? "selected" : "" %>>Completed</option>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
        </form>

        <table class="table table-bordered mt-3">
            <thead class="table-light">
                <tr>
                    <th>Car</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Total Cost (RM)</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (Booking b : bookingList) {
                    Car car = carDao.getCarById(b.getCarId());
                    LocalDate endDate = b.getEndDate().toLocalDate();
            %>
                <tr>
                    <td><%= car != null ? car.getBrand() + " " + car.getModel() : "N/A" %></td>
                    <td><%= b.getStartDate() %></td>
                    <td><%= b.getEndDate() %></td>
                    <td><%= String.format("%.2f", b.getTotalCost()) %></td>
                    <td><%= b.getStatus() %></td>
                    <td>
                        <%
                            if ("confirmed".equals(b.getStatus())) {
                        %>
                            <form action="CancelBookingServlet" method="post" onsubmit="return confirm('Cancel this booking?');">
                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                <button type="submit" class="btn btn-sm btn-danger">Cancel</button>
                                <a href="DownloadReceipt?bookingId=<%= b.getBookingId() %>" class="btn btn-sm btn-outline-secondary">Receipt</a>
                            </form>
                        <%
                            } else if ("paid".equals(b.getStatus()) && !endDate.isBefore(today)) {
                        %>
                            <form action="RequestCancelBookingServlet" method="post" onsubmit="return confirm('Are you sure you want to request a cancellation?');">
                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                <button type="submit" class="btn btn-warning btn-sm">Request Cancellation</button>
                                <a href="DownloadReceipt?bookingId=<%= b.getBookingId() %>" class="btn btn-sm btn-outline-secondary">Download Receipt</a>
                            </form>
                        <%
                            } else if ("cancellation_requested".equals(b.getStatus())) {
                        %>
                            <span class="text-warning">Cancellation Requested</span><br>
                            <a href="DownloadReceipt?bookingId=<%= b.getBookingId() %>" class="btn btn-sm btn-outline-secondary mt-1">Download Receipt</a>
                        <%
                            } else if (!"cancelled".equals(b.getStatus()) && !"completed".equals(b.getStatus())) {
                                out.print("-");
                            } else {
                        %>
                            <a href="DownloadReceipt?bookingId=<%= b.getBookingId() %>" class="btn btn-sm btn-outline-secondary">Download Receipt</a>
                        <%
                            }
                        %>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
        <% } %>

        <a href="customerDashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
    </div>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>

