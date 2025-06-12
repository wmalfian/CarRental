<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Report, model.User, dao.ReportDAO" %>
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
    <title>View Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="navbar.jsp" %>
    <main class="container my-4 flex-grow-1">
        <div class="container mt-4">
            <h2>System Reports</h2>
            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                if (success != null) {
            %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= success %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } else if (error != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            <div class="card mb-4">
                <div class="card-body">
                    <form action="GenerateReportServlet" method="post" onsubmit="return confirm('Generate Report?');">
                        <div class="mb-3">
                            <label for="reportType" class="form-label">Report Type</label>
                            <select name="reportType" class="form-select" required>
                                <option value="Booking Summary">Booking Summary</option>
                                <option value="Revenue Report">Revenue Report</option>
                                <option value="User Statistics">User Statistics</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="content" class="form-label">Content</label>
                            <textarea name="content" class="form-control" rows="4" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Generate Report</button>
                    </form>
                </div>
            </div>

            <form method="get" class="row g-3 mb-4" );>
                <div class="col-md-4">
                    <select name="filterType" class="form-select">
                        <option value="">All Types</option>
                        <option value="Booking Summary">Booking Summary</option>
                        <option value="Revenue Report">Revenue Report</option>
                        <option value="User Statistics">User Statistics</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <input type="date" name="filterDate" class="form-control">
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-outline-secondary">Filter</button>
                </div>
            </form>

            <%
                ReportDAO dao = new ReportDAO();
                List<Report> reportList = dao.getAllReports();

                String filterType = request.getParameter("filterType");
                String filterDate = request.getParameter("filterDate");

                for (Report report : reportList) {
                    boolean show = true;
                    if (filterType != null && !filterType.isEmpty() && !report.getReportType().equals(filterType)) {
                        show = false;
                    }
                    if (filterDate != null && !filterDate.isEmpty() && !report.getGeneratedDate().toString().startsWith(filterDate)) {
                        show = false;
                    }

                    if (show) {
            %>
            <div class="card mb-3">
                <div class="card-header bg-info text-white">
                    <%= report.getReportType() %> | Generated on <%= report.getGeneratedDate() %>
                </div>
                <div class="card-body">
                    <pre><%= report.getContent() %></pre>
                    <form action="DeleteReportServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this report?');">
                        <input type="hidden" name="reportId" value="<%= report.getReportId() %>">
                        <button type="submit" class="btn btn-danger btn-sm mt-2">Delete</button>
                    </form>
                    <a href="DownloadReportPDFServlet?reportId=<%= report.getReportId() %>" class="btn btn-outline-secondary btn-sm mt-2">Download as PDF</a>
                </div>
            </div>
            <% 
                    }
                }
            %>

            <a href="dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
        </div>
    </main>
    <%@ include file="footer.jsp" %>
</body>
</html>