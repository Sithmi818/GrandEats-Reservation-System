package com.reservation.controller;

import com.reservation.service.MessageService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ReplyMessageServlet")
public class ReplyMessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String isAjax = request.getParameter("reply");

        try {
            int id = Integer.parseInt(request.getParameter("messageId"));

            MessageService ms = new MessageService();
            boolean isUpdated = ms.updateMessageStatus(id);

            if (isAjax != null) {
                if (isUpdated) {
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            }
            else {
                String redirectUrl = isUpdated ? "admin_messages.jsp?replySuccess=true" : "admin_messages.jsp?error=true";
                response.sendRedirect(redirectUrl);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            if (isAjax != null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            } else {
                response.sendRedirect("admin_messages.jsp?error=true");
            }
        }
    }
}