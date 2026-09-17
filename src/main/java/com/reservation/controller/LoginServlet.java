package com.reservation.controller;

import com.reservation.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();
        UserService userService = new UserService();

        String role = userService.loginUser(email, password);

        if (role != null) {
            session.setAttribute("userEmail", email);
            session.setAttribute("role", role);

            if ("admin".equalsIgnoreCase(role)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }

        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}