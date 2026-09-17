package com.reservation.controller;

import com.reservation.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String emailToDelete = request.getParameter("userEmail");

        UserService userService = new UserService();
        boolean isDeleted = userService.deleteUser(emailToDelete);

        if (isDeleted) {
            response.sendRedirect("admin_users.jsp?msg=user_deleted");
        } else {
            response.sendRedirect("admin_users.jsp?error=delete_failed");
        }
    }
}