/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.BookingDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author wmalf 
 */
@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO dao = new BookingDAO();
        dao.cancelBooking(bookingId);
        response.sendRedirect("bookingHistory.jsp");
    }
}

