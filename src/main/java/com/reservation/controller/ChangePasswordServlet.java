package com.reservation.controller;

import com.reservation.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        UserService userService = new UserService();
        String role = userService.loginUser(userEmail, oldPassword);

        if (role != null) {
            if (userService.updatePassword(userEmail, newPassword)) {
                response.sendRedirect("profile.jsp?msg=password_updated");
            } else {
                response.sendRedirect("profile.jsp?error=update_failed");
            }
        } else {
            response.sendRedirect("profile.jsp?error=wrong_password");
        }
    }
}