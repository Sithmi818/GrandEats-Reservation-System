<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.Reservation" %>
<%@ page import="com.reservation.service.ReservationService" %>
<%@ page import="java.util.List" %>
<%-- Time calculation සඳහා අවශ්‍ය Imports --%>
<%@ page import="java.time.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) { response.sendRedirect("login.jsp"); return; }
%>
<html>
<head>
    <title>My Bookings - GrandEats</title>
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

        /* --- FORCE OVERRIDE OLD WHITE WRAPPERS TO PREMIUM GLASS --- */
        .dashboard-wrapper {
            display: flex;
            gap: 25px;
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 5;
        }

        .dashboard-wrapper .sidebar,
        .dashboard-wrapper aside,
        div[class*="sidebar"] {
            background: rgba(20, 20, 20, 0.75) !important;
            backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            border-radius: 15px !important;
            color: white !important;
            box-shadow: 0 25px 60px rgba(0,0,0,0.6) !important;
            padding: 25px 15px !important;
        }

        .main-content {
            flex: 1;
            padding: 40px !important;
            background: rgba(20, 20, 20, 0.4) !important; /* Transparent luxury plate override */
            backdrop-filter: blur(10px) !important;
            border-radius: 15px !important;
            border: 1px solid rgba(255, 255, 255, 0.03) !important;
            box-shadow: 0 20px 50px rgba(0,0,0,0.6) !important;
            animation: fadeIn 1s ease-out;
        }

        /* --- CONTAINER FOR FLOATING DECORATIONS --- */
        .booking-container { position: relative; width: 100%; }

        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12;
            opacity: 0.5;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.6);
        }
        .star-left { top: 40px; left: -10px; animation: floatingEffect 5s ease-in-out infinite alternate; }
        .star-right { bottom: 20px; right: -10px; animation: floatingEffect 7s ease-in-out infinite alternate-reverse; }

        /* Header area */
        .page-header { margin-bottom: 25px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); padding-bottom: 15px; }
        .page-header h2 { margin: 0; color: #ffffff; font-weight: 400; display: flex; align-items: center; gap: 10px; }

        /* --- GLASSMORPHIC TABLE STYLING --- */
        .table-container {
            background: rgba(25, 25, 25, 0.65) !important;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(15px);
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            overflow: hidden;
            overflow-x: auto;
        }
        .table-custom { width: 100%; border-collapse: collapse; text-align: left; min-width: 900px; color: #ecf0f1; }
        .table-custom th { background-color: rgba(35, 35, 35, 0.6); color: #f39c12; padding: 18px 20px; font-weight: 500; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px; border-bottom: 2px solid rgba(255,255,255,0.05); }
        .table-custom td { padding: 18px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); color: #e2e8f0; font-size: 14px; vertical-align: middle; }
        .table-custom tr:hover td { background-color: rgba(255, 255, 255, 0.03); }
        .table-custom tr:last-child td { border-bottom: none; }

        /* --- LUXURY TRANSLUCENT STATUS BADGES --- */
        .badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            letter-spacing: 0.5px;
        }
        .badge-pending {
            background: rgba(243, 156, 18, 0.12) !important;
            color: #ffcc66 !important;
            border: 1px solid rgba(243, 156, 18, 0.25) !important;
        }
        .badge-cancelled {
            background: rgba(220, 53, 69, 0.12) !important;
            color: #ff9999 !important;
            border: 1px solid rgba(220, 53, 69, 0.25) !important;
        }
        .badge-confirmed {
            background: rgba(40, 167, 69, 0.12) !important;
            color: #85ff9e !important;
            border: 1px solid rgba(40, 167, 69, 0.25) !important;
        }

        /* Action Buttons */
        .btn-action { padding: 8px 12px; font-size: 13px; border-radius: 6px; cursor: pointer; border: none; font-weight: 600; transition: all 0.3s ease; margin-right: 5px; color: white; display: inline-flex; align-items: center; gap: 5px; text-decoration: none; }
        .btn-edit { background: #f39c12; box-shadow: 0 4px 10px rgba(243, 156, 18, 0.2); }
        .btn-edit:hover { background: #f1c40f; color: black; transform: translateY(-2px); }
        .btn-danger { background: #dc3545; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.2); }
        .btn-danger:hover { background: #ff4757; transform: translateY(-2px); }

        /* Empty State (No bookings) */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 50px; color: rgba(255,255,255,0.1); margin-bottom: 15px; display: block;}
        .empty-state h3 { margin: 0 0 10px 0; color: #ffffff; font-weight: 400; }
        .empty-state p { color: #bdc3c7; margin-bottom: 25px; font-size: 14px; }

        .btn-book-now {
            background: linear-gradient(135deg, #f39c12, #d35400);
            color: white;
            padding: 12px 30px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 13px;
        }
        .btn-book-now:hover { background: linear-gradient(135deg, #f1c40f, #f39c12); transform: translateY(-2px); }

        /* Notification boxes styling */
        .alert-box { padding: 16px 20px; border-radius: 10px; margin-bottom: 25px; font-weight: 500; font-size: 14.5px; border: 1px solid transparent; backdrop-filter: blur(10px); display: flex; align-items: center; gap: 12px; }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes floatingEffect { 0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; } 100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; } }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    <div class="dashboard-wrapper">
        <jsp:include page="includes/sidebar.jsp" />

        <div class="booking-container">
            <i class="fa-solid fa-sparkles floating-star star-left"></i>
            <i class="fa-solid fa-star floating-star star-right"></i>

            <div class="main-content">

                <%-- Notifications Section --%>
                <% if(request.getParameter("msg") != null) { %>
                    <% if(request.getParameter("msg").equals("booking_success")) { %>
                        <div class="alert-box" style="background: rgba(40, 167, 69, 0.08); color: #85ff9e; border-color: rgba(40, 167, 69, 0.2); border-left: 4px solid #28a745;">
                            <i class="fa-solid fa-circle-check"></i> Table Reserved Successfully! It is currently Pending admin approval.
                        </div>
                    <% } else if(request.getParameter("msg").equals("cancelled")) { %>
                        <div class="alert-box" style="background: rgba(220, 53, 69, 0.08); color: #ff9999; border-color: rgba(220, 53, 69, 0.2); border-left: 4px solid #dc3545;">
                            <i class="fa-solid fa-trash-can"></i> Reservation successfully cancelled!
                        </div>
                    <% } else if(request.getParameter("msg").equals("booking_updated")) { %>
                        <div class="alert-box" style="background: rgba(0, 123, 255, 0.08); color: #99ccff; border-color: rgba(0, 123, 255, 0.2); border-left: 4px solid #007bff;">
                            <i class="fa-solid fa-pen-to-square"></i> Reservation updated successfully! It is now Pending admin approval.
                        </div>
                    <% } %>
                <% } %>

                <div class="page-header">
                    <h2><i class="fa-solid fa-list-check" style="color: #f39c12;"></i> My Reservations</h2>
                    <p style="color: #bdc3c7; margin-top: 5px;">View and manage your upcoming dining schedules below.</p>
                </div>

                <div class="table-container">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Table Type</th>
                                <th>Pre-Order</th>
                                <th>Special Note</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ReservationService rs = new ReservationService();
                                List<Reservation> myBookings = rs.getReservationsByUser(userEmail);

                                if(myBookings.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="7">
                                        <div class="empty-state">
                                            <i class="fa-solid fa-calendar-xmark"></i>
                                            <h3>No upcoming reservations found</h3>
                                            <p>You haven't booked any tables yet. Let's plan your next meal!</p>
                                            <a href="book_table.jsp" class="btn-book-now">Book a Table</a>
                                        </div>
                                    </td>
                                </tr>
                            <%  } else {
                                    for(Reservation r : myBookings) {
                            %>
                                <tr>
                                    <td><strong><i class="fa-regular fa-calendar" style="color: #f39c12; margin-right: 5px;"></i> <%= r.getDate() %></strong></td>
                                    <td><i class="fa-regular fa-clock" style="color: #bdc3c7; margin-right: 5px;"></i> <%= r.getTime() %></td>
                                    <td><%= r.getTableType() %> (<%= r.getGuests() %> Pax)</td>

                                    <td><span style="font-size: 12px; color: #3498db; font-weight: bold;"><%= r.getPreOrderedFood() != null ? r.getPreOrderedFood() : "None" %></span></td>
                                    <td><span style="font-size: 12px; color: #bdc3c7; font-style: italic;"><%= r.getSpecialNote() != null ? r.getSpecialNote() : "None" %></span></td>

                                    <td>
                                        <% if("Pending".equalsIgnoreCase(r.getStatus())) { %>
                                            <span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                                        <% } else if("Cancelled".equalsIgnoreCase(r.getStatus())) { %>
                                            <span class="badge badge-cancelled"><i class="fa-solid fa-ban"></i> Cancelled</span>
                                        <% } else { %>
                                            <span class="badge badge-confirmed"><i class="fa-solid fa-check-double"></i> Confirmed</span>
                                        <% } %>
                                    </td>

                                    <%
                                        boolean canEdit = false;
                                        boolean isPassed = false;
                                        try {
                                            String timeStr = r.getTime();
                                            if(timeStr.length() == 5) timeStr += ":00";

                                            LocalDateTime bookingTime = LocalDateTime.parse(r.getDate() + "T" + timeStr);
                                            LocalDateTime now = LocalDateTime.now();

                                            if (bookingTime.isBefore(now)) {
                                                isPassed = true;
                                            } else {
                                                long hoursUntilBooking = Duration.between(now, bookingTime).toHours();
                                                if (hoursUntilBooking >= 2) {
                                                    canEdit = true;
                                                }
                                            }
                                        } catch (Exception e) {
                                            canEdit = true;
                                        }
                                    %>

                                    <td>
                                        <% if(canEdit && !"Cancelled".equalsIgnoreCase(r.getStatus())) { %>
                                            <a href="edit_booking.jsp?id=<%= r.getId() %>" class="btn-action btn-edit" title="Edit Reservation">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <a href="CancelReservationServlet?id=<%= r.getId() %>" class="btn-action btn-danger" onclick="return confirm('Are you sure you want to cancel this reservation?');" title="Cancel Reservation">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </a>
                                        <% } else if(isPassed) { %>
                                            <span style="color: #bdc3c7; font-size: 12px; font-weight: bold;"><i class="fa-solid fa-clock-rotate-left"></i> Passed</span>
                                        <% } else { %>
                                            <span style="color: #ff4757; font-size: 12px; font-weight: bold;" title="Cannot edit/cancel within 2 hours of booking">
                                                <i class="fa-solid fa-lock"></i> Locked
                                            </span>
                                        <% } %>
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
    </div>
</body>
</html>