<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Overview - GrandEats</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* --- PREMIUM ULTRA-DARK BAKERY & FLOUR DUST BACKGROUND --- */
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #050505;
            background-image: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.85)),
                              url('https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
            margin: 0;
            color: #ffffff;
            overflow-x: hidden;
        }

        /* --- DASHBOARD STRUCTURAL WRAPPER --- */
        .dashboard-wrapper {
            display: flex;
            gap: 30px;
            padding: 40px;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 5;
        }

        /* --- SIDEBAR GLASS EFFECT --- */
        .dashboard-wrapper .sidebar,
        .dashboard-wrapper aside,
        div[class*="sidebar"] {
            background: rgba(20, 20, 20, 0.6) !important;
            backdrop-filter: blur(20px) !important;
            -webkit-backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            border-radius: 16px !important;
            color: white !important;
            box-shadow: 0 25px 60px rgba(0,0,0,0.6) !important;
        }

        /* --- MAIN CONTENT LAYER (SEAMLESS GLASS CONTAINER) --- */
        .main-content {
            flex: 1;
            padding: 35px !important;
            background: rgba(25, 25, 25, 0.45) !important; /* Premium Matte Glass */
            backdrop-filter: blur(15px) !important;
            -webkit-backdrop-filter: blur(15px) !important;
            border-radius: 16px !important;
            border: 1px solid rgba(255, 255, 255, 0.04) !important;
            box-shadow: 0 25px 55px rgba(0,0,0,0.6) !important;
            animation: fadeIn 1s ease-out;
            position: relative;
        }

        /* Ambient Decorative Flour Dust Clusters */
        .main-content::before {
            content: '';
            position: absolute;
            top: 0; right: 0; width: 150px; height: 150px;
            background-image: url('https://cdn-icons-png.flaticon.com/512/1047/1047503.png'); /* Flour/Salt hint */
            background-size: contain;
            opacity: 0.05;
            pointer-events: none;
        }

        .welcome-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px; }
        .welcome-header h2 { margin: 0; color: #ffffff; font-weight: 400; font-size: 30px; letter-spacing: 0.5px; }
        .welcome-header p { color: #bdc3c7 !important; font-size: 14.5px; margin-top: 5px; }

        /* --- UNIFORM LUXURY GOLD & MATTE GLASS CARDS --- */
        .stat-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-top: 25px; }

        .card {
            padding: 28px 22px;
            border-radius: 14px;
            background: rgba(30, 30, 30, 0.55) !important;
            box-shadow: 0 15px 35px rgba(0,0,0,0.4) !important;
            border: 1px solid rgba(255, 255, 255, 0.04) !important;
            border-left: 4px solid #f39c12 !important; /* Royal Gold Left Line */
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            color: #ffffff !important;
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 40px rgba(243, 156, 18, 0.12) !important;
            border-left-color: #f1c40f !important;
        }
        .card h3 { margin: 10px 0 0 0; font-size: 34px; font-weight: 300; color: #ffffff; }
        .card p { margin: 4px 0 0 0; color: #bdc3c7; font-weight: 400; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
        .card i { font-size: 24px; color: #f39c12; }

        /* Text-based Chic Promo Banner */
        .promo-banner {
            background: rgba(35, 35, 35, 0.7);
            padding: 25px 35px;
            border-radius: 14px;
            color: white;
            margin-top: 35px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.5);
            border: 1px solid rgba(243, 156, 18, 0.15);
        }
        .promo-text h3 { margin: 0 0 6px 0; font-size: 20px; font-weight: 400; color: #f39c12; }
        .promo-text p { margin: 0; font-size: 14px; color: #bdc3c7; }
        .btn-promo {
            padding: 12px 28px;
            background: linear-gradient(135deg, #f39c12, #d35400);
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            font-size: 12px;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }
        .btn-promo:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(243, 156, 18, 0.3); }

        /* Activity Items */
        .activity-list { list-style: none; padding: 0; margin-top: 25px; }
        .activity-list li {
            padding: 16px 22px;
            border-left: 3px solid rgba(243, 156, 18, 0.3);
            background: rgba(30, 30, 30, 0.35);
            margin-bottom: 12px;
            border-radius: 8px;
            font-size: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid rgba(255,255,255,0.02);
            transition: all 0.3s ease;
        }
        .activity-list li:hover { transform: translateX(4px); background: rgba(40, 40, 40, 0.5); border-left-color: #f39c12; }
        .activity-left { display: flex; align-items: center; gap: 15px; color: #e2e8f0; }
        .activity-left i { color: #f39c12; font-size: 15px; }
        .activity-time { font-size: 12px; color: #bdc3c7; background: rgba(255,255,255,0.04); padding: 4px 12px; border-radius: 20px; }

        /* Header Buttons */
        .btn-header { padding: 11px 22px; border-radius: 6px; font-weight: bold; text-decoration: none; display: inline-block; transition: all 0.3s ease; font-size: 13px; text-transform: uppercase; }
        .btn-outline { background: rgba(40, 40, 40, 0.4); color: #bdc3c7; border: 1px solid rgba(255,255,255,0.08); }
        .btn-outline:hover { background: rgba(55, 55, 55, 0.7); border-color: #f39c12; color: white; transform: translateY(-2px); }
        .btn-dark { background: linear-gradient(135deg, #f39c12, #d35400); color: white; border: none; }
        .btn-dark:hover { background: linear-gradient(135deg, #f1c40f, #f39c12); transform: translateY(-2px); }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 991px) {
            .dashboard-wrapper { flex-direction: column; padding: 20px; }
            .welcome-header { flex-direction: column; align-items: flex-start; gap: 20px; }
            .promo-banner { flex-direction: column; text-align: center; gap: 20px; }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="dashboard-wrapper">
        <jsp:include page="includes/sidebar.jsp" />

        <div class="main-content">
            <div class="welcome-header">
                <div>
                    <h2>Welcome Back! <i class="fa-solid fa-hand-wave" style="color: #f39c12;"></i></h2>
                    <p>Here is what's happening with your dining account today.</p>
                </div>
                <div style="display: flex; gap: 15px;">
                    <a href="contact.jsp" class="btn-header btn-outline"><i class="fa-solid fa-envelope"></i> Contact Support</a>
                    <a href="book_table.jsp" class="btn-header btn-dark"><i class="fa-solid fa-plus"></i> New Booking</a>
                </div>
            </div>

            <div class="stat-cards">
                <div class="card"><i class="fa-solid fa-calendar-check"></i><h3>1</h3><p>Upcoming Bookings</p></div>
                <div class="card"><i class="fa-solid fa-utensils"></i><h3>4</h3><p>Total Past Visits</p></div>
                <div class="card"><i class="fa-solid fa-star"></i><h3>450</h3><p>Loyalty Points</p></div>
                <div class="card"><i class="fa-solid fa-crown"></i><h3 style="font-size: 30px; margin-top: 15px; font-weight: 300;">Gold</h3><p>Member Status</p></div>
            </div>

            <div class="promo-banner">
                <div class="promo-text">
                    <h3><i class="fa-solid fa-gift"></i> Special Member Offer!</h3>
                    <p>Redeem 300 Loyalty Points for a complimentary dessert on your next visit.</p>
                </div>
                <a href="book_table.jsp" class="btn-promo">Claim Offer</a>
            </div>

            <h3 style="margin-top: 45px; border-bottom: 1px solid rgba(255,255,255,0.08); padding-bottom: 12px; color: #ffffff; font-weight: 300; letter-spacing: 0.5px;">Recent Activity</h3>
            <ul class="activity-list">
                <li><div class="activity-left"><i class="fa-solid fa-right-to-bracket"></i><span>Logged into the dashboard securely</span></div><span class="activity-time">Just now</span></li>
                <li><div class="activity-left"><i class="fa-solid fa-calendar-plus"></i><span>Reserved a VIP Private Room for 4 Guests</span></div><span class="activity-time">Yesterday</span></li>
                <li><div class="activity-left"><i class="fa-solid fa-star"></i><span>Left a 5-star review for the Seafood Platter</span></div><span class="activity-time">April 10, 2026</span></li>
            </ul>
        </div>
    </div>
</body>
</html>