package com.reservation.service;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailService {

    private static final String SENDER_EMAIL = "reservationgrandeats@gmail.com";
    private static final String APP_PASSWORD = "gywumxemayqtlkje";

    private void sendEmail(String toEmail, String subject, String htmlContent) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL, "GrandEats Team"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("✅ Email successfully sent to: " + toEmail);

        } catch (Exception e) {
            System.err.println("❌ Error sending email to: " + toEmail);
            e.printStackTrace();
        }
    }

    public void sendReceipt(String toEmail, String date, String time, String tableType, int guests, String food, String note) {
        String subject = "Reservation Received - GrandEats";
        String htmlContent = buildEmailTemplate(
                "Reservation Received! 🎉",
                "Thank you for choosing GrandEats. Your reservation request has been successfully recorded and is currently <strong>Pending</strong> admin approval.",
                "#f39c12", // Orange color for Pending
                date, time, tableType, guests, food, note
        );
        sendEmail(toEmail, subject, htmlContent);
    }

    public void sendApprovalEmail(String toEmail, String date, String time, String tableType, int guests) {
        String subject = "Reservation APPROVED - GrandEats!";
        String htmlContent = buildEmailTemplate(
                "Reservation Confirmed! ✅",
                "Great news! Your table reservation at GrandEats has been <strong>APPROVED</strong>. We look forward to hosting you and providing a wonderful dining experience.",
                "#28a745",
                date, time, tableType, guests, "-", "-"
        );
        sendEmail(toEmail, subject, htmlContent);
    }

    public void sendRejectionEmail(String toEmail, String date, String time) {
        String subject = "Reservation Cancelled - GrandEats";
        String htmlContent = buildEmailTemplate(
                "Reservation Cancelled ❌",
                "We regret to inform you that we cannot accommodate your reservation request for the requested date and time due to high demand. Please try booking for another day.",
                "#dc3545",
                date, time, "-", 0, "-", "-"
        );
        sendEmail(toEmail, subject, htmlContent);
    }

    private String buildEmailTemplate(String title, String messageBody, String themeColor, String date, String time, String tableType, int guests, String food, String note) {

        String detailsBox = "";

        if (guests > 0) {
            detailsBox = "<div style=\"background-color: #f8f9fa; border-radius: 8px; padding: 20px; margin: 20px 0; border-left: 4px solid " + themeColor + ";\">" +
                    "<table style=\"width: 100%; border-collapse: collapse; font-size: 15px;\">" +
                    "<tr><td style=\"padding: 8px 0; color: #666;\"><strong>Date:</strong></td><td style=\"padding: 8px 0; color: #1a1a1a;\">" + date + "</td></tr>" +
                    "<tr><td style=\"padding: 8px 0; color: #666; border-top: 1px solid #eee;\"><strong>Time:</strong></td><td style=\"padding: 8px 0; color: #1a1a1a; border-top: 1px solid #eee;\">" + time + "</td></tr>" +
                    "<tr><td style=\"padding: 8px 0; color: #666; border-top: 1px solid #eee;\"><strong>Guests:</strong></td><td style=\"padding: 8px 0; color: #1a1a1a; border-top: 1px solid #eee;\">" + guests + " Persons</td></tr>" +
                    "<tr><td style=\"padding: 8px 0; color: #666; border-top: 1px solid #eee;\"><strong>Table Type:</strong></td><td style=\"padding: 8px 0; color: #1a1a1a; border-top: 1px solid #eee;\">" + tableType + "</td></tr>" +
                    "</table></div>";
        }

        return "<div style=\"font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border: 1px solid #e0e0e0;\">" +
                "<div style=\"background-color: #1a1a1a; padding: 30px 20px; text-align: center;\">" +
                "<h1 style=\"color: #f39c12; margin: 0; font-size: 28px; letter-spacing: 1px;\">GrandEats</h1>" +
                "<p style=\"color: #cccccc; margin: 5px 0 0 0; font-size: 14px;\">Experience Fine Dining</p>" +
                "</div>" +
                "<div style=\"padding: 30px;\">" +
                "<h2 style=\"color: " + themeColor + "; margin-top: 0;\">" + title + "</h2>" +
                "<p style=\"color: #555555; line-height: 1.6;\">" + messageBody + "</p>" +
                detailsBox +
                "</div>" +
                "<div style=\"background-color: #f4f7f6; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">" +
                "<p style=\"color: #888888; font-size: 12px; margin: 0;\">&copy; 2026 GrandEats Restaurant. All rights reserved.</p>" +
                "</div></div>";
    }
}