package com.reservation.controller;

import com.reservation.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        String userEnteredOTP = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");

        String sessionOTP = (String) session.getAttribute("otpCode");
        String email = (String) session.getAttribute("resetEmail");

        if (sessionOTP != null && sessionOTP.equals(userEnteredOTP)) {
            UserService userService = new UserService();
            boolean success = userService.updatePassword(email, newPassword);

            if (success) {
                session.removeAttribute("otpCode");
                session.removeAttribute("resetEmail");
                response.sendRedirect("login.jsp?msg=password_updated");
            } else {
                response.sendRedirect("reset_password.jsp?error=update_failed");
            }
        } else {
            response.sendRedirect("reset_password.jsp?error=invalid_otp");
        }
    }
}