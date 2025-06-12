<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String role = (currentUser != null) ? currentUser.getRole() : "";
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark px-3">
    <a class="navbar-brand" href="<%= role.equals("admin") ? "AdminDashboardServlet" : "customerDashboard.jsp" %>">CarRental</a>
    <div class="ms-auto">
        <% if (currentUser != null) { %>
            <span class="navbar-text me-3 text-light">Hello, <%= currentUser.getUsername() %></span>
            <form action="LogoutServlet" method="post" class="d-inline">
                <a href="profile.jsp" class="btn btn-outline-light btn-sm me-2">Profile</a>
                <button class="btn btn-outline-light btn-sm" type="submit">Logout</button>
            </form>
        <% } else { %>
            <a href="login.jsp" class="btn btn-outline-light btn-sm">Login</a>
        <% } %>
    </div>
    <script>
        let timeout = setTimeout(() => {
            window.location.href = "login.jsp?timeout=true";
        }, 840000); 

        ['click', 'keydown', 'mousemove'].forEach(evt =>
            document.addEventListener(evt, () => {
                clearTimeout(timeout);
                timeout = setTimeout(() => {
                    window.location.href = "login.jsp?timeout=true";
                }, 840000);
            })
        );
    </script>

</nav>
