package com.reservation.controller;

import com.reservation.service.MenuService;
import java.io.IOException;
import jakarta.servlet.ServletException; // 🔴 FIXED: javax වෙනුවට jakarta දැම්මා
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteMenuItemServlet")
public class DeleteMenuItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int itemId = Integer.parseInt(idStr);

                MenuService menuService = new MenuService();
                boolean isDeleted = menuService.deleteMenuItem(itemId);

                if (isDeleted) {
                    response.sendRedirect("admin_menu.jsp?msg=delete_success");
                } else {
                    response.sendRedirect("admin_menu.jsp?error=delete_failed");
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("admin_menu.jsp?error=invalid_id");
            }
        } else {
            response.sendRedirect("admin_menu.jsp?error=missing_id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}