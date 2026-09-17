package com.reservation.controller;

import com.reservation.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String newName = request.getParameter("fullName");
        String newPhone = request.getParameter("phoneNumber");

        UserService userService = new UserService();
        boolean isUpdated = userService.updateProfile(userEmail, newName, newPhone);

        if (isUpdated) {
            response.sendRedirect("profile.jsp?msg=profile_updated");
        } else {
            response.sendRedirect("profile.jsp?error=update_failed");
        }
    }
}