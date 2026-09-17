<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.service.UserService" %>
<%
    UserService us = new UserService();
    String nextId = us.getNextUserId();
%>
<html>
<head>
    <title>Sign Up - GrandEats</title>
    <meta name="referrer" content="no-referrer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* ---  EXACT SEAMLESS FULL-SCREEN HERO BACKGROUND --- */
        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: #080808;
            /* login.jsp එකට 100%ක්ම සර්වසම සිනමාටික් සීෆුඩ් පසුබිම */
            background-image: linear-gradient(to right, rgba(8, 8, 8, 1) 40%, rgba(8, 8, 8, 0.4) 70%, rgba(8, 8, 8, 0.1) 100%),
                              url('https://images.unsplash.com/photo-1514516345957-556ca7d90a29?q=80&w=1600&auto=format&fit=crop');
            background-size: cover;
            background-position: right center;
            background-repeat: no-repeat;
            font-family: 'Poppins', sans-serif;
            color: #ffffff;
            overflow: hidden;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 40px;
            height: calc(100% - 80px); /* Adjusts for header space */
            display: flex;
            align-items: center;
            justify-content: flex-start; /* Keeps the form cleanly on the dark left side */
        }

        /* --- PREMIUM GLASSMORPHIC AUTH CONTAINER --- */
        .auth-container {
            width: 100%;
            max-width: 420px;
            background: rgba(20, 20, 20, 0.65);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 25px 55px rgba(0,0,0,0.7);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-left: 4px solid #f39c12; /* Elegant Gold Accent Line */
            text-align: center;
            animation: formPopIn 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .auth-container h2 {
            color: #f39c12;
            margin-top: 0;
            margin-bottom: 8px;
            font-weight: 400;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            font-size: 24px;
        }

        .auth-container p {
            color: #bdc3c7 !important;
            margin-bottom: 25px;
            font-size: 14px;
            line-height: 1.5;
            font-weight: 300;
        }

        /* --- STYLING INPUT FIELDS --- */
        .auth-form input {
            width: 100%;
            padding: 13px;
            margin-bottom: 15px;
            background: rgba(30, 30, 30, 0.7);
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
            background: rgba(45, 45, 45, 0.85);
            box-shadow: 0 0 10px rgba(243, 156, 18, 0.25);
        }
        .auth-form input::placeholder {
            color: #7f8c8d;
        }

        /* --- AUTO-GENERATED READONLY FIELD OVERRIDE --- */
        .readonly-field {
            background-color: rgba(243, 156, 18, 0.05) !important;
            border: 1px dashed rgba(243, 156, 18, 0.4) !important;
            color: #f39c12 !important;
            font-weight: bold;
            cursor: not-allowed;
            letter-spacing: 1px;
        }

        /* Input Label */
        .input-label {
            display: block;
            text-align: left;
            font-size: 12px;
            color: #bdc3c7;
            margin-bottom: 6px;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        /* --- ANIMATED SUBMIT BUTTON --- */
        .auth-form button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #f39c12, #d35400);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(211, 84, 0, 0.2);
            margin-top: 5px;
        }
        .auth-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(243, 156, 18, 0.4);
            background: linear-gradient(135deg, #f1c40f, #f39c12);
        }

        /* --- BOTTOM NAVIGATION LINKS --- */
        .auth-links {
            margin-top: 25px;
            font-size: 14px;
            color: #bdc3c7;
        }
        .auth-links a {
            color: #f39c12;
            font-weight: bold;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        .auth-links a:hover {
            color: #f1c40f;
            text-decoration: underline;
        }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes formPopIn {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 991px) {
            body, html {
                overflow: auto;
                background-position: center center;
                background-image: linear-gradient(rgba(8, 8, 8, 0.9), rgba(8, 8, 8, 0.9)),
                                  url('https://images.unsplash.com/photo-1514516345957-556ca7d90a29?q=80&w=1200&auto=format&fit=crop');
            }
            .container { justify-content: center; padding: 60px 20px; height: auto; }
            .auth-container { margin: 40px 0; padding: 35px 25px; }
        }
    </style>
</head>
<body>

    <jsp:include page="includes/header.jsp" />

    <div class="container">

        <div class="auth-container">
            <h2>Create an Account</h2>
            <p>Join GrandEats to reserve your tables easily.</p>

            <form class="auth-form" action="RegisterServlet" method="POST">

                <label class="input-label"><i class="fa-solid fa-id-card" style="color: #f39c12; margin-right: 4px;"></i> Your User ID (Auto-Generated):</label>
                <input type="text" name="userId" value="<%= nextId %>" class="readonly-field" readonly>

                <input type="text" name="fullName" placeholder="Full Name" required>

                <input type="email" name="email" placeholder="Email Address" required>

                <input type="text"
                       name="phoneNumber"
                       placeholder="Phone Number (e.g. 0771234567)"
                       pattern="[0-9]{10}"
                       maxlength="10"
                       title="Please enter a valid 10-digit phone number"
                       required>

                <input type="password" name="password" placeholder="Password" required>

                <button type="submit">Sign Up</button>
            </form>

            <div class="auth-links">
                Already have an account? <a href="login.jsp">Login Here</a>
            </div>
        </div>

    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('error')) {
                const errorMsg = urlParams.get('error');
                let title = "Registration Failed!";
                let text = "Please try again.";

                if (errorMsg === 'email_exists') {
                    text = "This email is already registered. Please login to your account.";
                } else if (errorMsg === 'failed') {
                    text = "Something went wrong while creating your account. Please try again.";
                }

                Swal.fire({
                    icon: 'error',
                    title: title,
                    text: text,
                    confirmButtonColor: '#d35400',
                    background: '#1a1a1a',
                    color: '#ffffff'
                });
            }
        });
    </script>

</body>
</html>