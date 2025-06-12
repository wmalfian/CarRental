package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.ReportDAO;
import model.Report;

@WebServlet("/GenerateReportServlet")
public class GenerateReportServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        model.User admin = (model.User) session.getAttribute("currentUser");

        String reportType = request.getParameter("reportType");
        String content = request.getParameter("content");

        if (admin != null && "admin".equals(admin.getRole())) {
            Report report = new Report();
            report.setGeneratedBy(admin.getUserId());
            report.setReportType(reportType);
            report.setContent(content);

            ReportDAO dao = new ReportDAO();
            boolean success = dao.addReport(report);

            if (success) {
                response.sendRedirect("viewReports.jsp?success=Report generated successfully.");
                return;
            } else {
                response.sendRedirect("viewReports.jsp?error=Failed to generate report.");
                return;
            }
        }

        response.sendRedirect("viewReports.jsp?error=Unauthorized access.");
    }
}
