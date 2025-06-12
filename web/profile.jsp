<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-5">
            <h2 class="mb-4">👤 Your Profile</h2>

            <div class="card shadow-sm">
                <div class="card-body">
                    <p><strong>Username:</strong> <%= user.getUsername() %></p>
                    <p><strong>Email:</strong> <%= user.getEmail() %></p>
                    <p><strong>Phone:</strong> <%= user.getPhone() %></p>

                    <form action="editProfile.jsp" method="get" class="mt-3">
                        <button class="btn btn-primary">Edit Profile</button>
                    </form>
                </div>
            </div>
            <a href="<%= role.equals("admin") ? "AdminDashboardServlet" : "customerDashboard.jsp" %>" class="btn btn-secondary mt-3">Back to Dashboard</a>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>