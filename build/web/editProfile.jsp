<%-- 
    Document   : editProfile
    Created on : May 27, 2025, 11:19:35 AM
    Author     : wmalf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>Edit Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>
<main class="container my-4 flex-grow-1">
    <div class="container mt-5">
        <h2 class="mb-4">✏️ Edit Profile</h2>

        <div class="card-body">
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= request.getParameter("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } else if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= request.getParameter("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

                <form action="UpdateProfileServlet" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" name="username" id="username" value="<%= user.getUsername() %>" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" name="email" id="email" value="<%= user.getEmail() %>" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone</label>
                        <input type="text" name="phone" id="phone" value="<%= user.getPhone() %>" class="form-control" required>
                    </div>

                    <hr>
                    <h5>Change Password</h5>

                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Current Password</label>
                        <input type="password" name="currentPassword" id="currentPassword" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <input type="password" name="newPassword" id="newPassword" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" class="form-control">
                    </div>

                    <button type="submit" class="btn btn-primary">Update</button>
                    <a href="profile.jsp" class="btn btn-secondary ms-2">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>
