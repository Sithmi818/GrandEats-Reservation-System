<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - GrandEats</title>
    <meta name="referrer" content="no-referrer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- PREMIUM SEAFOOD FULL-SCREEN HERO BACKGROUND --- */
        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: #050505;
            background-image: linear-gradient(to right, rgba(5, 5, 5, 1) 40%, rgba(5, 5, 5, 0.4) 70%, rgba(5, 5, 5, 0.1) 100%),
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
            height: calc(100% - 80px);
            display: flex;
            align-items: center;
            justify-content: flex-start;
        }

        /* --- PREMIUM GLASSMORPHIC AUTH CONTAINER --- */
        .auth-container {
            width: 100%;
            max-width: 400px;
            background: rgba(20, 20, 20, 0.65);
            padding: 45px 40px;
            border-radius: 15px;
            box-shadow: 0 25px 55px rgba(0,0,0,0.7);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-left: 4px solid #f39c12; /* Elegant Gold Line */
            text-align: center;
            animation: formPopIn 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .auth-container h2 {
            color: #f39c12;
            margin-top: 0;
            margin-bottom: 10px;
            font-weight: 400;
            letter-spacing: 1.5px;
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
        }
        .auth-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(243, 156, 18, 0.4);
            background: linear-gradient(135deg, #f1c40f, #f39c12);
        }

        /* --- FORGOT PASSWORD LINK --- */
        .forgot-link {
            text-align: right;
            margin-top: -8px;
            margin-bottom: 22px;
        }
        .forgot-link a {
            font-size: 13px;
            color: #bdc3c7;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        .forgot-link a:hover {
            color: #f39c12;
            text-decoration: underline;
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

        @keyframes formPopIn {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 991px) {
            body, html {
                overflow: auto;
                background-position: center center;
                background-image: linear-gradient(rgba(5, 5, 5, 0.88), rgba(5, 5, 5, 0.88)),
                                  url('https://images.unsplash.com/photo-1514516345957-556ca7d90a29?q=80&w=1200&auto=format&fit=crop');
            }
            .container { justify-content: center; padding: 60px 20px; height: auto; }
            .auth-container { margin: 40px 0; }
        }
    </style>
</head>
<body>

    <jsp:include page="includes/header.jsp" />

    <div class="container">

        <div class="auth-container">
            <h2>Welcome Back</h2>
            <p>Login to manage your reservations.</p>

            <form class="auth-form" action="LoginServlet" method="POST">
                <input type="email" name="email" placeholder="Email Address" required>
                <input type="password" name="password" placeholder="Password" required>

                <div class="forgot-link">
                    <a href="forgot_password.jsp">Forgot Password?</a>
                </div>

                <button type="submit">Login</button>
            </form>

            <div class="auth-links">
                Don't have an account? <a href="signup.jsp">Sign Up Here</a>
            </div>
        </div>

    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);

            // ======= 🟢 1. SIGNUP SUCCESS POP-UP =======
            if (urlParams.has('msg') && urlParams.get('msg') === 'registered') {
                Swal.fire({
                    icon: 'success',
                    title: 'Registration Successful!',
                    text: 'Your account has been created successfully. You can log in now.',
                    confirmButtonColor: '#f39c12',
                    background: '#141414',
                    color: '#ffffff'
                }).then(() => {
                    // Clean URL to avoid repeating alert on reload
                    window.history.replaceState(null, null, window.location.pathname);
                });
            }

            // ======= 🔴 2. INVALID LOGIN ERROR POP-UP =======
            <% if(request.getParameter("error") != null) { %>
                Swal.fire({
                    icon: 'error',
                    title: 'Login Failed!',
                    text: 'Invalid Email or Password. Please try again.',
                    confirmButtonColor: '#dc3545',
                    background: '#141414',
                    color: '#ffffff'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
            <% } %>
        });
    </script>
</body>
</html>