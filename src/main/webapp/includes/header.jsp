<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 🌙 Dark Mode / Light Mode CSS Variables */
        :root {
            --bg-color: #f4f7f6;
            --text-main: #333333;
            --text-muted: #666666;
            --card-bg: #ffffff;
            --border-color: #eeeeee;
        }

        body.dark-mode {
            --bg-color: #121212;
            --text-main: #e0e0e0;
            --text-muted: #aaaaaa;
            --card-bg: #1e1e1e;
            --border-color: #333333;
        }

        /* Global Styles (Updated for Dark Mode) */
        body { font-family: 'Poppins', sans-serif; margin: 0; padding: 0; background-color: var(--bg-color); color: var(--text-main); transition: 0.3s; }
        a { text-decoration: none; }

        /* Navbar */
        .navbar { background-color: #1a1a1a; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 1000; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .nav-brand { color: #f39c12; font-size: 24px; font-weight: 600; transition: 0.3s; }
        .nav-brand:hover { transform: scale(1.05); }
        .nav-links { display: flex; gap: 20px; }
        .nav-links a { color: #fff; font-weight: 400; padding: 10px 15px; border-radius: 5px; transition: all 0.3s ease; }
        .nav-links a:hover { background-color: #f39c12; color: #1a1a1a; transform: translateY(-2px); }

        /* Updated Nav Right (Login, Sign Up & Dashboard) */
        .nav-right { display: flex; gap: 15px; align-items: center; }
        .btn-login { color: #fff; font-weight: 600; padding: 10px 20px; transition: 0.3s; }
        .btn-login:hover { color: #f39c12; transform: translateY(-2px); }
        .btn-signup { background-color: #28a745; color: white; padding: 10px 20px; border-radius: 25px; font-weight: 600; transition: 0.3s; }
        .btn-signup:hover { background-color: #218838; transform: scale(1.05); box-shadow: 0 4px 10px rgba(40,167,69,0.4); }
        .btn-logout { background-color: #dc3545; color: white; padding: 10px 20px; border-radius: 25px; font-weight: 600; transition: 0.3s; }
        .btn-logout:hover { background-color: #c82333; transform: scale(1.05); }

        /* Theme Toggle Button */
        .theme-toggle { background: transparent; border: none; color: #fff; font-size: 20px; cursor: pointer; transition: 0.3s; margin-right: 10px; }
        .theme-toggle:hover { color: #f39c12; transform: scale(1.1); }

        /* Animations */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-up { animation: fadeInUp 0.8s ease-out forwards; opacity: 0; }
        .delay-1 { animation-delay: 0.2s; }
        .delay-2 { animation-delay: 0.4s; }

        /* Common Container */
        .container { max-width: 1100px; margin: 50px auto; padding: 0 20px; }

        /* Dark Mode overrides for Dashboard elements */
        body.dark-mode .main-content, body.dark-mode .sidebar, body.dark-mode .msg-card,
        body.dark-mode .menu-card, body.dark-mode .food-section, body.dark-mode .form-container,
        body.dark-mode .table-container {
            background-color: var(--card-bg) !important;
            border-color: var(--border-color) !important;
            color: var(--text-main) !important;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2) !important;
        }
        body.dark-mode label, body.dark-mode h2, body.dark-mode h3, body.dark-mode h4,
        body.dark-mode p, body.dark-mode td, body.dark-mode strong, body.dark-mode .food-item { color: var(--text-main) !important; }
        body.dark-mode .sidebar-header p, body.dark-mode .page-header p, body.dark-mode .nav-menu a { color: var(--text-muted) !important; }
        body.dark-mode .table-custom th { background-color: var(--border-color) !important; color: var(--text-main) !important; }
        body.dark-mode .table-custom td, body.dark-mode .sidebar-header, body.dark-mode .page-header { border-bottom: 1px solid var(--border-color) !important; }
        body.dark-mode .form-control { background-color: var(--bg-color) !important; color: var(--text-main) !important; border: 1px solid var(--border-color) !important;}
        body.dark-mode .nav-menu a:hover, body.dark-mode .nav-menu a.active { background-color: var(--border-color) !important; color: #f39c12 !important; }
        body.dark-mode .empty-state h3 { color: var(--text-main) !important; }
    </style>
</head>

<div class="navbar">
    <a href="index.jsp" class="nav-brand"><i class="fa-solid fa-utensils"></i> GrandEats</a>

    <% if(session.getAttribute("userEmail") == null) { %>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="menu.jsp">Menu</a>
            <a href="about.jsp">About Us</a>
            <a href="contact.jsp">Contact Us</a>
        </div>
    <% } %>

    <div class="nav-right">
        <button class="theme-toggle" onclick="toggleTheme()" title="Switch Theme">
            <i id="theme-icon" class="fa-solid fa-moon"></i>
        </button>

        <% if(session.getAttribute("userEmail") != null) { %>
            <a href="dashboard.jsp" class="btn-login"><i class="fa-solid fa-chart-line"></i> Dashboard</a>
            <a href="LogoutServlet" class="btn-logout"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
        <% } else { %>
            <a href="login.jsp" class="btn-login"><i class="fa-solid fa-right-to-bracket"></i> Login</a>
            <a href="signup.jsp" class="btn-signup"><i class="fa-solid fa-user-plus"></i> Sign Up</a>
        <% } %>
    </div>
</div>

<script>
    // Load saved theme from localStorage
    document.addEventListener("DOMContentLoaded", function() {
        if(localStorage.getItem('theme') === 'dark') {
            document.body.classList.add('dark-mode');
        }
        updateThemeIcon();
    });

    // Toggle Theme
    function toggleTheme() {
        document.body.classList.toggle('dark-mode');
        let theme = document.body.classList.contains('dark-mode') ? 'dark' : 'light';
        localStorage.setItem('theme', theme);
        updateThemeIcon();
    }

    // Update the Moon/Sun icon
    function updateThemeIcon() {
        const icon = document.getElementById('theme-icon');
        if (document.body.classList.contains('dark-mode')) {
            icon.className = 'fa-solid fa-sun';
            icon.style.color = '#f39c12';
        } else {
            icon.className = 'fa-solid fa-moon';
            icon.style.color = '#ffffff';
        }
    }
</script>