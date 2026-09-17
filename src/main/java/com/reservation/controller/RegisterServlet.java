package com.reservation.controller;

import com.reservation.model.User;
import com.reservation.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");

        UserService userService = new UserService();

        String userId = userService.getNextUserId();

        User user = new User(userId, fullName, email, phoneNumber, password, "Customer");

        if (userService.registerUser(user)) {
            response.sendRedirect("login.jsp?msg=registered");
        } else {
            response.sendRedirect("signup.jsp?error=failed");
        }
    }
}