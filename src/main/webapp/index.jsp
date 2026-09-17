<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.MenuItem" %>
<%@ page import="com.reservation.service.MenuService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<html>
<head>
    <title>GrandEats - Ultimate Luxury Dining</title>
    <meta name="referrer" content="no-referrer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- LUXURY SCROLLBAR HIDE --- */
        html {
            scroll-behavior: smooth;
            height: 100%;
            overflow-y: scroll;
        }
        body {
            margin: 0;
            padding: 0;
            width: 100%;
            background-color: #060606;
            font-family: 'Poppins', sans-serif;
            color: #ffffff;
            overflow-x: hidden !important;
        }
        html {
            scrollbar-width: none;
            -ms-overflow-style: none;
        }
        html::-webkit-scrollbar, body::-webkit-scrollbar {
            display: none;
        }

        /* LUXURY PRELOADER SPLASH SCREEN */
        #preloader {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            background-color: #060606;
            z-index: 99999;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .preloader-wrap {
            text-align: center;
            clip-path: polygon(0 0, 100% 0, 100% 100%, 0 100%);
        }
        .preloader-logo {
            font-family: 'Georgia', serif;
            font-size: 3rem;
            font-weight: bold;
            color: #ffffff;
            letter-spacing: 2px;
            transform: translateY(100px);
        }

        /* Scroll Progress Line */
        .scroll-progress-bar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(to right, #f39c12, #d35400);
            z-index: 9999;
            transform: scaleX(0);
            transform-origin: left;
        }

        /* --- PREMIUM NAVIGATION --- */
        .fixed-header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 100;
            background: rgba(6, 6, 6, 0.85);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            opacity: 0; /* Animated by GSAP */
        }
        .fixed-header header {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 22px 40px;
            box-sizing: border-box;
        }
        .fixed-header .brand-logo {
            font-family: 'Georgia', serif;
            font-size: 28px;
            font-weight: bold;
            color: #ffffff;
            letter-spacing: 1px;
        }
        .fixed-header nav { display: flex; gap: 35px; }
        .fixed-header nav a {
            color: #bdc3c7;
            text-decoration: none;
            font-size: 17px;
            font-weight: 600;
            position: relative;
            transition: color 0.3s;
        }
        .fixed-header nav a::after {
            content: '';
            position: absolute;
            width: 100%;
            transform: scaleX(0);
            height: 1px;
            bottom: -4px;
            left: 0;
            background-color: #f39c12;
            transform-origin: bottom right;
            transition: transform 0.25s ease-out;
        }
        .fixed-header nav a:hover::after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }

        section {
            padding: 140px 20px 120px 20px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            box-sizing: border-box;
            position: relative;
        }

        /* =======================================================
           1. HERO HOME SECTION
           ======================================================= */
        #home {
            background-image: linear-gradient(to right, rgba(8, 8, 8, 1) 40%, rgba(8, 8, 8, 0.4) 70%, rgba(8, 8, 8, 0.1) 100%),
                              url('https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop');
            background-size: cover;
            background-position: right center;
        }
        .hero-container { width: 100%; max-width: 1200px; margin: 0 auto; padding: 0 40px; }
        .hero-left { max-width: 600px; }
        .reveal-wrapper { clip-path: polygon(0 0, 100% 0, 100% 100%, 0 100%); }
        .hero-left h1 {
            font-family: 'Georgia', serif; font-size: 4rem; line-height: 1.15; margin: 0 0 20px 0;
            transform: translateY(120px);
        }
        .hero-left p { font-size: 1.15rem; color: #bdc3c7; margin: 0 0 40px 0; line-height: 1.8; opacity: 0; }
        .btn-main {
            background: transparent; color: #ffffff; padding: 14px 35px; font-size: 13px; font-weight: bold;
            border-radius: 4px; text-decoration: none; text-transform: uppercase; letter-spacing: 2px;
            border: 1px solid rgba(255, 255, 255, 0.4); transition: 0.4s; display: inline-block; opacity: 0;
        }
        .btn-main:hover { transform: translateY(-3px); border-color: #f39c12; color: #f39c12; box-shadow: 0 10px 20px rgba(243, 156, 18, 0.1); }

        /* =======================================================
           2. MENU SECTION (WITH DYNAMIC FILTER BUTTONS)
           ======================================================= */
        #menu {
            background-image: linear-gradient(rgba(0, 0, 0, 0.94), rgba(0, 0, 0, 0.94)),
                              url('https://images.unsplash.com/photo-1541532713592-79a0317b6b77?q=80&w=1888&auto=format&fit=crop');
            background-size: cover; background-attachment: fixed;
        }
        .menu-wrapper { width: 100%; max-width: 1000px; margin: 0 auto; }
        .menu-main-title { text-align: center; font-family: 'Georgia', serif; font-size: 3rem; text-transform: uppercase; margin-bottom: 30px; }
        .menu-main-title::after { content: ''; display: block; width: 60px; height: 1px; background: rgba(255, 255, 255, 0.3); margin: 15px auto 0 auto; }

        /* Luxury Filter Buttons Grid */
        .filter-container {
            display: flex; justify-content: center; gap: 15px; margin-bottom: 60px; flex-wrap: wrap;
        }
        .filter-btn {
            background: transparent; border: 1px solid rgba(255,255,255,0.1); color: #bdc3c7;
            padding: 8px 22px; font-size: 12px; font-weight: bold; text-transform: uppercase;
            letter-spacing: 1.5px; border-radius: 30px; cursor: pointer; transition: all 0.4s ease;
        }
        .filter-btn.active, .filter-btn:hover {
            border-color: #f39c12; color: #f39c12; background: rgba(243, 156, 18, 0.03);
        }

        .menu-showcase-container { display: flex; flex-direction: column; gap: 100px; min-height: 400px; }
        .menu-item-row { display: flex; align-items: center; justify-content: space-between; gap: 50px; width: 100%; transition: transform 0.4s ease; }
        .menu-item-row:nth-child(even) { flex-direction: row-reverse; }
        .menu-image-zone { flex: 1; display: flex; justify-content: center; position: relative; }
        .menu-image-zone::before { content: ''; position: absolute; width: 130%; height: 130%; background-image: url('https://www.pngarts.com/files/7/Powder-Splash-PNG-Photo.png'); background-size: contain; background-repeat: no-repeat; background-position: center; opacity: 0.12; }

        .circular-plate { width: 300px; height: 300px; border-radius: 50% !important; object-fit: cover !important; box-shadow: 0 30px 60px rgba(0,0,0,0.9); border: 4px solid rgba(25, 25, 25, 0.8); transition: 0.6s; }
        .menu-item-row:hover .circular-plate { transform: scale(1.04) rotate(5deg); }
        .menu-text-zone { flex: 1; }
        .menu-item-row:nth-child(even) .menu-text-zone { text-align: right; }
        .menu-text-zone .category { font-size: 11px; text-transform: uppercase; color: #f39c12; letter-spacing: 2px; margin-bottom: 8px; display: block; }
        .menu-text-zone h3 { font-family: 'Georgia', serif; font-size: 1.8rem; margin: 0 0 12px 0; text-transform: uppercase; }
        .menu-text-zone p { color: #bdc3c7; font-size: 14px; line-height: 1.7; }
        .menu-text-zone .price { font-size: 18px; font-weight: bold; display: block; margin-bottom: 10px; }
        .status-tag { font-size: 11px; text-transform: uppercase; font-weight: bold; }
        .status-instock { color: #2ecc71; } .status-outstock { color: #e74c3c; }
        .menu-footer-tag { text-align: center; font-family: 'Georgia', serif; font-style: italic; font-size: 24px; color: rgba(255, 255, 255, 0.4); margin-top: 100px; }

        /* =======================================================
           3. ABOUT US SECTION STYLE
           ======================================================= */
        #about {
            background-image: linear-gradient(rgba(13, 13, 13, 0.92), rgba(13, 13, 13, 0.92)),
                              url('https://images.unsplash.com/photo-1541532713592-79a0317b6b77?q=80&w=1888&auto=format&fit=crop');
            background-size: cover; background-attachment: fixed;
        }
        .about-container { width: 100%; max-width: 1100px; margin: 0 auto; position: relative; }
        .about-section { display: flex; gap: 50px; align-items: center; background: rgba(25, 25, 25, 0.65); padding: 50px; border-radius: 20px; box-shadow: 0 25px 55px rgba(0,0,0,0.6); backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.05); }
        .about-text { flex: 1; }
        .about-text h2 { color: #f39c12; margin: 0 0 25px 0; font-size: 36px; font-family: 'Georgia', serif; text-transform: uppercase; }
        .about-text p { line-height: 1.8; color: #bdc3c7; font-size: 15px; }
        .about-img { flex: 1; }
        .about-img img { width: 100%; border-radius: 12px; box-shadow: 0 25px 50px rgba(0,0,0,0.8); transition: 0.6s; }

        .floating-star { position: absolute; font-size: 35px; color: #f39c12; opacity: 0.4; }
        .star-left { top: -30px; left: -20px; }
        .star-right { bottom: -20px; right: -20px; }

        /* =======================================================
           4. CONTACT US SECTION STYLE
           ======================================================= */
        #contact { background-color: #0b0b0b; }
        .contact-container { width: 100%; max-width: 1100px; margin: 0 auto; }
        .contact-wrapper { display: flex; gap: 40px; }
        .contact-info, .contact-form { background: rgba(25, 25, 25, 0.6); padding: 40px; border-radius: 15px; box-shadow: 0 25px 50px rgba(0,0,0,0.6); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.05); flex: 1; }
        .contact-info h3, .contact-form h3 { margin: 0; color: white; margin-bottom: 20px; font-weight: 400; }
        .info-item { display: flex; align-items: center; gap: 20px; margin-bottom: 25px; }
        .info-item i { font-size: 20px; color: #f39c12; background: rgba(243, 156, 18, 0.1); padding: 15px; border-radius: 50%; }

        /* Premium Input Fields Hover Effects */
        .contact-form input, .contact-form textarea {
            width: 100%; padding: 14px; margin-bottom: 18px; background: rgba(40, 40, 40, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 6px; color: white;
            transition: border-color 0.4s ease, box-shadow 0.4s ease;
        }
        .contact-form input:focus, .contact-form textarea:focus {
            outline: none; border-color: #f39c12; box-shadow: 0 0 10px rgba(243, 156, 18, 0.15);
        }
        .contact-form button { width: 100%; padding: 14px; background: linear-gradient(135deg, #f39c12, #d35400); color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; text-transform: uppercase; transition: 0.3s; }
        .contact-form button:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(243, 156, 18, 0.4); }

        /* 📱 RESPONSIVE */
        @media (max-width: 768px) {
            #menu, #about { background-attachment: scroll !important; }
            section { padding: 140px 15px 60px 15px !important; }
            .fixed-header header { padding: 12px 15px !important; flex-direction: column !important; gap: 10px !important; }
            .fixed-header .brand-logo { font-size: 26px !important; text-align: center; width: 100%; }
            .fixed-header nav { display: flex !important; justify-content: center !important; flex-wrap: wrap !important; gap: 15px !important; width: 100%; }
            .fixed-header nav a { font-size: 16px !important; }
            .contact-wrapper, .about-section { flex-direction: column !important; gap: 30px !important; padding: 25px !important; }
            .menu-item-row { flex-direction: column !important; text-align: center !important; gap: 25px !important; }
            .menu-item-row:nth-child(even) { flex-direction: column !important; }
            .menu-text-zone { text-align: center !important; }
            .circular-plate { width: 220px !important; height: 220px !important; }
            .hero-left h1 { font-size: 2.5rem !important; }
        }
    </style>
</head>
<body>

    <div id="preloader">
        <div class="preloader-wrap">
            <div class="preloader-logo">
                <i class="fa-solid fa-utensils" style="color: #f39c12; margin-right: 12px;"></i>GrandEats
            </div>
        </div>
    </div>

    <div class="scroll-progress-bar"></div>

    <div class="fixed-header">
        <header>
            <div class="brand-logo">
                <i class="fa-solid fa-utensils" style="color: #f39c12; margin-right: 8px;"></i>GrandEats
            </div>
            <nav>
                <a href="#home">Home</a>
                <a href="#menu">Menu</a>
                <a href="#about">About Us</a>
                <a href="#contact">Contact Us</a>
            </nav>
        </header>
    </div>

    <section id="home">
        <div class="hero-container">
            <div class="hero-left">
                <div class="reveal-wrapper">
                    <h1>A Premium<br>And Authentic<br>Dining Journey</h1>
                </div>
                <p>Experience an extraordinary luxury culinary journey with our curated signatures, where premium ingredients meet world-class hospitality.</p>
                <a href="signup.jsp" class="btn-main">Book A Table</a>
            </div>
        </div>
    </section>

    <section id="menu">
        <div class="menu-wrapper">
            <h1 class="menu-main-title">Menu</h1>

            <div class="filter-container">
                <button class="filter-btn active" onclick="filterMenu('all', this)">All</button>
                <%
                    MenuService ms = new MenuService();
                    List<MenuItem> items = ms.getAllMenuItems();

                    // Categorise filtering list dynamically using Java Set
                    Set<String> categories = new HashSet<>();
                    for(MenuItem m : items) {
                        categories.add(m.getCategory());
                    }
                    for(String category : categories) {
                %>
                    <button class="filter-btn" onclick="filterMenu('<%= category.toLowerCase().replaceAll(" ", "-") %>', this)"><%= category %></button>
                <% } %>
            </div>

            <div class="menu-showcase-container">
                <% for(MenuItem m : items) { %>
                    <div class="menu-item-row filter-item <%= m.getCategory().toLowerCase().replaceAll(" ", "-") %>">
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
    </section>

    <section id="about">
        <div class="about-container">
            <i class="fa-solid fa-star floating-star star-left"></i>
            <i class="fa-solid fa-star floating-star star-right"></i>
            <div class="about-section">
                <div class="about-text">
                    <h2>Our Story</h2>
                    <p>Founded in 2026, GrandEats started with a simple vision: to bridge the gap between extraordinary culinary art and seamless customer experience.</p>
                    <p> We understand that a great dining experience starts before you even enter the restaurant. That is why we built this state-of-the-art reservation platform.</p>
                    <p><strong><i class="fa-solid fa-bullseye"></i> Our Mission:</strong> To provide unparalleled dining experiences with zero waiting times.</p>
                </div>
                <div class="about-img">
                    <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=800&auto=format&fit=crop" alt="Restaurant Interior">
                </div>
            </div>
        </div>
    </section>

    <section id="contact">
        <div class="contact-container">
            <h1 class="page-title" style="text-align: center; font-family:'Georgia', serif; text-transform:uppercase; font-size:2.5rem; margin-bottom:50px;">Get In Touch</h1>
            <div class="contact-wrapper">
                <div class="contact-info">
                    <h3>Contact Information</h3>
                    <p style="color: #bdc3c7; font-size: 14px; margin-bottom: 35px;">Feel free to reach out to us for bulk reservations or special event inquiries.</p>
                    <div class="info-item">
                        <i class="fa-solid fa-location-dot"></i>
                        <div><strong>Address</strong><p style="margin:4px 0 0 0; color:#bdc3c7; font-size:14px;">No 123, Main Street, Colombo 03</p></div>
                    </div>
                    <div class="info-item">
                        <i class="fa-solid fa-phone"></i>
                        <div><strong>Phone</strong><p style="margin:4px 0 0 0; color:#bdc3c7; font-size:14px;">+94 11 234 5678</p></div>
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
                        <textarea name="message" rows="4" placeholder="Write your message here..." required></textarea>
                        <button type="submit"><i class="fa-solid fa-paper-plane"></i> Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <footer style="background: #050505; padding: 40px 20px; text-align: center; border-top: 1px solid rgba(255,255,255,0.05); width: 100%;">
        <div style="margin-bottom: 20px;">
            <a href="#home" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px;">Home</a>
            <a href="#menu" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px;">Menu</a>
            <a href="#about" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px;">About Us</a>
            <a href="#contact" style="color: #bdc3c7; margin: 0 15px; text-decoration: none; font-size: 14px;">Contact Us</a>
        </div>
        <p style="color: #666; font-size: 13px; margin: 0;">&copy; 2026 GrandEats. All Rights Reserved.</p>
    </footer>

    <script>
        gsap.registerPlugin(ScrollTrigger);

        // 1. SCROLL PROGRESS ACCENT LINE TRACKER
        gsap.to(".scroll-progress-bar", {
            scaleX: 1, ease: "none",
            scrollTrigger: { trigger: "body", start: "top top", end: "bottom bottom", scrub: true }
        });

        // 2. PRELOADER & TIMELINE SEQUENCING INTERFACES
        window.addEventListener("DOMContentLoaded", () => {
            const masterTimeline = gsap.timeline();

            // Splash preloader up animation tracking
            masterTimeline.to(".preloader-logo", {
                y: 0, duration: 1, ease: "power4.out"
            })
            .to("#preloader", {
                yPercent: -100, duration: 1, ease: "power4.inOut", delay: 0.5
            })
            // Fade-in navigation menu smooth entries
            .to(".fixed-header", {
                opacity: 1, duration: 0.5, ease: "power2.out"
            }, "-=0.2")
            // Text presentation reveal
            .to(".hero-left h1", {
                y: 0, duration: 1, ease: "power4.out"
            }, "-=0.4")
            .to(".hero-left p", {
                opacity: 1, y: 0, duration: 0.6, ease: "power3.out"
            }, "-=0.5")
            .to(".btn-main", {
                opacity: 1, duration: 0.5, ease: "power2.out"
            }, "-=0.4");
        });

        // 3. 👑 HIGH-END INTERACTIVE DYNAMIC FILTERING LOGIC
        function filterMenu(category, buttonElement) {
            // Adjust active layouts configuration
            document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
            buttonElement.classList.add('active');

            const items = document.querySelectorAll('.filter-item');

            // GSAP Animated Split Grid Scaling
            gsap.to(items, {
                opacity: 0, scale: 0.9, y: 20, duration: 0.3, ease: "power2.in",
                onComplete: () => {
                    items.forEach(item => {
                        if (category === 'all' || item.classList.contains(category)) {
                            item.style.display = 'flex';
                            gsap.to(item, { opacity: 1, scale: 1, y: 0, duration: 0.5, ease: "power3.out", delay: 0.1 });
                        } else {
                            item.style.display = 'none';
                        }
                    });
                    // Refresh ScrollTrigger parameters dynamically
                    ScrollTrigger.refresh();
                }
            });
        }

        // 4. SCROLL INTERSECTION TRIGGERS DEFINITIONS
        gsap.utils.toArray('.menu-item-row').forEach(row => {
            gsap.fromTo(row,
                { opacity: 0, y: 50 },
                {
                    opacity: 1, y: 0, duration: 0.8, ease: "power2.out",
                    scrollTrigger: { trigger: row, start: "top 85%", toggleActions: "play none none none" }
                }
            );
        });

        gsap.from(".about-section", {
            opacity: 0, y: 60, duration: 1, ease: "power2.out",
            scrollTrigger: { trigger: "#about", start: "top 75%" }
        });

        gsap.to(".star-left", { y: -30, scrollTrigger: { trigger: "#about", scrub: true } });
        gsap.to(".star-right", { y: 30, scrollTrigger: { trigger: "#about", scrub: true } });

        gsap.from(".contact-info, .contact-form", {
            opacity: 0, y: 40, stagger: 0.15, duration: 0.8, ease: "power2.out",
            scrollTrigger: { trigger: "#contact", start: "top 80%" }
        });

        // SweetAlert2 Engine Setup
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('success')) {
            Swal.fire({
                icon: 'success', title: 'Message Sent!', text: 'Thank you for contacting GrandEats!',
                confirmButtonColor: '#f39c12', background: '#1a1a1a', color: '#ffffff'
            });
        }
    </script>
</body>
</html>