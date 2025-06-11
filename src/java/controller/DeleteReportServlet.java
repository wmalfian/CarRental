/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.ReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteReportServlet")
public class DeleteReportServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int reportId = Integer.parseInt(request.getParameter("reportId"));
        ReportDAO dao = new ReportDAO();
        boolean success = dao.deleteReport(reportId);

        if (success) {
            response.sendRedirect("viewReports.jsp?success=Report+deleted+successfully.");
        } else {
            response.sendRedirect("viewReports.jsp?error=Failed+to+delete+report.");
        }
    }
}

