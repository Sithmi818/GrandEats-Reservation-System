<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.Reservation" %>
<%@ page import="com.reservation.service.ReservationService" %>
<%@ page import="java.util.List" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    ReservationService rs = new ReservationService();
    List<Reservation> allBookings = rs.getAllReservations();

    int total = allBookings.size();
    int confirmed = 0;
    int pending = 0;
    int cancelled = 0;

    for(Reservation r : allBookings) {
        if("Approved".equalsIgnoreCase(r.getStatus())) confirmed++;
        else if("Pending".equalsIgnoreCase(r.getStatus())) pending++;
        else if("Cancelled".equalsIgnoreCase(r.getStatus())) cancelled++;
    }
%>
<html>
<head>
    <title>Reports - Admin Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        /* --- PREMIUM ANIMATED STAT BOXES --- */
        .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .stat-box {
            background: rgba(30, 30, 30, 0.65);
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }
        .stat-box:hover { transform: translateY(-5px); }
        .stat-box h4 { margin: 0; color: #f39c12; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-box p { margin: 10px 0 0 0; font-size: 32px; font-weight: bold; color: #ffffff; }

        /* Charts Section */
        .charts-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 30px; margin-bottom: 40px; }

        .chart-card {
            background: rgba(25, 25, 25, 0.55);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }
        .chart-card h3 { margin-top: 0; color: #ffffff; text-align: center; margin-bottom: 20px; font-weight: 400; font-size: 16px; letter-spacing: 0.5px; }

        .chart-wrapper { position: relative; height: 300px; width: 100%; }

        /* --- GLASSMORPHIC REPORT CARD --- */
        .report-card {
            background: rgba(20, 20, 20, 0.65);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            text-align: center;
            border-top: 5px solid #28a745;
            backdrop-filter: blur(10px);
            border-left: 1px solid rgba(255, 255, 255, 0.05);
            border-right: 1px solid rgba(255, 255, 255, 0.05);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .report-card i { font-size: 50px; color: #2ecc71; margin-bottom: 15px; text-shadow: 0 0 15px rgba(46, 204, 113, 0.4); }
        .report-card h3 { margin: 0 0 10px 0; color: #ffffff; font-size: 22px; font-weight: 500; }
        .report-card p { color: #bdc3c7; margin-bottom: 25px; line-height: 1.6; font-size: 14px; }

        .btn-download {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
            padding: 14px 30px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            font-size: 16px;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        .btn-download:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.5);
            background: linear-gradient(135deg, #2ecc71, #28a745);
        }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes floatingEffect { 0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; } 100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; } }

        @media (max-width: 768px) { .charts-container { grid-template-columns: 1fr; } .floating-star { display: none; } }
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
        <a href="admin_messages.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-envelope"></i> Messages</a>
        <a href="admin_reports.jsp" style="color: #f39c12; text-decoration: none; font-weight: bold;"><i class="fa-solid fa-chart-pie"></i> Reports</a>
    </div>

    <div class="admin-container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="admin-content">
            <h2 style="margin-top: 0; color: #ffffff; font-weight: 400; letter-spacing: 1px; margin-bottom: 30px;"><i class="fa-solid fa-chart-pie" style="color: #f39c12;"></i> System Reports & Analytics</h2>

            <div class="stat-grid">
                <div class="stat-box" style="border-bottom: 4px solid #17a2b8;">
                    <h4>Total Bookings</h4>
                    <p><%= total %></p>
                </div>
                <div class="stat-box" style="border-bottom: 4px solid #28a745;">
                    <h4>Approved</h4>
                    <p><%= confirmed %></p>
                </div>
                <div class="stat-box" style="border-bottom: 4px solid #ffc107;">
                    <h4>Pending</h4>
                    <p><%= pending %></p>
                </div>
                <div class="stat-box" style="border-bottom: 4px solid #dc3545;">
                    <h4>Cancelled</h4>
                    <p><%= cancelled %></p>
                </div>
            </div>

            <div class="charts-container">
                <div class="chart-card">
                    <h3>Reservation Status Breakdown</h3>
                    <div class="chart-wrapper">
                        <canvas id="statusPieChart"></canvas>
                    </div>
                </div>
                <div class="chart-card">
                    <h3>Bookings Overview</h3>
                    <div class="chart-wrapper">
                        <canvas id="statusBarChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="report-card">
                <i class="fa-solid fa-file-pdf"></i>
                <h3>Reservation Data Report</h3>
                <p>Download a complete list of all customer reservations, including pre-ordered food and special notes in PDF format.</p>
                <a href="DownloadReportServlet" class="btn-download"><i class="fa-solid fa-download"></i> Download Full Report (PDF)</a>
            </div>
        </div>
    </div>

    <script>
        const confirmedData = <%= confirmed %>;
        const pendingData = <%= pending %>;
        const cancelledData = <%= cancelled %>;

        // Custom global Chart.js configuration to make fonts light-gray for dark theme
        Chart.defaults.color = '#bdc3c7';
        Chart.defaults.font.family = 'Poppins, sans-serif';

        // 1. Pie Chart හැදීම
        const pieCtx = document.getElementById('statusPieChart').getContext('2d');
        new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: ['Approved', 'Pending', 'Cancelled'],
                datasets: [{
                    data: [confirmedData, pendingData, cancelledData],
                    backgroundColor: ['#28a745', '#ffc107', '#dc3545'],
                    borderColor: '#1e1e1e',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        labels: { color: '#ffffff' }
                    }
                }
            }
        });

        // 2. Bar Chart හැදීම
        const barCtx = document.getElementById('statusBarChart').getContext('2d');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: ['Approved', 'Pending', 'Cancelled'],
                datasets: [{
                    label: 'Number of Reservations',
                    data: [confirmedData, pendingData, cancelledData],
                    backgroundColor: ['#28a745', '#ffc107', '#dc3545'],
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1, color: '#bdc3c7' },
                        grid: { color: 'rgba(255, 255, 255, 0.05)' }
                    },
                    x: {
                        ticks: { color: '#bdc3c7' },
                        grid: { display: false }
                    }
                },
                plugins: { legend: { display: false } }
            }
        });
    </script>
</body>
</html>