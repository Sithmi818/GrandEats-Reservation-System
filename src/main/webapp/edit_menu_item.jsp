<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.MenuItem" %>
<%@ page import="com.reservation.service.MenuService" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) { response.sendRedirect("login.jsp"); return; }

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        response.sendRedirect("admin_menu.jsp");
        return;
    }

    int itemId = Integer.parseInt(idParam);
    MenuService ms = new MenuService();

    MenuItem item = ms.getMenuItemById(itemId);

    if (item == null) {
        response.sendRedirect("admin_menu.jsp");
        return;
    }
%>
<html>
<head>
    <title>Edit Menu Item - Admin</title>
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
        .admin-container {
            position: relative;
            max-width: 1000px;
            margin: 0 auto;
        }

        /* --- GLOWING FLOATING STARS ANIMATION (NO IMAGES - 100% RELIABLE!) --- */
        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12; /* Golden Sparkle */
            opacity: 0.5;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.7); /* Luxury Neon Glow */
        }

        .star-left {
            top: 40px;
            left: 20px;
            animation: floatingEffect 5s ease-in-out infinite alternate;
        }

        .star-right {
            bottom: -20px;
            right: 20px;
            animation: floatingEffect 7s ease-in-out infinite alternate-reverse;
        }

        /* --- HEADERS WITH SHARP INTEGRATION --- */
        .admin-header {
            background: rgba(15, 15, 15, 0.85);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        .admin-header h2 { margin: 0; color: #f39c12; font-weight: 400; letter-spacing: 1px; }
        .admin-header a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            background: #dc3545;
            padding: 8px 18px;
            border-radius: 6px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        .admin-header a:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(220, 53, 69, 0.5); }

        /* --- CONTENT LAYER WITH POP-IN ANIMATION --- */
        .admin-content {
            padding: 40px;
            max-width: 600px;
            margin: 0 auto;
            position: relative;
            z-index: 5;
            animation: formPopIn 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .back-btn {
            text-decoration: none;
            color: #bdc3c7;
            font-weight: bold;
            transition: color 0.3s ease;
        }
        .back-btn:hover { color: #f39c12; }

        /* --- GLASSMORPHIC FORM CONTAINER --- */
        .form-container {
            background: rgba(25, 25, 25, 0.65);
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: box-shadow 0.5s ease, transform 0.5s ease;
            margin-top: 15px;
        }
        .form-container:focus-within {
            transform: translateY(-2px);
            box-shadow: 0 30px 60px rgba(243, 156, 18, 0.1);
            border: 1px solid rgba(243, 156, 18, 0.2);
        }

        .form-group { margin-bottom: 22px; }
        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #f39c12; /* Golden Labels */
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        /* --- STYLING INPUT FIELDS & DROPDOWNS --- */
        .form-control {
            width: 100%;
            padding: 12px;
            background: rgba(40, 40, 40, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 6px;
            box-sizing: border-box;
            color: white;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            outline: none;
            background: rgba(50, 50, 50, 0.8);
            border-color: #f39c12;
            box-shadow: 0 0 8px rgba(243, 156, 18, 0.2);
        }
        /* Dropdown Options Dark background fix */
        .form-control option {
            background-color: #1a1a1a;
            color: white;
        }

        /* --- ANIMATED SUBMIT BUTTON --- */
        .btn-submit {
            background: linear-gradient(135deg, #f39c12, #d35400);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            width: 100%;
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

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes formPopIn {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes floatingEffect {
            0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; }
            100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; }
        }

        @media (max-width: 768px) {
            .floating-star { display: none; }
        }
    </style>
</head>
<body>
    <div class="admin-header">
        <h2><i class="fa-solid fa-utensils"></i> GrandEats Admin Portal</h2>
        <div>
            <span style="margin-right: 20px; color: #bdc3c7;"><i class="fa-solid fa-user-shield" style="color: #f39c12;"></i> Manager</span>
            <a href="LogoutServlet">Logout</a>
        </div>
    </div>

    <div class="admin-container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="admin-content">
            <a href="admin_menu.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Menu</a>
            <h2 style="color: #ffffff; margin-top: 25px; font-weight: 400; letter-spacing: 1px;">
                <i class="fa-solid fa-pen-to-square" style="color: #f39c12;"></i> Edit Menu Item
            </h2>

            <div class="form-container">
                <form action="UpdateMenuItemServlet" method="POST">

                    <input type="hidden" name="id" value="<%= item.getId() %>">

                    <div class="form-group">
                        <label>Item Name</label>
                        <input type="text" name="name" class="form-control" value="<%= item.getName() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Category</label>
                        <select name="category" class="form-control">
                            <option value="Main Course" <%= item.getCategory().equals("Main Course") ? "selected" : "" %>>Main Course</option>
                            <option value="Appetizers" <%= item.getCategory().equals("Appetizers") ? "selected" : "" %>>Appetizers</option>
                            <option value="Desserts" <%= item.getCategory().equals("Desserts") ? "selected" : "" %>>Desserts</option>
                            <option value="Beverages" <%= item.getCategory().equals("Beverages") ? "selected" : "" %>>Beverages</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Price (Rs.)</label>
                        <input type="text" name="price" class="form-control" value="<%= item.getPrice() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select name="status" class="form-control">
                            <option value="Available" <%= item.getStatus().equals("Available") ? "selected" : "" %>>Available</option>
                            <option value="Out of Stock" <%= item.getStatus().equals("Out of Stock") ? "selected" : "" %>>Out of Stock</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Image URL</label>
                        <input type="text" name="imageUrl" class="form-control" value="<%= item.getImageUrl() %>" required>
                    </div>
                    <button type="submit" class="btn-submit">Save Changes</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>