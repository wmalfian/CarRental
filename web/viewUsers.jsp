<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.User, dao.UserDAO" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" class="h-100">
<head>
    <title>View Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
<%@ include file="navbar.jsp" %>

<main class="container my-4 flex-grow-1">
    <div class="container mt-4">
        <h2>User List</h2>

        <!-- Alert messages -->
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

        <form method="get" class="mb-3 d-flex align-items-center gap-2">
            <label for="role" class="form-label me-2">Filter by Role:</label>
            <select name="role" id="role" class="form-select w-auto">
                <option value="">All</option>
                <option value="admin" <%= "admin".equals(request.getParameter("role")) ? "selected" : "" %>>Admin</option>
                <option value="customer" <%= "customer".equals(request.getParameter("role")) ? "selected" : "" %>>Customer</option>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Apply</button>
        </form>

        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>User ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    UserDAO dao = new UserDAO();
                    List<User> userList = dao.getAllUsers();

                    String roleFilter = request.getParameter("role");
                    if (roleFilter != null && !roleFilter.isEmpty()) {
                        List<User> filtered = new ArrayList<>();
                        for (User u : userList) {
                            if (u.getRole().equalsIgnoreCase(roleFilter)) {
                                filtered.add(u);
                            }
                        }
                        userList = filtered;
                    }

                    for (User u : userList) {
                %>
                <tr>
                    <td><%= u.getUserId() %></td>
                    <td><%= u.getUsername() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getPhone() %></td>
                    <td><%= u.getRole() %></td>
                    <td>
                        <form action="DeleteUserServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                            <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>
</main>

<%@ include file="footer.jsp" %>
</body>
</html>
