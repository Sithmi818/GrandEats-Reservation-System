<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.Reservation" %>
<%@ page import="com.reservation.service.ReservationService" %>
<%@ page import="java.util.List" %>
<%
    // Security Check
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Admin Dashboard - GrandEats</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

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

        /* --- FLOATING DECORATIONS (NO IMAGES - 100% RELIABLE) --- */
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

        /* --- PREMIUM ANIMATED STAT CARDS --- */
        .stat-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 25px; margin-bottom: 30px; }

        .card {
            background: rgba(30, 30, 30, 0.65);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            border-left: 5px solid #f39c12;
            backdrop-filter: blur(10px);
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            border-right: 1px solid rgba(255, 255, 255, 0.05);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.4s ease;
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(243, 156, 18, 0.15); }
        .card h3 { margin: 0 0 10px 0; color: #f39c12; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
        .card p { margin: 0; font-size: 32px; font-weight: bold; color: #ffffff; }

        /* --- GLASSMORPHIC TABLE STYLING --- */
        .table-container {
            background: rgba(25, 25, 25, 0.55);
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(12px);
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }
        .table-custom { width: 100%; border-collapse: collapse; text-align: left; color: #ecf0f1; }
        .table-custom th { background-color: rgba(40, 40, 40, 0.6); color: #f39c12; padding: 15px; font-weight: 500; text-transform: uppercase; font-size: 13px; border-bottom: 2px solid rgba(255,255,255,0.05); }
        .table-custom td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.05); color: #e2e8f0; font-size: 14px; background: transparent; }
        .table-custom tr:hover td { background-color: rgba(255, 255, 255, 0.03); }

        .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; }
        .customer-email { color: #3498db; font-weight: bold; text-decoration: none; transition: color 0.3s; }
        .customer-email:hover { color: #f39c12; text-decoration: underline; }

        /* Action Buttons */
        .btn-action { color: white; border: none; padding: 8px 14px; border-radius: 6px; cursor: pointer; font-weight: bold; font-size: 12px; transition: all 0.3s ease; text-decoration: none; display: inline-block; }
        .btn-approve { background: #28a745; box-shadow: 0 4px 10px rgba(40, 167, 69, 0.2); }
        .btn-approve:hover { background: #2ecc71; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(40, 167, 69, 0.4); }
        .btn-reject { background: #dc3545; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.2); }
        .btn-reject:hover { background: #ff4757; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(220, 53, 69, 0.4); }

        /* DataTables Premium Dark Customization Fixes */
        .dataTables_wrapper { color: #fff !important; }
        .dataTables_wrapper .dataTables_filter input { padding: 8px 12px; border-radius: 6px; border: 1px solid rgba(255,255,255,0.1); margin-left: 10px; background: rgba(30,30,30,0.5); color: white; }
        .dataTables_wrapper .dataTables_length select { padding: 6px; border-radius: 6px; border: 1px solid rgba(255,255,255,0.1); background: rgba(30,30,30,0.5); color: white; }
        .dataTables_wrapper .dataTables_info { color: #bdc3c7 !important; margin-top: 15px; }
        .dataTables_wrapper .dataTables_paginate .paginate_button { color: #fff !important; border-radius: 6px !important; border: none !important; transition: all 0.3s; }
        .dataTables_wrapper .dataTables_paginate .paginate_button.current { background: #f39c12 !important; color: black !important; border: none !important; font-weight: bold; }
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover { background: rgba(243, 156, 18, 0.2) !important; color: white !important; }
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
        <a href="admin_dashboard.jsp" style="color: #f39c12; text-decoration: none; font-weight: bold;"><i class="fa-solid fa-house"></i> Dashboard</a>
        <a href="admin_users.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-users"></i> User Management</a>
        <a href="admin_menu.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-burger"></i> Menu</a>
        <a href="admin_messages.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-envelope"></i> Messages</a>
        <a href="admin_reports.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-chart-pie"></i> Reports</a>
    </div>

    <div class="admin-container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="admin-content">
            <h2 style="margin-top: 0; color: #ffffff; font-weight: 400; letter-spacing: 1px;"><i class="fa-solid fa-chart-line" style="color: #f39c12;"></i> Dashboard Overview</h2>

            <%
                ReservationService rs = new ReservationService();
                List<Reservation> allBookings = rs.getAllReservations();

                int totalBookings = allBookings.size();
                int totalGuests = 0;
                for(Reservation r : allBookings) {
                    if(!"Cancelled".equalsIgnoreCase(r.getStatus())) {
                        totalGuests += r.getGuests();
                    }
                }
            %>

            <div class="stat-cards">
                <div class="card">
                    <h3>Total Bookings (All Time)</h3>
                    <p><i class="fa-solid fa-calendar-check" style="color: #f39c12;"></i> <%= totalBookings %></p>
                </div>
                <div class="card">
                    <h3>Total Guests Expected</h3>
                    <p><i class="fa-solid fa-users" style="color: #17a2b8;"></i> <%= totalGuests %></p>
                </div>
            </div>

            <h3 style="margin-top: 40px; color: #ffffff; font-weight: 400; letter-spacing: 0.5px;"><i class="fa-solid fa-list" style="color: #f39c12;"></i> All Customer Reservations</h3>

            <div class="table-container">
                <table id="bookingsTable" class="table-custom">
                    <thead>
                        <tr>
                            <th>Customer Email</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Guests</th>
                            <th>Table Type</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if(!allBookings.isEmpty()) {
                                for(Reservation r : allBookings) {
                        %>
                            <tr>
                                <td><a href="mailto:<%= r.getUserEmail() %>" class="customer-email"><i class="fa-solid fa-envelope" style="color: #bdc3c7;"></i> <%= r.getUserEmail() %></a></td>
                                <td><strong><i class="fa-regular fa-calendar" style="color: #f39c12; margin-right: 5px;"></i> <%= r.getDate() %></strong></td>
                                <td><i class="fa-regular fa-clock" style="color: #bdc3c7; margin-right: 5px;"></i> <%= r.getTime() %></td>
                                <td><i class="fa-solid fa-user-group" style="color: #bdc3c7; margin-right: 5px;"></i> <%= r.getGuests() %> Persons</td>
                                <td><%= r.getTableType() %></td>

                                <td>
                                    <% if("Pending".equalsIgnoreCase(r.getStatus())) { %>
                                        <span class="badge" style="background: rgba(255, 243, 205, 0.15); color: #ffe699; border: 1px solid rgba(255, 238, 186, 0.3);"><i class="fa-solid fa-clock"></i> Pending</span>
                                    <% } else if("Cancelled".equalsIgnoreCase(r.getStatus())) { %>
                                        <span class="badge" style="background: rgba(248, 215, 218, 0.15); color: #ffb3b3; border: 1px solid rgba(245, 198, 203, 0.3);"><i class="fa-solid fa-ban"></i> Cancelled</span>
                                    <% } else { %>
                                        <span class="badge" style="background: rgba(212, 237, 218, 0.15); color: #99ffb3; border: 1px solid rgba(195, 230, 203, 0.3);"><i class="fa-solid fa-check-double"></i> Confirmed</span>
                                    <% } %>
                                </td>

                                <td>
                                    <% if("Pending".equalsIgnoreCase(r.getStatus())) { %>
                                        <div style="display: flex; gap: 5px;">
                                            <a href="ApproveReservationServlet?id=<%= r.getId() %>" class="btn-action btn-approve"><i class="fa-solid fa-check"></i> Approve</a>
                                            <a href="#" onclick="confirmReject(<%= r.getId() %>)" class="btn-action btn-reject"><i class="fa-solid fa-xmark"></i> Reject</a>
                                        </div>
                                    <% } else if("Cancelled".equalsIgnoreCase(r.getStatus())) { %>
                                        <span style="color: #ff4757; font-weight: bold; font-size: 13px;"><i class="fa-solid fa-ban"></i> Rejected</span>
                                    <% } else { %>
                                        <span style="color: #2ed573; font-weight: bold; font-size: 13px;"><i class="fa-solid fa-check-circle"></i> Approved</span>
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

    <script>
        $(document).ready(function() {
            $('#bookingsTable').DataTable({
                "pageLength": 5,
                "lengthMenu": [5, 10, 25, 50],
                "order": [[ 1, "desc" ]],
                "language": {
                    "emptyTable": "No reservations found in the system."
                }
            });
        });

        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('msg')) {
            const msg = urlParams.get('msg');
            if (msg === 'approved') {
                Swal.fire({
                    icon: 'success',
                    title: 'Approved!',
                    text: 'Reservation successfully approved!',
                    confirmButtonColor: '#28a745'
                });
            } else if (msg === 'cancelled') {
                Swal.fire({
                    icon: 'success',
                    title: 'Rejected!',
                    text: 'Reservation successfully rejected and cancelled!',
                    confirmButtonColor: '#dc3545'
                });
            }
        }

        function confirmReject(id) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You are about to reject this booking!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, reject it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'CancelReservationServlet?id=' + id;
                }
            })
        }
    </script>
</body>
</html>