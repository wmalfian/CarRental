<%-- 
    Document   : dbTest
    Created on : Jun 24, 2025, 10:57:49?PM
    Author     : wmalf
--%>

<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%
    Connection conn = DBConnection.getConnection();
    if (conn != null) {
        out.println("? Connected to DB successfully!");
    } else {
        out.println("? Failed to connect to DB.");
    }
%>
