<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Forgot Password - GrandEats</title>
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
        .page-container {
            position: relative;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* --- GLOWING FLOATING STARS ANIMATION (NO IMAGES - 100% RELIABLE!) --- */
        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12; /* Golden Sparkle */
            opacity: 0.4;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.7); /* Luxury Neon Glow */
        }

        .star-left {
            top: 140px;
            left: 40px;
            animation: floatingEffect 5s ease-in-out infinite alternate;
        }

        .star-right {
            bottom: 40px;
            right: 40px;
            animation: floatingEffect 7s ease-in-out infinite alternate-reverse;
        }

        /* --- GLASSMORPHIC AUTH CONTAINER --- */
        .auth-container {
            max-width: 400px;
            margin: 100px auto;
            background: rgba(25, 25, 25, 0.65);
            padding: 45px 40px;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            text-align: center;
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            position: relative;
            z-index: 5;
            animation: formPopIn 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .auth-container h2 {
            margin-top: 0;
            font-weight: 400;
            color: #ffffff;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }

        .auth-container p {
            color: #bdc3c7 !important;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        /* --- STYLING INPUT FIELDS --- */
        .auth-form input {
            width: 100%;
            padding: 14px;
            margin-bottom: 22px;
            background: rgba(40, 40, 40, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 6px;
            box-sizing: border-box;
            color: white;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .auth-form input:focus {
            outline: none;
            background: rgba(50, 50, 50, 0.8);
            border-color: #f39c12;
            box-shadow: 0 0 8px rgba(243, 156, 18, 0.2);
        }
        /* Input placeholder color fix */
        .auth-form input::placeholder {
            color: #7f8c8d;
        }

        /* --- ANIMATED SUBMIT BUTTON --- */
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #f39c12, #d35400);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: bold;
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
        .btn-submit:active { transform: translateY(0); }

        /* --- BACK TO LOGIN LINK --- */
        .back-link {
            display: block;
            margin-top: 20px;
            font-size: 13px;
            color: #bdc3c7;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        .back-link:hover {
            color: #f39c12;
            text-decoration: underline;
        }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes formPopIn {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes floatingEffect {
            0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; }
            100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; }
        }

        @media (max-width: 600px) {
            .floating-star { display: none; }
            .auth-container { margin: 60px 20px; padding: 35px 25px; }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="page-container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="auth-container">
            <h2>Forgot Password?</h2>
            <p>Enter your email to receive a 6-digit verification code.</p>

            <form action="ForgotPasswordServlet" method="POST" class="auth-form">
                <input type="email" name="email" placeholder="Enter Registered Email" required>
                <button type="submit" class="btn-submit">Send Code</button>
            </form>

            <a href="login.jsp" class="back-link"><i class="fa-solid fa-arrow-left" style="font-size: 11px; margin-right: 5px;"></i> Back to Login</a>
        </div>
    </div>
</body>
</html>