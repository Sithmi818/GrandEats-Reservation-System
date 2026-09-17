<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reset Password - GrandEats</title>
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
            margin: 90px auto;
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
            color: #f39c12; /* Elegant Metallic Gold Title */
            margin-top: 0;
            margin-bottom: 10px;
            font-weight: 400;
            letter-spacing: 1px;
            text-transform: uppercase;
            font-size: 24px;
        }

        .auth-container p {
            color: #bdc3c7 !important;
            margin-bottom: 30px;
            font-size: 14px;
            line-height: 1.5;
            font-weight: 300;
        }

        /* --- STYLING INPUT FIELDS --- */
        .auth-form input {
            width: 100%;
            padding: 14px;
            margin-bottom: 18px;
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
            border-color: #f39c12;
            outline: none;
            background: rgba(50, 50, 50, 0.8);
            box-shadow: 0 0 8px rgba(243, 156, 18, 0.2);
        }
        .auth-form input::placeholder {
            color: #7f8c8d;
        }

        /* --- ANIMATED SUBMIT BUTTON --- */
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #2ecc71, #27ae60); /* Success Green Gradient */
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(46, 204, 113, 0.2);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(46, 204, 113, 0.4);
            background: linear-gradient(135deg, #22c55e, #16a34a);
        }

        /* --- MATCHED: PREMIUM GLOW NOTIFICATION BOXES --- */
        .alert-success {
            background: rgba(40, 167, 69, 0.08) !important;
            color: #85ff9e !important;
            border: 1px solid rgba(40, 167, 69, 0.2) !important;
            border-left: 4px solid #28a745 !important;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 13.5px;
            font-weight: 500;
            text-align: left;
        }
        .alert-error {
            background: rgba(220, 53, 69, 0.08) !important;
            color: #ff9999 !important;
            border: 1px solid rgba(220, 53, 69, 0.2) !important;
            border-left: 4px solid #dc3545 !important;
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 13.5px;
            font-weight: 500;
            text-align: left;
        }

        /* --- BACK TO LOGIN LINK --- */
        .back-link {
            display: block;
            margin-top: 22px;
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
            <h2>Secure Password Reset</h2>
            <p>Please enter the 6-digit code sent to your email along with your new password.</p>

            <%-- Status Messages --%>
            <% if(request.getParameter("status") != null && request.getParameter("status").equals("sent")) { %>
                <div class="alert-success">
                    <i class="fa-solid fa-circle-check"></i> Verification code sent successfully! Check your inbox.
                </div>
            <% } %>

            <% if(request.getParameter("error") != null) { %>
                <div class="alert-error">
                    <i class="fa-solid fa-circle-exclamation" style="margin-right: 5px;"></i>
                    <% if(request.getParameter("error").equals("invalid_otp")) { out.print("Incorrect verification code. Please try again."); } %>
                    <% if(request.getParameter("error").equals("update_failed")) { out.print("Failed to update password. Please try again later."); } %>
                </div>
            <% } %>

            <form action="ResetPasswordServlet" method="POST" class="auth-form">
                <input type="text" name="otp" placeholder="Enter 6-Digit Code" maxlength="6" pattern="[0-9]{6}" required>
                <input type="password" name="newPassword" placeholder="Enter New Password" required>
                <button type="submit" class="btn-submit">Reset Password</button>
            </form>

            <a href="login.jsp" class="back-link"><i class="fa-solid fa-arrow-left" style="font-size: 11px; margin-right: 5px;"></i> Cancel and Back to Login</a>
        </div>
    </div>

</body>
</html>