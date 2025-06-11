<%-- 
    Document   : createAdmin
    Created on : Jun 2, 2025, 1:36:47 AM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("unauthorized.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Create Admin Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-5">
            <h2>Create New Admin Account</h2>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } else if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>

            <form action="CreateAdminServlet" method="post" onsubmit="return confirm('Create new admin?');">
                <div class="mb-3">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Phone</label>
                    <input type="text" name="phone" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary">Create Admin</button>
                <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>