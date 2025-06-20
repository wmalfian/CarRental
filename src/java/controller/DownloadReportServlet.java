package controller;

import java.io.IOException; 
import java.io.PrintWriter;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.ReportDAO;
import model.Report;

@WebServlet("/DownloadReportServlet")
public class DownloadReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int reportId = Integer.parseInt(request.getParameter("reportId"));
        ReportDAO dao = new ReportDAO();
        Report report = dao.getReportById(reportId);

        if (report != null) {
            response.setContentType("text/plain");
            response.setHeader("Content-Disposition", "attachment;filename=report_" + reportId + ".txt");

            PrintWriter out = response.getWriter();
            out.println("Report Type: " + report.getReportType());
            out.println("Generated Date: " + report.getGeneratedDate());
            out.println("Generated By (User ID): " + report.getGeneratedBy());
            out.println("\n--- Report Content ---\n");
            out.println(report.getContent());
            out.close();
        } else {
            response.getWriter().println("Report not found.");
        }
    }
}
