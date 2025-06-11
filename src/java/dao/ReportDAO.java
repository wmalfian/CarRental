/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author wmalf
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Report;
import util.DBConnection;

public class ReportDAO {

    public List<Report> getAllReports() {
        List<Report> reports = new ArrayList<>();
        String sql = "SELECT * FROM reports ORDER BY generated_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Report report = new Report();
                report.setReportId(rs.getInt("report_id"));
                report.setGeneratedBy(rs.getInt("generated_by"));
                report.setReportType(rs.getString("report_type"));
                report.setGeneratedDate(rs.getTimestamp("generated_date"));
                report.setContent(rs.getString("content"));
                reports.add(report);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reports;
    }
    
    public boolean addReport(Report report) {
    String sql = "INSERT INTO reports (generated_by, report_type, content) VALUES (?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, report.getGeneratedBy());
        stmt.setString(2, report.getReportType());
        stmt.setString(3, report.getContent());
        stmt.executeUpdate();
        return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteReport(int reportId) {
    String sql = "DELETE FROM reports WHERE report_id=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, reportId);
        stmt.executeUpdate();
        return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Report getReportById(int reportId) {
    String sql = "SELECT * FROM reports WHERE report_id=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, reportId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            Report report = new Report();
            report.setReportId(rs.getInt("report_id"));
            report.setGeneratedBy(rs.getInt("generated_by"));
            report.setReportType(rs.getString("report_type"));
            report.setGeneratedDate(rs.getTimestamp("generated_date"));
            report.setContent(rs.getString("content"));
            return report;
        }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
