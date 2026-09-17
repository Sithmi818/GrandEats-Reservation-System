<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentURL = request.getRequestURI();
    String user = (String) session.getAttribute("userEmail");
%>
<style>
    /* Dashboard Global Styles */
    .dashboard-wrapper { display: flex; max-width: 1200px; margin: 30px auto; gap: 20px; padding: 0 20px; }
    .sidebar { width: 250px; background: white; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 20px 0; align-self: flex-start; }
    .sidebar-header { padding: 0 20px 20px 20px; border-bottom: 1px solid #eee; margin-bottom: 10px; }
    .sidebar-header h3 { margin: 0; color: #1a1a1a; font-size: 18px; }
    .sidebar-header p { margin: 5px 0 0 0; font-size: 12px; color: #777; word-break: break-all; }
    .nav-menu { display: flex; flex-direction: column; }
    .nav-menu a { padding: 15px 20px; color: #555; font-weight: 600; transition: 0.3s; border-left: 4px solid transparent; display: block; text-decoration: none;}
    .nav-menu a i { margin-right: 10px; width: 20px; text-align: center; }
    .nav-menu a:hover { background: #f8f9fa; color: #f39c12; }
    .nav-menu a.active { background: #fff8eb; color: #f39c12; border-left: 4px solid #f39c12; }
    .main-content { flex: 1; background: white; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); padding: 30px; min-height: 500px; animation: fadeIn 0.4s; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

    /* Forms & Tables Shared Styles */
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; font-weight: bold; margin-bottom: 5px; color: #333; font-size: 14px;}
    .form-group input, .form-group select { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; font-family: 'Poppins', sans-serif;}
    .btn-submit { background-color: #f39c12; color: white; border: none; padding: 12px 20px; font-weight: bold; border-radius: 5px; cursor: pointer; width: 100%; font-size: 16px; transition: 0.3s;}
    .btn-submit:hover { background-color: #d68910; transform: translateY(-2px); }
    .alert-success { background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 5px solid #28a745; font-weight: bold; }
    .profile-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px; }

    /* Tables */
    .table-custom { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 14px; }
    .table-custom th, .table-custom td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
    .table-custom th { background-color: #f8f9fa; color: #333; font-weight: 600; }
    .badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
    .badge-confirmed { background: #d4edda; color: #155724; }
    .btn-sm { padding: 6px 12px; font-size: 12px; border-radius: 4px; cursor: pointer; border: none; margin-right: 5px; color: white;}
    .btn-edit { background: #17a2b8; } .btn-danger { background: #dc3545; }
</style>

<div class="sidebar">
    <div class="sidebar-header">
        <h3>My Dashboard</h3>
        <p><%= user != null ? user : "" %></p>
    </div>
    <div class="nav-menu">
        <a href="dashboard.jsp" class="<%= currentURL.endsWith("dashboard.jsp") ? "active" : "" %>"><i class="fa-solid fa-house-user"></i> Overview</a>
        <a href="my_bookings.jsp" class="<%= currentURL.endsWith("my_bookings.jsp") ? "active" : "" %>"><i class="fa-solid fa-list-check"></i> My Bookings</a>
        <a href="book_table.jsp" class="<%= currentURL.endsWith("book_table.jsp") ? "active" : "" %>"><i class="fa-solid fa-calendar-plus"></i> Book a Table</a>

        <a href="menu.jsp" class="<%= currentURL.endsWith("menu.jsp") ? "active" : "" %>"><i class="fa-solid fa-burger"></i> Food Menu</a>

        <a href="profile.jsp" class="<%= currentURL.endsWith("profile.jsp") ? "active" : "" %>"><i class="fa-solid fa-user-gear"></i> My Profile</a>
    </div>
</div>