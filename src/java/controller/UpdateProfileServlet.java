package controller;

import dao.UserDAO;
import model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String updatedUsername = request.getParameter("username");
        String updatedEmail = request.getParameter("email");
        String updatedPhone = request.getParameter("phone");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO dao = new UserDAO();

        boolean updatePassword = false;

        if (currentPassword != null && !currentPassword.trim().isEmpty()
                && newPassword != null && !newPassword.trim().isEmpty()
                && confirmPassword != null && !confirmPassword.trim().isEmpty()) {
            if (!dao.verifyPassword(user.getUserId(), currentPassword)) {
                response.sendRedirect("editProfile.jsp?error=Current password is incorrect.");
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("editProfile.jsp?error=New passwords do not match.");
                return;
            }
            user.setPassword(newPassword);
            updatePassword = true;
        }

        user.setUsername(updatedUsername);
        user.setEmail(updatedEmail);
        user.setPhone(updatedPhone);

        boolean success = dao.updateUser(user, updatePassword);

        if (success) {
            session.setAttribute("currentUser", user);
            response.sendRedirect("editProfile.jsp?success=Profile updated successfully.");
        } else {
            response.sendRedirect("editProfile.jsp?error=Failed to update profile.");
        }
    }
}

