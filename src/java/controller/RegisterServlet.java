package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.User;
import dao.UserDAO;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole("customer"); // force all users to be customers

        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(user);

        if (success) {
            // ✅ redirect with success message
            response.sendRedirect("login.jsp?success=Registered successfully. Please login.");
        } else {
            request.setAttribute("error", "Registration failed.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
