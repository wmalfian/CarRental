<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Payment, model.User, dao.PaymentDAO, dao.UserDAO" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    PaymentDAO paymentDao = new PaymentDAO();
    List<Payment> pendingCashPayments = paymentDao.getPendingCashPayments();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Cash Payments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>
<main class="container my-4 flex-grow-1">
    <h2>Pending Cash Payments</h2>

    <% if ("confirmed".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ✅ Payment confirmed successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } else if ("canceled".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            ⚠️ Payment cancellation successful.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <% if (pendingCashPayments.isEmpty()) { %>
        <div class="alert alert-info">No pending cash payments found.</div>
    <% } else { %>
        <table class="table table-bordered mt-3">
            <thead class="table-light">
                <tr>
                    <th>Payment ID</th>
                    <th>Booking ID</th>
                    <th>User ID</th>
                    <th>Customer Name</th>
                    <th>Phone</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    UserDAO userDao = new UserDAO(); // move DAO out of loop for efficiency
                    for (Payment p : pendingCashPayments) { 
                        User customer = userDao.getUserById(p.getUserId()); 
                %>
                <tr>
                    <td><%= p.getPaymentId() %></td>
                    <td><%= p.getBookingId() %></td>
                    <td><%= p.getUserId() %></td>
                    <td><%= customer.getUsername() %></td>
                    <td><%= customer.getPhone() %></td>
                    <td>RM <%= String.format("%.2f", p.getAmount()) %></td>
                    <td><%= p.getPaymentDate() %></td>
                    <td>
                        <div class="d-flex gap-2">
                            <form action="ConfirmCashPaymentServlet" method="post" onsubmit="return confirm('Confirm this cash payment?');">
                                <input type="hidden" name="bookingId" value="<%= p.getBookingId() %>">
                                <button type="submit" class="btn btn-success btn-sm">Confirm</button>
                            </form>
                            <form action="CancelCashServlet" method="post" onsubmit="return confirm('Cancel this cash payment?');">
                                <input type="hidden" name="bookingId" value="<%= p.getBookingId() %>">
                                <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>

        </table>
    <% } %>

    <a href="dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>
