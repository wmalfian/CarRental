<%-- 
    Document   : payment
    Created on : May 27, 2025, 12:58:51 AM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"customer".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    String bookingId = request.getParameter("bookingId");
    String amount = request.getParameter("amount");
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
    <div class="container mt-5">
        <h2>Make Payment</h2>
        <form action="PaymentServlet" method="post" onsubmit="return confirm('Are you sure you want to make this booking?');">
            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">

            <div class="mb-3">
                <label>Amount</label>
                <input type="text" class="form-control" name="amount" value="<%= amount %>" readonly>
            </div>
            <div class="mb-3">
                <label>Payment Method</label>
                <select class="form-select" name="paymentMethod" required>
                    <option value="Online Transfer">Online Transfer</option>
                    <option value="Credit Card">Credit Card</option>
                    <option value="PayPal">PayPal</option>
                    <option value="Cash">Cash</option> <!-- ✅ New option added -->
                </select>
            </div>
            <button type="submit" class="btn btn-success">Confirm</button>
        </form>
    </div>
    </main>
    <%@ include file="footer.jsp" %> 
    <script>
    document.addEventListener("DOMContentLoaded", function () {
        const methodSelect = document.querySelector("select[name='paymentMethod']");
        const alertDiv = document.createElement("div");
        alertDiv.className = "alert alert-info mt-2";
        alertDiv.style.display = "none";
        alertDiv.innerText = "⚠️ Please pay in person at the counter.";

        methodSelect.parentElement.appendChild(alertDiv);

        methodSelect.addEventListener("change", function () {
            if (this.value === "Cash") {
                alertDiv.style.display = "block";
            } else {
                alertDiv.style.display = "none";
            }
        });
    });
    </script>

</body>
</html>