<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.MenuItem" %>
<%@ page import="com.reservation.service.MenuService" %>
<%@ page import="java.util.List" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) { response.sendRedirect("login.jsp"); return; }
%>
<html>
<head>
    <title>Menu Management - Admin</title>
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
        .admin-container { position: relative; max-width: 1300px; margin: 0 auto; }

        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12;
            opacity: 0.5;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.6);
        }
        .star-left { top: 120px; left: 15px; animation: floatingEffect 5s ease-in-out infinite alternate; }
        .star-right { bottom: 20px; right: 15px; animation: floatingEffect 7s ease-in-out infinite alternate-reverse; }

        /* --- HEADER & NAVIGATION --- */
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
        .admin-header h2 { margin: 0; color: #f39c12; font-weight: 400; }
        .admin-header a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            background: #dc3545;
            padding: 8px 15px;
            border-radius: 5px;
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.2);
        }
        .admin-header a:hover { background: #c82333; transform: translateY(-2px); }

        .sub-nav {
            background: rgba(25, 25, 25, 0.65);
            padding: 15px 40px;
            display: flex;
            gap: 25px;
            backdrop-filter: blur(5px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .admin-content { padding: 40px; position: relative; z-index: 5; animation: fadeIn 1s ease-out; }

        /* --- ANIMATED ADD BUTTON --- */
        .btn-add {
            background: linear-gradient(135deg, #28a745, #1e7e34);
            color: white;
            padding: 12px 22px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            float: right;
            text-decoration: none;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
            transition: all 0.3s ease;
        }
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.5);
            background: linear-gradient(135deg, #2ecc71, #28a745);
        }

        /* --- GLASSMORPHIC TABLE STYLING --- */
        .table-container {
            background: rgba(25, 25, 25, 0.55);
            border-radius: 15px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.6);
            backdrop-filter: blur(12px);
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            margin-top: 30px;
            clear: both;
        }
        .table-custom { width: 100%; border-collapse: collapse; text-align: left; color: #ecf0f1; }
        .table-custom th { background-color: rgba(40, 40, 40, 0.6); color: #f39c12; padding: 18px 20px; font-weight: 500; text-transform: uppercase; font-size: 13px; border-bottom: 2px solid rgba(255,255,255,0.05); }
        .table-custom td { padding: 18px 20px; border-bottom: 1px solid rgba(255,255,255,0.05); color: #e2e8f0; font-size: 14px; vertical-align: middle; }
        .table-custom tr:hover td { background-color: rgba(255, 255, 255, 0.03); }

        /* Image Glow & Hover zoom Effect */
        .menu-item-img {
            border-radius: 8px;
            object-fit: cover;
            border: 1px solid rgba(255,255,255,0.1);
            box-shadow: 0 4px 10px rgba(0,0,0,0.5);
            transition: transform 0.3s ease;
        }
        .table-custom tr:hover .menu-item-img {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(243, 156, 18, 0.3);
        }

        /* Action Buttons */
        .action-buttons { display: flex; gap: 10px; }
        .btn-edit { background: #f39c12; text-decoration: none; padding: 8px 14px; color:white; border-radius:6px; font-weight: bold; transition: all 0.3s; box-shadow: 0 4px 10px rgba(243, 156, 18, 0.2); }
        .btn-edit:hover { background: #f39c12; color: black; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(243, 156, 18, 0.4); }
        .btn-delete { background: #dc3545; text-decoration: none; padding: 8px 14px; color:white; border-radius:6px; font-weight: bold; transition: all 0.3s; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.2); }
        .btn-delete:hover { background: #ff4757; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(220, 53, 69, 0.4); }

        /* =======================================================
           KEYFRAMES DEFINITIONS
           ======================================================= */
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes floatingEffect { 0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; } 100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; } }
    </style>
</head>
<body>
    <div class="admin-header">
        <h2><i class="fa-solid fa-utensils"></i> GrandEats Admin Portal</h2>
        <div>
            <span style="margin-right: 20px; color: #bdc3c7;"><i class="fa-solid fa-user-shield" style="color: #f39c12;"></i> Welcome, Manager</span>
            <a href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </div>

    <div class="sub-nav">
        <a href="admin_dashboard.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-house"></i> Dashboard</a>
        <a href="admin_users.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-users"></i> User Management</a>
        <a href="admin_menu.jsp" style="color: #f39c12; text-decoration: none; font-weight: bold;"><i class="fa-solid fa-burger"></i> Menu</a>
        <a href="admin_messages.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-envelope"></i> Messages</a>
        <a href="admin_reports.jsp" style="color: #ddd; text-decoration: none; font-weight: bold; transition: color 0.3s;"><i class="fa-solid fa-chart-pie"></i> Reports</a>
    </div>

    <div class="admin-container">
        <i class="fa-solid fa-sparkles floating-star star-left"></i>
        <i class="fa-solid fa-star floating-star star-right"></i>

        <div class="admin-content">
            <a href="add_menu_item.jsp" class="btn-add"><i class="fa-solid fa-plus"></i> Add New Item</a>

            <h2 style="margin-top: 0; color: #ffffff; font-weight: 400; letter-spacing: 1px;"><i class="fa-solid fa-burger" style="color: #f39c12;"></i> Restaurant Menu</h2>
            <p style="color: #bdc3c7; margin-bottom: 25px;">Manage your food and beverage offerings here.</p>

            <% if(request.getParameter("msg") != null) {
                if(request.getParameter("msg").equals("item_added")) { %>
                    <div style="background: rgba(40, 167, 69, 0.15); color: #99ffb3; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold; border-left: 5px solid #28a745; border-top: 1px solid rgba(40,167,69,0.2); border-right: 1px solid rgba(40,167,69,0.2); border-bottom: 1px solid rgba(40,167,69,0.2);">
                        <i class="fa-solid fa-circle-check"></i> New Menu Item added successfully!
                    </div>
            <%  } else if(request.getParameter("msg").equals("item_updated")) { %>
                    <div style="background: rgba(0, 123, 255, 0.15); color: #99ccff; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold; border-left: 5px solid #007bff; border-top: 1px solid rgba(0,123,255,0.2); border-right: 1px solid rgba(0,123,255,0.2); border-bottom: 1px solid rgba(0,123,255,0.2);">
                        <i class="fa-solid fa-pen-to-square"></i> Menu Item updated successfully!
                    </div>
            <%  } else if(request.getParameter("msg").equals("item_deleted")) { %>
                    <div style="background: rgba(220, 53, 69, 0.15); color: #ffb3b3; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold; border-left: 5px solid #dc3545; border-top: 1px solid rgba(220,53,69,0.2); border-right: 1px solid rgba(220,53,69,0.2); border-bottom: 1px solid rgba(220,53,69,0.2);">
                        <i class="fa-solid fa-trash-can"></i> Menu Item deleted successfully!
                    </div>
            <%  }
            } %>

            <div class="table-container">
                <table class="table-custom">
                    <thead><tr><th>Item Image</th><th>Item Name</th><th>Category</th><th>Price (Rs.)</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <%
                            MenuService ms = new MenuService();
                            List<MenuItem> menuItems = ms.getAllMenuItems();

                            if(menuItems.isEmpty()) {
                        %>
                            <tr><td colspan="6" style="text-align: center; padding: 40px; color: #bdc3c7;">No menu items found. Please add a new item.</td></tr>
                        <%  } else {
                                for(MenuItem m : menuItems) {
                        %>
                            <tr>
                                <td><img src="<%= m.getImageUrl() %>" width="40" height="40" class="menu-item-img"></td>
                                <td><strong><%= m.getName() %></strong></td>
                                <td><%= m.getCategory() %></td>
                                <td>Rs. <%= m.getPrice() %></td>
                                <td>
                                    <% if("Available".equals(m.getStatus())) { %>
                                        <span style="color: #2ed573; font-weight: bold;"><i class="fa-solid fa-check-circle"></i> Available</span>
                                    <% } else { %>
                                        <span style="color: #ff4757; font-weight: bold;"><i class="fa-solid fa-times-circle"></i> Out of Stock</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="edit_menu_item.jsp?id=<%= m.getId() %>" class="btn-edit">
                                            <i class="fa-solid fa-pen-to-square"></i> Edit
                                        </a>

                                        <a href="DeleteMenuItemServlet?id=<%= m.getId() %>" onclick="return confirm('Are you sure you want to delete this item?');" class="btn-delete">
                                            <i class="fa-solid fa-trash"></i> Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%      }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>