<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Contact Us - GrandEats</title>
    <meta name="referrer" content="no-referrer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- PREMIUM APPLE-STYLE SMOOTH SCROLL OVERRIDE --- */
        html {
            scroll-behavior: smooth;
        }

        /* --- PREMIUM LUXURY DARK WOOD TEXTURE BACKGROUND --- */
        body {
            margin: 0;
            padding: 0;
            background-color: #0d0d0d;
            background-image: linear-gradient(rgba(0, 0, 0, 0.88), rgba(0, 0, 0, 0.88)),
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

        .container {
            max-width: 1100px;
            margin: 60px auto;
            padding: 0 20px;
            position: relative;
            min-height: calc(100vh - 280px);
        }

        /* --- GLOWING FLOATING STARS ANIMATION (100% RELIABLE) --- */
        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12;
            opacity: 0.4;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.6);
        }
        .star-left { top: -20px; left: -20px; animation: floatingEffect 5s ease-in-out infinite alternate; }
        .star-right { bottom: -20px; right: -20px; animation: floatingEffect 7s ease-in-out infinite alternate-reverse; }

        .page-title {
            text-align: center;
            margin-bottom: 40px;
            font-weight: 300;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: #ffffff;
        }
        .page-title::after {
            content: '';
            display: block;
            width: 80px;
            height: 1px;
            background: rgba(243, 156, 18, 0.4);
            margin: 12px auto 0 auto;
        }

        .contact-wrapper {
            display: flex;
            gap: 40px;
            position: relative;
            z-index: 5;
            animation: containerPopIn 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        /* --- GLASSMORPHIC CARDS TEMPLATE --- */
        .contact-info, .contact-form {
            background: rgba(25, 25, 25, 0.6);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            flex: 1;
            transition: box-shadow 0.4s ease;
        }
        .contact-form:focus-within {
            box-shadow: 0 30px 60px rgba(243, 156, 18, 0.1);
        }

        .contact-info h3, .contact-form h3 {
            margin-top: 0;
            font-weight: 400;
            color: #ffffff;
            letter-spacing: 1px;
            margin-bottom: 15px;
        }

        /* --- INFO ITEMS STYLING --- */
        .info-item { display: flex; align-items: center; gap: 20px; margin-bottom: 25px; }
        .info-item i {
            font-size: 22px;
            color: #f39c12;
            background: rgba(243, 156, 18, 0.1);
            padding: 16px;
            border-radius: 50%;
            border: 1px solid rgba(243, 156, 18, 0.2);
            text-shadow: 0 0 10px rgba(243, 156, 18, 0.3);
        }
        .info-item strong { color: #f39c12; font-size: 15px; letter-spacing: 0.5px; text-transform: uppercase; }

        /* --- FORM FIELDS STYLING --- */
        .contact-form input, .contact-form textarea {
            width: 100%;
            padding: 14px;
            margin-bottom: 18px;
            background: rgba(40, 40, 40, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 6px;
            color: white;
            font-family: 'Poppins', sans-serif;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }
        .contact-form input:focus, .contact-form textarea:focus {
            border-color: #f39c12;
            outline: none;
            background: rgba(50, 50, 50, 0.8);
            box-shadow: 0 0 8px rgba(243, 156, 18, 0.2);
        }

        /* Dark theme styling for locked fields when logged-in */
        .contact-form input[readonly] {
            background-color: rgba(20, 20, 20, 0.5) !important;
            border-color: rgba(255, 255, 255, 0.05) !important;
            color: #7f8c8d !important;
            box-shadow: none !important;
        }

        /* --- ANIMATED SUBMIT BUTTON --- */
        .contact-form button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #f39c12, #d35400);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: all 0.3s ease;
            font-weight: bold;
            box-shadow: 0 5px 15px rgba(243, 156, 18, 0.2);
        }
        .contact-form button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(243, 156, 18, 0.4);
            background: linear-gradient(135deg, #f1c40f, #f39c12);
        }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ====================================================== */
        @keyframes containerPopIn {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes floatingEffect {
            0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; }
            100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; }
        }

        @media (max-width: 768px) {
            .contact-wrapper { flex-direction: column; gap: 25px; }
            .floating-star { display: none; }
        }
    </style>
</head>
<body>

    <jsp:include page="includes/header.jsp" />

    <div class="container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <h1 class="page-title">Get In Touch</h1>

        <div class="contact-wrapper">
            <div class="contact-info">
                <h3>Contact Information</h3>
                <p style="color: #bdc3c7; line-height: 1.6; font-size: 14px; margin-bottom: 35px;">Feel free to reach out to us for bulk reservations or special event inquiries.</p>

                <div class="info-item">
                    <i class="fa-solid fa-location-dot"></i>
                    <div>
                        <strong>Address</strong>
                        <p style="margin: 4px 0 0 0; color: #bdc3c7; font-size: 14px;">No 123, Main Street, Colombo 03</p>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fa-solid fa-phone"></i>
                    <div>
                        <strong>Phone</strong>
                        <p style="margin: 4px 0 0 0; color: #bdc3c7; font-size: 14px;">+94 11 234 5678</p>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fa-solid fa-envelope"></i>
                    <div>
                        <strong>Email</strong>
                        <p style="margin: 4px 0 0 0; color: #bdc3c7; font-size: 14px;">reservations@grandeats.com</p>
                    </div>
                </div>
            </div>

            <div class="contact-form">
                <h3>Send a Message</h3>

                <%
                    String sName = session.getAttribute("userName") != null ? (String) session.getAttribute("userName") : "";
                    String sEmail = session.getAttribute("userEmail") != null ? (String) session.getAttribute("userEmail") : "";
                    String readOnlyAttr = !sName.isEmpty() ? "readonly style='cursor: not-allowed;'" : "";
                %>

                <form action="SubmitMessageServlet" method="POST">
                    <input type="text" name="name" placeholder="Your Full Name" value="<%= sName %>" <%= readOnlyAttr %> required>
                    <input type="email" name="email" placeholder="Your Email Address" value="<%= sEmail %>" <%= readOnlyAttr %> required>

                    <input type="text" name="subject" placeholder="Subject">
                    <textarea name="message" rows="5" placeholder="Write your message here..." required></textarea>

                    <button type="submit"><i class="fa-solid fa-paper-plane"></i> Send Message</button>
                </form>
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

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);

            if (urlParams.has('success')) {
                Swal.fire({
                    icon: 'success',
                    title: 'Message Sent!',
                    text: 'Thank you for contacting GrandEats. We will get back to you soon!',
                    confirmButtonColor: '#f39c12',
                    background: '#1a1a1a',
                    color: '#ffffff'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
            }
            else if (urlParams.has('error')) {
                Swal.fire({
                    icon: 'error',
                    title: 'Oops...',
                    text: 'Something went wrong. Please try again later.',
                    confirmButtonColor: '#dc3545',
                    background: '#1a1a1a',
                    color: '#ffffff'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
            }
        });
    </script>
</body>
</html>