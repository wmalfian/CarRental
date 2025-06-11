/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author wmalf
 */
import java.sql.Timestamp;

public class Report {
    private int reportId;
    private int generatedBy;
    private String reportType;
    private Timestamp generatedDate;
    private String content;

    // Getters and Setters
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }

    public int getGeneratedBy() { return generatedBy; }
    public void setGeneratedBy(int generatedBy) { this.generatedBy = generatedBy; }

    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }

    public Timestamp getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(Timestamp generatedDate) { this.generatedDate = generatedDate; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}