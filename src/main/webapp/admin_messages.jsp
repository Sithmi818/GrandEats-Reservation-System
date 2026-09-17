<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.Message" %>
<%@ page import="com.reservation.service.MessageService" %>
<%@ page import="java.util.List" %>
<%
    // Security Check (Admin Only)
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) { response.sendRedirect("login.jsp"); return; }
%>
<html>
<head>
    <title>Messages - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- PREMIUM LUXURY DARK WOOD TEXTURE BACKGROUND --- */
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #0d0d0d;
            background-image: linear-gradient(rgba(0, 0, 0, 0.9), rgba(0, 0, 0, 0.9)),
                              url('https://images.unsplash.com/photo-1541532713592-79a0317b6b77?q=80&w=1888&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
            margin: 0;
            color: #ffffff;
            overflow-x: hidden;
        }

        /* --- CONTAINER FOR FLOATING DECORATIONS --- */
        .admin-container { position: relative; max-width: 1300px; margin: 0 auto; }

        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12;
            opacity: 0.5;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.6);
        }
        .star-left { top: 120px; left: 15px; animation: floatingEffect 5s ease-in-out infinite alternate; }
        .star-right { bottom: 20px; right: 15px; animation: floatingEffect 7s ease-in-out infinite alternate-reverse; }

        /* --- HEADER & NAVIGATION --- */
        .admin-header {
            background: rgba(15, 15, 15, 0.85);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .admin-header h2 { margin: 0; color: #f39c12; font-weight: 400; }
        .admin-header a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            background: #dc3545;
            padding: 8px 15px;
            border-radius: 5px;
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.2);
        }
        .admin-header a:hover { background: #c82333; transform: translateY(-2px); }

        .sub-nav {
            background: rgba(25, 25, 25, 0.65);
            padding: 15px 40px;
            display: flex;
            gap: 25px;
            backdrop-filter: blur(5px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .admin-content { padding: 40px; position: relative; z-index: 5; animation: fadeIn 1s ease-out; }

        /* --- GLASSMORPHIC INQUIRY CARDS --- */
        .msg-card {
            background: rgba(25, 25, 25, 0.55);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.4s ease;
        }
        .msg-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.6);
        }

        .msg-header { display: flex; justify-content: space-between; margin-bottom: 15px; color: #bdc3c7; font-size: 14px; align-items: center;}

        /* Action Buttons */
        .btn-action { padding: 8px 16px; border-radius: 6px; font-size: 13px; font-weight: bold; cursor: pointer; border: none; text-decoration: none; display: inline-block; transition: all 0.3s ease; }

        /* 🟢 CHANGED TO BUTTON STYLING FOR MODAL POPUP */
        .btn-email { background: #4b5563; color: white; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
        .btn-email:hover { background: #6b7280; transform: translateY(-2px); }

        .btn-reply { background: #28a745; color: white; box-shadow: 0 4px 10px rgba(40, 167, 69, 0.2); }
        .btn-reply:hover { background: #2ed573; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(40, 167, 69, 0.4); }

        .btn-delete { background: #dc3545; color: white; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.2); }
        .btn-delete:hover { background: #ff4757; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(220, 53, 69, 0.4); }

        /* Status Badges Style */
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: bold; margin-left: 10px; color: white; display: inline-block; }
        .badge-pending { background-color: rgba(243, 156, 18, 0.2); color: #ffe699; border: 1px solid rgba(243, 156, 18, 0.4); }
        .badge-replied { background-color: rgba(40, 167, 69, 0.2); color: #99ffb3; border: 1px solid rgba(40, 167, 69, 0.4); }

        .customer-email { color: #3498db; font-weight: bold; text-decoration: none; transition: color 0.3s; }
        .customer-email:hover { color: #f39c12; text-decoration: underline; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes floatingEffect { 0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; } 100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; } }
    </style>
</head>
<body>
    <div class="admin-header">
        <h2><i class="fa-solid fa-utensils"></i> GrandEats Admin Portal</h2>
        <div>
            <span style="margin-right: 20px; color: #bdc3c7;"><i class="fa-solid fa-user-shield" style="color: #f39c12;"></i> Welcome, Manager</span>
            <a href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </div>

    <div class="sub-nav">
        <a href="admin_dashboard.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-house"></i> Dashboard</a>
        <a href="admin_users.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-users"></i> User Management</a>
        <a href="admin_menu.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-burger"></i> Menu</a>
        <a href="admin_messages.jsp" style="color: #f39c12; text-decoration: none; font-weight: bold;"><i class="fa-solid fa-envelope"></i> Messages</a>
        <a href="admin_reports.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-chart-pie"></i> Reports</a>
    </div>

    <div class="admin-container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="admin-content">
            <h2 style="margin-top: 0; color: #ffffff; font-weight: 400; letter-spacing: 1px;"><i class="fa-solid fa-envelope-open-text" style="color: #f39c12;"></i> Customer Feedback & Inquiries</h2>
            <p style="color: #bdc3c7; margin-bottom: 30px;">Read, manage and reply to messages from your website visitors.</p>

            <%
                MessageService ms = new MessageService();
                List<Message> allMessages = ms.getAllMessages();

                if(allMessages.isEmpty()) {
            %>
                <div style="text-align: center; padding: 40px; color: #bdc3c7;"><i class="fa-regular fa-folder-open" style="font-size: 40px; margin-bottom: 15px; display: block; color: rgba(255,255,255,0.1);"></i>No new messages found.</div>
            <%  } else {
                    for(Message m : allMessages) {
                        boolean isPending = "Pending".equals(m.getStatus());
                        String borderColor = isPending ? "#f39c12" : "#28a745";
                        String badgeClass = isPending ? "badge-pending" : "badge-replied";
            %>
                <div class="msg-card" style="border-left-color: <%= borderColor %>;">
                    <div class="msg-header">
                        <strong><i class="fa-solid fa-user" style="color: #f39c12;"></i> <%= m.getName() %> &nbsp;(<a href="mailto:<%= m.getEmail() %>" class="customer-email"><%= m.getEmail() %></a>)
                            <span class="badge <%= badgeClass %>"><%= m.getStatus() %></span>
                        </strong>
                        <span><i class="fa-solid fa-calendar-day" style="color: #bdc3c7;"></i> <%= m.getDate() %></span>
                    </div>
                    <p style="margin: 0 0 20px 0; color: #e2e8f0; line-height: 1.6; font-size: 14px;"><%= m.getContent() %></p>

                    <div style="display: flex; gap: 10px;">
                        <button type="button" class="btn-action btn-email" onclick="openReplyModal('<%= m.getEmail() %>', '<%= m.getId() %>')">
                            <i class="fa-solid fa-envelope"></i> Email Customer
                        </button>

                        <% if (isPending) { %>
                        <form action="ReplyMessageServlet" method="POST" style="margin: 0;">
                            <input type="hidden" name="messageId" value="<%= m.getId() %>">
                            <button type="submit" class="btn-action btn-reply"><i class="fa-solid fa-check-double"></i> Mark as Replied</button>
                        </form>
                        <% } %>

                        <form action="DeleteMessageServlet" method="POST" style="margin: 0;">
                            <input type="hidden" name="id" value="<%= m.getId() %>">
                            <button type="submit" class="btn-action btn-delete" onclick="return confirm('Are you sure you want to permanently delete this message?');">
                                <i class="fa-solid fa-trash-can"></i> Delete
                            </button>
                        </form>
                    </div>
                </div>
            <%      }
                }
            %>
        </div>
    </div>

    <script>
        function openReplyModal(customerEmail, messageId) {
            Swal.fire({
                title: 'Reply to Customer',
                text: 'Sending response to: ' + customerEmail,
                input: 'textarea',
                inputPlaceholder: 'Write your message details here...',
                showCancelButton: true,
                showDenyButton: true,
                confirmButtonText: '<i class="fa-brands fa-google"></i> Send via Gmail',
                denyButtonText: '<i class="fa-solid fa-server"></i> Send via System',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#2ecc71', // Green for Gmail
                denyButtonColor: '#f39c12',    // Orange for DB System
                background: '#1a1a1a',
                color: '#ffffff',
                preConfirm: (text) => {
                    if (!text) {
                        Swal.showValidationMessage('Message content cannot be empty!');
                    }
                    return text;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    // ======= 🟢 METHOD 1: GMAIL REDIRECT COMPOSE WINDOW =======
                    const replyMessage = encodeURIComponent(result.value);
                    const gmailUrl = `https://mail.google.com/mail/?view=cm&fs=1&to=${customerEmail}&su=Reply from GrandEats Restaurant&body=${replyMessage}`;
                    window.open(gmailUrl, '_blank');

                } else if (result.isDenied) {
                    // ======= 🟠 METHOD 2: AJAX/FETCH BACKGROUND SYSTEM SERVLET =======
                    const replyMessage = result.value;

                    const formData = new URLSearchParams();
                    formData.append('messageId', messageId);
                    formData.append('email', customerEmail);
                    formData.append('reply', replyMessage);

                    fetch('ReplyMessageServlet', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: formData
                    })
                    .then(response => {
                        if (response.ok) {
                            Swal.fire({ icon: 'success', title: 'Success!', text: 'Reply logged and message status updated.', confirmButtonColor: '#28a745', background: '#1a1a1a', color: '#ffffff' })
                            .then(() => { window.location.reload(); }); // Refresh rows UI to reflect new dynamic changes
                        } else {
                            Swal.fire({ icon: 'error', title: 'Failed!', text: 'Something went wrong on the server processing request.', background: '#1a1a1a', color: '#ffffff' });
                        }
                    })
                    .catch(error => {
                        Swal.fire({ icon: 'error', title: 'Error!', text: 'Could not connect to ReplyMessageServlet context.', background: '#1a1a1a', color: '#ffffff' });
                    });
                }
            });
        }

        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);

            if (urlParams.has('deleted')) {
                Swal.fire({ icon: 'success', title: 'Deleted!', text: 'Message deleted successfully.', confirmButtonColor: '#dc3545', background: '#1a1a1a', color: '#ffffff' })
                .then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }
            else if (urlParams.has('replySuccess')) {
                Swal.fire({ icon: 'success', title: 'Updated!', text: 'Message marked as replied.', confirmButtonColor: '#28a745', background: '#1a1a1a', color: '#ffffff' })
                .then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }
            else if (urlParams.has('error')) {
                Swal.fire({ icon: 'error', title: 'Oops...', text: 'Something went wrong!', confirmButtonColor: '#3498db', background: '#1a1a1a', color: '#ffffff' })
                .then(() => { window.history.replaceState(null, null, window.location.pathname); });
            }
        });
    </script>
</body>
</html>