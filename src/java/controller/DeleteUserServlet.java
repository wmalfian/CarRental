/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = Integer.parseInt(request.getParameter("userId"));
        UserDAO dao = new UserDAO();

        boolean success = dao.deleteUser(userId);

        if (success) {
            response.sendRedirect("viewUsers.jsp?success=User deleted successfully.");
        } else {
            response.sendRedirect("viewUsers.jsp?error=Failed to delete user.");
        }
    }
}
