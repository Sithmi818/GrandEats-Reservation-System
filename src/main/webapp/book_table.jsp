<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.MenuItem" %>
<%@ page import="com.reservation.service.MenuService" %>
<%@ page import="java.util.List" %>
<%
    String user = (String) session.getAttribute("userEmail");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<html>
<head>
    <title>Book a Table - GrandEats</title>
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
            background: rgba(20, 20, 20, 0.4) !important;
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

        .page-header { margin-bottom: 25px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); padding-bottom: 15px; }
        .page-header h2 { margin: 0; color: #ffffff; font-weight: 400; display: flex; align-items: center; gap: 10px; }

        /* --- GLASSMORPHIC FORM CONTAINER --- */
        .form-container {
            max-width: 700px;
            margin: 0 auto;
            background: rgba(25, 25, 25, 0.6) !important;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6) !important;
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
        }

        .form-group { margin-bottom: 22px; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 8px; color: #f39c12; font-size: 14px; letter-spacing: 0.5px; }

        .form-control {
            width: 100%;
            padding: 12px;
            background: rgba(40, 40, 40, 0.6) !important;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 6px !important;
            box-sizing: border-box;
            color: white !important;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            background: rgba(50, 50, 50, 0.8) !important;
            border-color: #f39c12 !important;
            box-shadow: 0 0 8px rgba(243, 156, 18, 0.2) !important;
        }
        .form-control option { background-color: #1a1a1a; color: white; }

        /* --- PRE-ORDER FOOD SECTION --- */
        .food-section {
            background: rgba(35, 35, 35, 0.4) !important;
            padding: 22px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            margin-top: 25px;
            margin-bottom: 25px;
        }
        .food-section h4 { margin-top: 0; color: #f39c12; font-weight: 400; font-size: 16px; margin-bottom: 18px; border-bottom: 1px dashed rgba(255, 255, 255, 0.1); padding-bottom: 10px;}
        .food-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px; }
        .food-item { display: flex; align-items: center; gap: 12px; font-size: 14px; color: #e2e8f0; cursor: pointer; }
        .food-item input[type="checkbox"] { width: 18px; height: 18px; cursor: pointer; accent-color: #f39c12; }
        textarea.form-control { resize: vertical; min-height: 90px; }

        /* --- SUBMIT BUTTON --- */
        .btn-submit {
            background: linear-gradient(135deg, #f39c12, #d35400) !important;
            color: white !important;
            padding: 14px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            width: 100%;
            cursor: pointer;
            font-size: 16px;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(243, 156, 18, 0.2);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(243, 156, 18, 0.4);
            background: linear-gradient(135deg, #f1c40f, #f39c12) !important;
        }

        .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes floatingEffect { 0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; } 100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; } }

        @media (max-width: 600px) {
            .profile-grid { grid-template-columns: 1fr; gap: 0; }
            .floating-star { display: none; }
        }
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
                <div class="page-header">
                    <h2><i class="fa-solid fa-calendar-plus" style="color: #f39c12;"></i> Book a Table</h2>
                </div>

                <div class="form-container">
                    <form action="ReservationServlet" method="POST">
                        <div class="profile-grid">
                            <div class="form-group">
                                <label>Reservation Date</label>
                                <input type="date" name="date" class="form-control" required min="<%= java.time.LocalDate.now() %>">
                            </div>
                            <div class="form-group">
                                <label>Reservation Time</label>
                                <input type="time" name="time" class="form-control" required>
                            </div>
                        </div>

                        <div class="profile-grid">
                            <div class="form-group">
                                <label>Number of Guests</label>
                                <input type="number" name="guests" class="form-control" min="1" max="20" required placeholder="Pax">
                            </div>
                            <div class="form-group">
                                <label>Table Preference</label>
                                <select name="tableType" class="form-control">
                                    <option value="Standard">Standard Table</option>
                                    <option value="Window">Window Seat</option>
                                    <option value="VIP">VIP Private Room</option>
                                </select>
                            </div>
                        </div>

                        <div class="food-section">
                            <h4><i class="fa-solid fa-bell-concierge"></i> Pre-order Food (Optional)</h4>
                            <div class="food-grid">
                                <%
                                    MenuService ms = new MenuService();
                                    List<MenuItem> menuItems = ms.getAllMenuItems();
                                    for(MenuItem m : menuItems) {
                                        if("Available".equals(m.getStatus())) {
                                %>
                                        <label class="food-item">
                                            <input type="checkbox" name="foodItems" value="<%= m.getName() %>">
                                            <%= m.getName() %> (Rs.<%= m.getPrice() %>)
                                        </label>
                                <%      }
                                    }
                                %>
                            </div>
                        </div>

                        <div class="form-group">
                            <label><i class="fa-regular fa-comment-dots"></i> Special Instructions</label>
                            <textarea name="specialNote" class="form-control" placeholder="Any special requests or allergies..."></textarea>
                        </div>

                        <button type="submit" class="btn-submit">Confirm Reservation</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>