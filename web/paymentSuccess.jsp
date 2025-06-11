<%-- 
    Document   : paymentSuccess
    Created on : May 27, 2025, 12:59:34 AM
    Author     : wmalf
--%>

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
    <title>Payment Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-5 text-center">
            <h2 class="text-success">Payment Successful!</h2>
            <p>Thank you for your payment. Your booking is now complete.</p>
            <div class="d-flex justify-content-center gap-3 mt-4">
                <a href="DownloadReceipt?bookingId=<%= request.getParameter("bookingId") %>" class="btn btn-outline-success">Download Receipt (PDF)</a>
                <a href="customerDashboard.jsp" class="btn btn-primary">Back to Home</a>
            </div>
        </div>
    </main>
    <%@ include file="footer.jsp" %>  
</body>
</html>