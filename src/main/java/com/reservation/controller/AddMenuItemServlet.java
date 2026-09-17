package com.reservation.controller;

import com.reservation.model.MenuItem;
import com.reservation.service.MenuService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AddMenuItemServlet")
public class AddMenuItemServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : 0.0;
            String status = request.getParameter("status");
            String imageUrl = request.getParameter("imageUrl");

            MenuItem newItem = new MenuItem(name, category, price, status, imageUrl);
            MenuService ms = new MenuService();

            if (ms.addMenuItem(newItem)) {
                response.sendRedirect("admin_menu.jsp?msg=item_added");
            } else {
                response.sendRedirect("admin_menu.jsp?error=db_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_menu.jsp?error=invalid_data");
        }
    }
}