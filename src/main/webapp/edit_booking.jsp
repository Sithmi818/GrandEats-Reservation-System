<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.Reservation" %>
<%@ page import="com.reservation.service.ReservationService" %>
<%@ page import="com.reservation.model.MenuItem" %>
<%@ page import="com.reservation.service.MenuService" %>
<%@ page import="java.util.List" %>
<%
    String user = (String) session.getAttribute("userEmail");
    if (user == null) { response.sendRedirect("login.jsp"); return; }


    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("my_bookings.jsp");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("my_bookings.jsp");
        return;
    }

    ReservationService rs = new ReservationService();
    Reservation res = rs.getReservationById(id);

    if (res == null || !res.getUserEmail().equals(user)) {
        response.sendRedirect("my_bookings.jsp");
        return;
    }
%>
<html>
<head>
    <title>Edit Booking - GrandEats</title>
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
        .booking-container { position: relative; max-width: 1200px; margin: 0 auto; }

        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12;
            opacity: 0.4;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.6);
        }
        .star-left { top: 140px; left: 15px; animation: floatingEffect 5s ease-in-out infinite alternate; }
        .star-right { bottom: 40px; right: 15px; animation: floatingEffect 7s ease-in-out infinite alternate-reverse; }

        .page-header { margin-bottom: 25px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); padding-bottom: 15px; transition: 0.3s;}
        .page-header h2 { margin: 0; color: #ffffff; font-weight: 400; display: flex; align-items: center; gap: 10px; }

        /* --- GLASSMORPHIC FORM CONTAINER --- */
        .form-container {
            max-width: 700px;
            margin: 0 auto;
            background: rgba(25, 25, 25, 0.6);
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.5s ease;
            animation: formPopIn 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .form-group { margin-bottom: 22px; }
        .form-group label { display: block; font-weight: 500; margin-bottom: 8px; color: #f39c12; font-size: 14px; letter-spacing: 0.5px; }

        .form-control {
            width: 100%;
            padding: 12px;
            background: rgba(40, 40, 40, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 6px;
            box-sizing: border-box;
            color: white;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            background: rgba(50, 50, 50, 0.8);
            border-color: #f39c12;
            box-shadow: 0 0 8px rgba(243, 156, 18, 0.2);
        }
        /* Dropdown Options styling */
        .form-control option { background-color: #1a1a1a; color: white; }

        /* --- PRE-ORDER FOOD SECTION --- */
        .food-section {
            background: rgba(35, 35, 35, 0.4);
            padding: 22px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            margin-top: 25px;
            margin-bottom: 25px;
        }
        .food-section h4 { margin-top: 0; color: #f39c12; font-weight: 400; font-size: 16px; letter-spacing: 1px; margin-bottom: 18px; border-bottom: 1px dashed rgba(255, 255, 255, 0.1); padding-bottom: 10px;}
        .food-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 15px; }
        .food-item { display: flex; align-items: center; gap: 12px; font-size: 14px; color: #e2e8f0; cursor: pointer; transition: color 0.3s; }
        .food-item:hover { color: #f39c12; }
        .food-item input[type="checkbox"] { width: 18px; height: 18px; cursor: pointer; accent-color: #f39c12; }
        textarea.form-control { resize: vertical; min-height: 90px; }

        /* --- SUBMIT BUTTON --- */
        .btn-submit {
            background: linear-gradient(135deg, #f39c12, #d35400);
            color: white;
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
            background: linear-gradient(135deg, #f1c40f, #f39c12);
        }

        .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes formPopIn { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: translateY(0); } }
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
                    <h2><i class="fa-solid fa-pen-to-square" style="color: #f39c12;"></i> Edit Reservation</h2>
                </div>

                <div class="form-container">
                    <form action="UpdateReservationServlet" method="POST">

                        <input type="hidden" name="id" value="<%= res.getId() %>">

                        <div class="profile-grid">
                            <div class="form-group">
                                <label>Reservation Date</label>
                                <input type="date" name="date" class="form-control" value="<%= res.getDate() %>" required min="<%= java.time.LocalDate.now() %>">
                            </div>
                            <div class="form-group">
                                <label>Reservation Time</label>
                                <input type="time" name="time" class="form-control" value="<%= res.getTime() %>" required>
                            </div>
                        </div>

                        <div class="profile-grid">
                            <div class="form-group">
                                <label>Number of Guests</label>
                                <input type="number" name="guests" class="form-control" value="<%= res.getGuests() %>" min="1" max="20" required>
                            </div>
                            <div class="form-group">
                                <label>Table Preference</label>
                                <select name="tableType" class="form-control">
                                    <option value="Standard" <%= res.getTableType().equals("Standard") ? "selected" : "" %>>Standard Table</option>
                                    <option value="Window" <%= res.getTableType().equals("Window") ? "selected" : "" %>>Window Seat</option>
                                    <option value="VIP" <%= res.getTableType().equals("VIP") ? "selected" : "" %>>VIP Private Room</option>
                                </select>
                            </div>
                        </div>

                        <div class="food-section">
                            <h4><i class="fa-solid fa-bell-concierge"></i> Pre-order Food (Optional)</h4>
                            <div class="food-grid">
                                <%
                                    MenuService ms = new MenuService();
                                    List<MenuItem> menuItems = ms.getAllMenuItems();
                                    String currentFood = res.getPreOrderedFood();

                                    for(MenuItem m : menuItems) {
                                        if("Available".equals(m.getStatus())) {
                                            boolean isChecked = currentFood != null && currentFood.contains(m.getName());
                                %>
                                        <label class="food-item">
                                            <input type="checkbox" name="foodItems" value="<%= m.getName() %>" <%= isChecked ? "checked" : "" %>>
                                            <%= m.getName() %> (Rs.<%= m.getPrice() %>)
                                        </label>
                                <%      }
                                    }
                                %>
                            </div>
                        </div>

                        <div class="form-group">
                            <label><i class="fa-regular fa-comment-dots"></i> Special Instructions</label>
                            <textarea name="specialNote" class="form-control" placeholder="Any requests..."><%= "None".equals(res.getSpecialNote()) ? "" : res.getSpecialNote() %></textarea>
                        </div>

                        <button type="submit" class="btn-submit">Update Reservation</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>