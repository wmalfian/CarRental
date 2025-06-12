<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Booking Successful</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-5 text-center">
            <h2>✅ Booking Confirmed!</h2>
            <p>Thank you, <strong><%= user.getUsername() %></strong>. Your booking has been successfully made.</p>
            <a href="bookingHistory.jsp" class="btn btn-primary mt-3">View My Bookings</a>
            <a href="customerDashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
        </div>
    </main>
    <%@ include file="footer.jsp" %>  
</body>
</html>
