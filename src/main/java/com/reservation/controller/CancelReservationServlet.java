package com.reservation.controller;

import com.reservation.model.Reservation;
import com.reservation.service.ReservationService;
import com.reservation.service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/CancelReservationServlet")
public class CancelReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        String role = (String) session.getAttribute("role");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ReservationService rs = new ReservationService();

            Reservation res = rs.getReservationById(id);

            if (rs.updateReservationStatus(id, "Cancelled")) {

                if ("admin".equals(role)) {
                    if (res != null) {
                        EmailService emailService = new EmailService();
                        emailService.sendRejectionEmail(res.getUserEmail(), res.getDate(), res.getTime());
                    }
                    response.sendRedirect("admin_dashboard.jsp?msg=cancelled");
                } else {
                    response.sendRedirect("my_bookings.jsp?msg=cancelled");
                }

            } else {
                if ("admin".equals(role)) {
                    response.sendRedirect("admin_dashboard.jsp?error=cancel_failed");
                } else {
                    response.sendRedirect("my_bookings.jsp?error=cancel_failed");
                }
            }
        } catch (NumberFormatException e) {
            if ("admin".equals(role)) {
                response.sendRedirect("admin_dashboard.jsp?error=invalid_id");
            } else {
                response.sendRedirect("my_bookings.jsp?error=invalid_id");
            }
        }
    }
}