package com.reservation.controller;

import com.reservation.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateReservationServlet")
public class UpdateReservationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String newDate = request.getParameter("date");
            String newTime = request.getParameter("time");
            int newGuests = Integer.parseInt(request.getParameter("guests"));
            String newTableType = request.getParameter("tableType");

            String[] foods = request.getParameterValues("foodItems");
            String newFood = (foods != null && foods.length > 0) ? String.join(" + ", foods) : "None";

            String newNote = request.getParameter("specialNote");
            newNote = (newNote != null && !newNote.trim().isEmpty()) ? newNote : "None";

            ReservationService rs = new ReservationService();

            if (rs.updateReservationDetails(id, newDate, newTime, newGuests, newTableType, newFood, newNote)) {
                response.sendRedirect("my_bookings.jsp?msg=booking_updated");
            } else {
                response.sendRedirect("my_bookings.jsp?error=update_failed");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("my_bookings.jsp?error=invalid_data");
        }
    }
}