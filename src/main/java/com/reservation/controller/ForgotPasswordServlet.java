package com.reservation.controller;

import com.reservation.util.EmailUtility; // Utility class එක import කරගන්න
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Random;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        Random rand = new Random();
        String otp = String.format("%06d", rand.nextInt(999999));

        HttpSession session = request.getSession();
        session.setAttribute("resetEmail", email);
        session.setAttribute("otpCode", otp);

        try {
            String subject = "GrandEats - Password Reset Verification Code";
            String messageBody = "Dear User,\n\n"
                    + "You requested to reset your password. Please use the following 6-digit verification code:\n\n"
                    + "Verification Code: " + otp + "\n\n"
                    + "If you did not request this, please ignore this email.\n\n"
                    + "Best Regards,\n"
                    + "Team GrandEats";

            EmailUtility.sendEmail(email, subject, messageBody);

            response.sendRedirect("reset_password.jsp?status=sent");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgot_password.jsp?error=mail_failed");
        }
    }
}