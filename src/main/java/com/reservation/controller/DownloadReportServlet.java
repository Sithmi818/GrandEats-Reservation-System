package com.reservation.controller;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.reservation.model.Reservation;
import com.reservation.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/DownloadReportServlet")
public class DownloadReportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=GrandEats_Reservations_Report.pdf");

        try {
            Document document = new Document(com.itextpdf.text.PageSize.A4.rotate());
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            com.itextpdf.text.Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, BaseColor.BLACK);
            Paragraph title = new Paragraph("GrandEats - Full Reservations Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            com.itextpdf.text.Font dateFont = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.DARK_GRAY);
            Paragraph datePara = new Paragraph("Generated on: " + new Date().toString(), dateFont);
            datePara.setAlignment(Element.ALIGN_CENTER);
            datePara.setSpacingAfter(20f);
            document.add(datePara);

            PdfPTable table = new PdfPTable(8);
            table.setWidthPercentage(100);

            float[] columnWidths = {2f, 1f, 1f, 0.8f, 1.2f, 2f, 2f, 1f};
            table.setWidths(columnWidths);

            String[] headers = {"User Email", "Date", "Time", "Pax", "Table", "Food Order", "Note", "Status"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE)));
                cell.setBackgroundColor(new BaseColor(24, 24, 24));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8f);
                table.addCell(cell);
            }

            ReservationService rs = new ReservationService();
            List<Reservation> allReservations = rs.getAllReservations();

            com.itextpdf.text.Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 9, BaseColor.BLACK);

            for (Reservation res : allReservations) {
                PdfPCell c1 = new PdfPCell(new Phrase(res.getUserEmail(), dataFont));
                PdfPCell c2 = new PdfPCell(new Phrase(res.getDate(), dataFont));
                PdfPCell c3 = new PdfPCell(new Phrase(res.getTime(), dataFont));
                PdfPCell c4 = new PdfPCell(new Phrase(String.valueOf(res.getGuests()), dataFont));
                PdfPCell c5 = new PdfPCell(new Phrase(res.getTableType(), dataFont));

                String food = res.getPreOrderedFood() != null ? res.getPreOrderedFood() : "None";
                String note = res.getSpecialNote() != null ? res.getSpecialNote() : "None";
                PdfPCell c6 = new PdfPCell(new Phrase(food, dataFont));
                PdfPCell c7 = new PdfPCell(new Phrase(note, dataFont));

                BaseColor statusColor = BaseColor.DARK_GRAY;
                if ("Approved".equalsIgnoreCase(res.getStatus())) statusColor = new BaseColor(34, 139, 34); // Green
                else if ("Pending".equalsIgnoreCase(res.getStatus())) statusColor = new BaseColor(204, 102, 0); // Orange
                else if ("Cancelled".equalsIgnoreCase(res.getStatus())) statusColor = new BaseColor(220, 53, 69); // Red

                PdfPCell c8 = new PdfPCell(new Phrase(res.getStatus(), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, statusColor)));

                PdfPCell[] cells = {c1, c2, c3, c4, c5, c6, c7, c8};
                for (PdfPCell c : cells) {
                    c.setPadding(6f);
                    c.setHorizontalAlignment(Element.ALIGN_CENTER);
                    c.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    table.addCell(c);
                }
            }

            document.add(table);
            document.close();

        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }
}