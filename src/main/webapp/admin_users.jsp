<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.User" %>
<%@ page import="com.reservation.service.UserService" %>
<%@ page import="java.util.List" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>User Management - Admin Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

        /* --- GLASSMORPHIC TABLE STYLING --- */
        .table-container {
            background: rgba(25, 25, 25, 0.55);
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(12px);
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            margin-top: 20px;
        }
        .table-custom { width: 100%; border-collapse: collapse; text-align: left; color: #ecf0f1; }
        .table-custom th { background-color: rgba(40, 40, 40, 0.6); color: #f39c12; padding: 18px 20px; font-weight: 500; text-transform: uppercase; font-size: 13px; border-bottom: 2px solid rgba(255,255,255,0.05); }
        .table-custom td { padding: 18px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); color: #e2e8f0; font-size: 14px; }
        .table-custom tr:hover td { background-color: rgba(255, 255, 255, 0.03); }

        .user-email { color: #3498db; font-weight: bold; text-decoration: none; transition: color 0.3s; }
        .user-email:hover { color: #f39c12; text-decoration: underline; }

        /* Animated Action Buttons */
        .btn-danger {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            font-size: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(220, 53, 69, 0.2);
        }
        .btn-danger:hover {
            background: #ff4757;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(220, 53, 69, 0.4);
        }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
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
        <a href="admin_users.jsp" style="color: #f39c12; text-decoration: none; font-weight: bold;"><i class="fa-solid fa-users"></i> User Management</a>
        <a href="admin_menu.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-burger"></i> Menu</a>
        <a href="admin_messages.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-envelope"></i> Messages</a>
        <a href="admin_reports.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-chart-pie"></i> Reports</a>
    </div>

    <div class="admin-container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="admin-content">
            <h2 style="margin-top: 0; color: #ffffff; font-weight: 400; letter-spacing: 1px;"><i class="fa-solid fa-users-gear" style="color: #f39c12;"></i> User Management</h2>
            <p style="color: #bdc3c7; margin-bottom: 30px;">View and manage all registered customers in the system.</p>

            <% if(request.getParameter("msg") != null && request.getParameter("msg").equals("user_deleted")) { %>
                <div style="background: rgba(40, 167, 69, 0.15); color: #99ffb3; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold; border-left: 5px solid #28a745; border-top: 1px solid rgba(40,167,69,0.2); border-right: 1px solid rgba(40,167,69,0.2); border-bottom: 1px solid rgba(40,167,69,0.2);">
                    <i class="fa-solid fa-circle-check"></i> User account permanently deleted!
                </div>
            <% } %>

            <div class="table-container">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th><i class="fa-regular fa-user" style="color: #f39c12;"></i> Full Name</th>
                            <th><i class="fa-regular fa-envelope" style="color: #f39c12;"></i> Email Address</th>
                            <th><i class="fa-solid fa-phone" style="color: #f39c12;"></i> Phone Number</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            UserService us = new UserService();
                            List<User> allUsers = us.getAllUsers();

                            if(allUsers.isEmpty()) {
                        %>
                            <tr><td colspan="4" style="text-align: center; padding: 40px; color: #bdc3c7;">No registered users found.</td></tr>
                        <%  } else {
                                for(User u : allUsers) {
                        %>
                            <tr>
                                <td><strong><%= u.getFullName() != null ? u.getFullName() : "User" %></strong></td>
                                <td><a href="mailto:<%= u.getEmail() %>" class="user-email"><%= u.getEmail() %></a></td>
                                <td><%= u.getPhoneNumber() != null ? u.getPhoneNumber() : "N/A" %></td>
                                <td>
                                    <form action="DeleteUserServlet" method="POST" style="margin: 0;">
                                        <input type="hidden" name="userEmail" value="<%= u.getEmail() %>">
                                        <button type="submit" class="btn-danger" onclick="return confirm('Are you sure you want to completely remove this user from the system?');">
                                            <i class="fa-solid fa-trash-can"></i> Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <%      }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>