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

@WebServlet("/ApproveReservationServlet")
public class
ApproveReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            ReservationService rs = new ReservationService();

            if (rs.updateReservationStatus(id, "Approved")) {


                Reservation res = rs.getReservationById(id);

                if (res != null) {
                    EmailService emailService = new EmailService();
                    emailService.sendApprovalEmail(
                            res.getUserEmail(),
                            res.getDate(),
                            res.getTime(),
                            res.getTableType(),
                            res.getGuests()
                    );
                }

                response.sendRedirect("admin_dashboard.jsp?msg=approved");
            } else {
                response.sendRedirect("admin_dashboard.jsp?error=approve_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("admin_dashboard.jsp?error=invalid_id");
        }
    }
}