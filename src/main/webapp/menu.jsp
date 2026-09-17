<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.MenuItem" %>
<%@ page import="com.reservation.service.MenuService" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Menu - GrandEats</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* --- PREMIUM SMOOTH SCROLL OVERRIDE --- */
        html {
            scroll-behavior: smooth;
        }

        /* --- PREMIUM CINEMATIC DARK BACKGROUND (EXACT MATCH) --- */
        body {
            margin: 0;
            padding: 0;
            background-color: #060606;
            background-image: linear-gradient(rgba(0, 0, 0, 0.92), rgba(0, 0, 0, 0.92)),
                              url('https://images.unsplash.com/photo-1541532713592-79a0317b6b77?q=80&w=1888&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
            font-family: 'Poppins', sans-serif;
            color: #ffffff;
            overflow-x: hidden;
            height: auto;
            overflow-y: auto !important;
        }

        .menu-wrapper {
            max-width: 1000px;
            margin: 60px auto 0 auto;
            padding: 0 20px;
        }

        /* --- MENU MAIN TITLE --- */
        .menu-main-title {
            text-align: center;
            font-family: 'Georgia', serif;
            font-size: 3rem;
            letter-spacing: 3px;
            text-transform: uppercase;
            color: #ffffff;
            margin-bottom: 80px;
            position: relative;
        }
        .menu-main-title::after {
            content: '';
            display: block;
            width: 60px;
            height: 1px;
            background: rgba(255, 255, 255, 0.3);
            margin: 15px auto 0 auto;
        }

        /* --- VERTICAL SHOWCASE ROW LAYOUT --- */
        .menu-showcase-container {
            display: flex;
            flex-direction: column;
            gap: 100px;
            position: relative;
        }

        .menu-item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 50px;
            width: 100%;
            opacity: 0;
            transform: translateY(40px); /* Slightly reduced for a tighter, premium feel */
            transition: all 1s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .menu-item-row:nth-child(even) {
            flex-direction: row-reverse;
        }

        /* --- IMAGE ZONE: WITH FLOUR DUST --- */
        .menu-image-zone {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        .menu-image-zone::before {
            content: '';
            position: absolute;
            width: 130%;
            height: 130%;
            background-image: url('https://www.pngarts.com/files/7/Powder-Splash-PNG-Photo.png');
            background-size: contain;
            background-position: center;
            background-repeat: no-repeat;
            opacity: 0.12;
            pointer-events: none;
            z-index: 1;
        }

        /* 🔴 100% FIXED IMAGE DISPLAY OVERRIDE */
        .circular-plate {
            width: 320px;
            height: 320px;
            border-radius: 50% !important;
            object-fit: cover !important;
            box-shadow: 0 30px 60px rgba(0,0,0,0.9);
            border: 4px solid rgba(25, 25, 25, 0.8);
            position: relative;
            z-index: 2;
            transition: transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .menu-item-row:hover .circular-plate {
            transform: scale(1.04);
        }

        /* --- TEXT LAYER --- */
        .menu-text-zone {
            flex: 1;
            text-align: left;
        }
        .menu-item-row:nth-child(even) .menu-text-zone {
            text-align: right;
        }

        .menu-text-zone .category {
            font-size: 11px;
            text-transform: uppercase;
            color: #f39c12;
            letter-spacing: 2px;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
        }

        .menu-text-zone h3 {
            font-family: 'Georgia', serif;
            font-size: 1.8rem;
            color: #ffffff;
            margin: 0 0 12px 0;
            font-weight: 400;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .menu-text-zone p {
            color: #bdc3c7;
            font-size: 14px;
            line-height: 1.7;
            margin: 0 0 15px 0;
            font-weight: 300;
        }

        .menu-text-zone .price {
            font-size: 18px;
            font-weight: bold;
            color: #ffffff;
            display: block;
            margin-bottom: 10px;
        }

        .status-tag {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: bold;
        }
        .status-instock { color: #2ecc71; }
        .status-outstock { color: #e74c3c; }

        /* --- FOOTER DECORATION --- */
        .menu-footer-tag {
            text-align: center;
            font-family: 'Georgia', serif;
            font-style: italic;
            font-size: 24px;
            color: rgba(255, 255, 255, 0.4);
            margin-top: 120px;
            margin-bottom: 60px;
            letter-spacing: 1px;
        }

        /* Active class driven by JavaScript on Scroll */
        .menu-item-row.reveal-active {
            opacity: 1;
            transform: translateY(0);
        }

        @media (max-width: 768px) {
            .menu-item-row, .menu-item-row:nth-child(even) { flex-direction: column; text-align: center !important; gap: 30px; }
            .circular-plate { width: 260px; height: 260px; }
        }
    </style>
</head>
<body>

    <jsp:include page="includes/header.jsp" />

    <div class="menu-wrapper">

        <h1 class="menu-main-title">Menu</h1>

        <div class="menu-showcase-container">
            <%
                MenuService ms = new MenuService();
                List<MenuItem> items = ms.getAllMenuItems();
                for(MenuItem m : items) {
            %>
                <div class="menu-item-row">

                    <div class="menu-image-zone">
                        <img src="<%= m.getImageUrl() %>" class="circular-plate" alt="<%= m.getName() %>">
                    </div>

                    <div class="menu-text-zone">
                        <span class="category"><%= m.getCategory() %></span>
                        <h3><%= m.getName() %></h3>
                        <p>Our premium curated <%= m.getName().toLowerCase() %> crafted meticulously by our master chefs using fresh, high-quality ingredients.</p>
                        <span class="price">Rs. <%= m.getPrice() %></span>

                        <% if("Available".equalsIgnoreCase(m.getStatus())) { %>
                            <span class="status-tag status-instock"><i class="fa-solid fa-circle" style="font-size: 8px; margin-right: 5px;"></i> Available</span>
                        <% } else { %>
                            <span class="status-tag status-outstock"><i class="fa-solid fa-circle" style="font-size: 8px; margin-right: 5px;"></i> Out of stock</span>
                        <% } %>
                    </div>

                </div>
            <% } %>
        </div>

        <div class="menu-footer-tag">it is delicious</div>

    </div>

    <footer style="background: #050505; padding: 40px 20px; text-align: center; border-top: 1px solid rgba(255,255,255,0.05); width: 100%; position: relative; z-index: 10;">
        <div style="margin-bottom: 20px;">
            <a href="index.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">Home</a>
            <a href="menu.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">Menu</a>
            <a href="about.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">About Us</a>
            <a href="contact.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">Contact Us</a>
        </div>
        <p style="color: #666; font-size: 13px; margin: 0; letter-spacing: 0.5px;">&copy; 2026 GrandEats. All Rights Reserved.</p>
    </footer>

    <script>
        function revealRows() {
            const rows = document.querySelectorAll('.menu-item-row');
            const windowHeight = window.innerHeight;

            rows.forEach(row => {
                const rowTop = row.getBoundingClientRect().top;
                if (rowTop < windowHeight - 40) {
                    row.classList.add('reveal-active');
                }
            });
        }

        window.addEventListener('scroll', revealRows);
        window.addEventListener('DOMContentLoaded', revealRows);
    </script>

</body>
</html>