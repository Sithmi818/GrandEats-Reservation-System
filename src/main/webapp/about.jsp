<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>About Us - GrandEats</title>
    <meta name="referrer" content="no-referrer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            padding: 0;
            background-color: #0d0d0d;
            background-image: linear-gradient(rgba(0, 0, 0, 0.9), rgba(0, 0, 0, 0.9)),
                              url('https://images.unsplash.com/photo-1541532713592-79a0317b6b77?q=80&w=1888&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
            font-family: 'Poppins', sans-serif;
            color: #ffffff;
            overflow-x: hidden;
            height: auto;
            overflow-y: auto !important;
        }

        .container {
            max-width: 1100px;
            margin: 60px auto;
            padding: 0 20px;
            position: relative;
            min-height: calc(100vh - 280px);
        }

        .about-section {
            display: flex;
            gap: 50px;
            align-items: center;
            background: rgba(25, 25, 25, 0.65);
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 25px 55px rgba(0,0,0,0.6);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            animation: containerPopIn 1.2s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            position: relative;
            z-index: 2;
        }


        .about-text { flex: 1; }

        .about-text h2 {
            color: #f39c12; /* Golden Tone */
            margin-top: 0;
            margin-bottom: 25px;
            font-size: 36px;
            font-weight: 400;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        .about-text p {
            line-height: 1.8;
            color: #bdc3c7; /* Smooth Light Gray */
            margin-bottom: 20px;
            font-size: 15px;
            font-weight: 300;
        }

        .about-text strong {
            color: #f39c12;
            font-weight: 500;
        }

        /* --- IMAGE EFFECTS WITH HOVER GLOW --- */
        .about-img {
            flex: 1;
            position: relative;
        }

        .about-img img {
            width: 100%;
            border-radius: 12px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.8);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        /* Interactive Hover Ambient Glow */
        .about-section:hover .about-img img {
            transform: scale(1.03) translateY(-3px);
            box-shadow: 0 30px 60px rgba(243, 156, 18, 0.2); /* Soft Golden Glow */
        }

        /* --- CSS ICON FLOATING STARS ANIMATION --- */
        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12;
            opacity: 0.4;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.6);
        }

        .star-left {
            top: -30px;
            left: -20px;
            animation: floatingEffect 5s ease-in-out infinite alternate;
        }

        .star-right {
            bottom: -20px;
            right: -20px;
            animation: floatingEffect 7s ease-in-out infinite alternate-reverse;
        }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes containerPopIn {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes floatingEffect {
            0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; }
            100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; }
        }

        @media (max-width: 768px) {
            .about-section { flex-direction: column; padding: 30px; gap: 30px; }
            .star-left, .star-right { display: none; }
        }
    </style>
</head>
<body>

    <jsp:include page="includes/header.jsp" />

    <div class="container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="about-section">
            <div class="about-text">
                <h2>Our Story</h2>
                <p>Founded in 2026, GrandEats started with a simple vision: to bridge the gap between extraordinary culinary art and seamless customer experience.</p>
                <p>We understand that a great dining experience starts before you even enter the restaurant. That is why we built this state-of-the-art reservation platform. Whether it’s a romantic dinner, a corporate meeting, or a family gathering, we guarantee your table is ready.</p>
                <p><strong><i class="fa-solid fa-bullseye"></i> Our Mission:</strong> To provide unparalleled dining experiences with zero waiting times.</p>
            </div>
            <div class="about-img">
                <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=800&auto=format&fit=crop" alt="Restaurant Interior">
            </div>
        </div>
    </div>

    <footer style="background: #050505; padding: 40px 20px; text-align: center; border-top: 1px solid rgba(255,255,255,0.05); width: 100%; position: relative; z-index: 10; margin-top: 40px;">
        <div style="margin-bottom: 20px;">
            <a href="index.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">Home</a>
            <a href="menu.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">Menu</a>
            <a href="about.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">About Us</a>
            <a href="contact.jsp" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px; transition: 0.3s;" onmouseover="this.style.color='#f39c12'" onmouseout="this.style.color='#bdc3c7'">Contact Us</a>
        </div>
        <p style="color: #666; font-size: 13px; margin: 0; letter-spacing: 0.5px;">&copy; 2026 GrandEats. All Rights Reserved.</p>
    </footer>

</body>
</html>