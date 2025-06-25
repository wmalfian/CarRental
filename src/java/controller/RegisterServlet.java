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

        UserDAO dao = new UserDAO();

        // ✅ Check if username is already taken
        if (dao.usernameExists(username)) {
            response.sendRedirect("register.jsp?error=username_taken");
            return;
        }

        // Create and set up user object
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setPhone(phone);
        user.setRole("customer"); // force customer

        // ✅ Try to register
        boolean success = dao.registerUser(user);

        if (success) {
            response.sendRedirect("login.jsp?success=Registered successfully. Please log in.");
        } else {
            response.sendRedirect("register.jsp?error=registration_failed");
        }
    }
}
