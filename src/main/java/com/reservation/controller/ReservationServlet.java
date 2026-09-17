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

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        String customerName = (String) session.getAttribute("userName");
        if(customerName == null) customerName = "Valued Customer";
        String phone = (String) session.getAttribute("userPhone");
        if(phone == null) phone = "N/A";

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String date = request.getParameter("date");
        String time = request.getParameter("time");
        int guests = Integer.parseInt(request.getParameter("guests"));
        String tableType = request.getParameter("tableType");

        String[] foods = request.getParameterValues("foodItems");
        String preOrderedFood = (foods != null && foods.length > 0) ? String.join(" + ", foods) : "None";

        String specialNote = request.getParameter("specialNote");
        specialNote = (specialNote != null && !specialNote.trim().isEmpty()) ? specialNote : "None";

        ReservationService rs = new ReservationService();


        if (!rs.isTableAvailable(date, time, tableType)) {
            response.sendRedirect("book_table.jsp?error=table_booked");
            return;
        }

        Reservation res = new Reservation(userEmail, customerName, phone, date, time, guests, tableType, preOrderedFood, specialNote, "Pending");

        if (rs.addReservation(res)) {

            EmailService emailService = new EmailService();
            final int finalGuests = guests;
            final String finalFood = preOrderedFood;
            final String finalNote = specialNote;

            new Thread(() -> {
                emailService.sendReceipt(userEmail, date, time, tableType, finalGuests, finalFood, finalNote);
            }).start();

            response.sendRedirect("my_bookings.jsp?msg=booking_success");
        } else {
            response.sendRedirect("book_table.jsp?error=booking_failed");
        }
    }
}