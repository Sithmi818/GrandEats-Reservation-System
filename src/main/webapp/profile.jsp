<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.reservation.model.User" %>
<%@ page import="com.reservation.service.UserService" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if(userEmail == null) { response.sendRedirect("login.jsp"); return; }

    UserService userService = new UserService();
    User currentUser = userService.getUserByEmail(userEmail);
%>
<html>
<head>
    <title>My Profile - GrandEats</title>
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

        /* --- FORCE OVERRIDE OLD WHITE WRAPPERS TO PREMIUM GLASS --- */
        .dashboard-wrapper {
            display: flex;
            gap: 25px;
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 5;
        }

        .dashboard-wrapper .sidebar,
        .dashboard-wrapper aside,
        div[class*="sidebar"] {
            background: rgba(20, 20, 20, 0.75) !important;
            backdrop-filter: blur(20px) !important;
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            border-radius: 15px !important;
            color: white !important;
            box-shadow: 0 25px 60px rgba(0,0,0,0.6) !important;
            padding: 25px 15px !important;
        }

        .main-content {
            flex: 1;
            padding: 40px !important;
            background: rgba(20, 20, 20, 0.4) !important;
            backdrop-filter: blur(10px) !important;
            border-radius: 15px !important;
            border: 1px solid rgba(255, 255, 255, 0.03) !important;
            box-shadow: 0 20px 50px rgba(0,0,0,0.6) !important;
            animation: fadeIn 1s ease-out;
        }

        /* --- CONTAINER FOR FLOATING DECORATIONS --- */
        .profile-wrapper-container { position: relative; width: 100%; }

        .floating-star {
            position: absolute;
            font-size: 35px;
            color: #f39c12;
            opacity: 0.5;
            pointer-events: none;
            z-index: 1;
            text-shadow: 0 0 15px rgba(243, 156, 18, 0.6);
        }
        .star-left { top: 40px; left: -10px; animation: floatingEffect 5s ease-in-out infinite alternate; }
        .star-right { bottom: 20px; right: -10px; animation: floatingEffect 7s ease-in-out infinite alternate-reverse; }

        .page-header { margin-bottom: 25px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); padding-bottom: 15px; }
        .page-header h2 { margin: 0; color: #ffffff; font-weight: 400; display: flex; align-items: center; gap: 10px; }
        .page-header p { color: #bdc3c7; margin-top: 5px; }

        .profile-container { display: flex; gap: 25px; align-items: flex-start; flex-wrap: wrap; margin-top: 25px; }

        /* --- LEFT SIDE: AVATAR CARD --- */
        .avatar-card {
            flex: 1;
            min-width: 260px;
            background: rgba(25, 25, 25, 0.65) !important;
            padding: 40px 20px;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5) !important;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
            text-align: center;
        }

        .avatar-circle {
            width: 100px;
            height: 100px;
            background: rgba(40, 40, 40, 0.6);
            border: 2px dashed #f39c12;
            border-radius: 50%;
            margin: 0 auto 20px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: #f39c12;
        }
        .avatar-card h3 { margin: 0 0 6px 0; color: #ffffff; font-weight: 400; font-size: 20px; }
        .avatar-card p { margin: 0 0 20px 0; color: #bdc3c7; font-size: 14px; }
        .badge-member { display: inline-block; padding: 6px 18px; background: rgba(0,0,0,0.4); border: 1px solid #f39c12; color: #f39c12; border-radius: 20px; font-size: 11px; font-weight: bold; letter-spacing: 1px; }

        /* --- RIGHT SIDE: FORMS CARD --- */
        .form-card {
            flex: 2.5;
            min-width: 320px;
            background: rgba(25, 25, 25, 0.6) !important;
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5) !important;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.05) !important;
        }

        .section-title {
            font-size: 16px;
            color: #f39c12;
            margin-top: 0;
            margin-bottom: 25px;
            border-bottom: 1px dashed rgba(255, 255, 255, 0.1);
            padding-bottom: 12px;
            font-weight: 400;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 22px; }
        .form-group label { display: block; font-weight: 500; color: #bdc3c7; margin-bottom: 8px; font-size: 13px; }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.1) !important;
            border-radius: 6px !important;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            box-sizing: border-box;
            background: rgba(40, 40, 40, 0.6) !important;
            color: #ffffff !important;
        }
        .form-control:focus { border-color: #f39c12 !important; outline: none; background: rgba(50, 50, 50, 0.85) !important; }
        .readonly-input { background-color: rgba(20, 20, 20, 0.5) !important; color: #7f8c8d !important; cursor: not-allowed; border-style: dashed !important; }

        .btn-action { padding: 12px 25px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 8px; font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }
        .btn-update { background: linear-gradient(135deg, #2ecc71, #27ae60) !important; color: white !important; }
        .btn-security { background: linear-gradient(135deg, #f39c12, #d35400) !important; color: white !important; }

        .alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 25px; font-weight: 500; font-size: 14px; display: flex; align-items: center; gap: 10px; border: 1px solid transparent; backdrop-filter: blur(10px); }
        .alert-success { background: rgba(40, 167, 69, 0.08); color: #85ff9e; border-color: rgba(40, 167, 6 green, 0.2); border-left: 4px solid #28a745; }
        .alert-warning { background: rgba(243, 156, 18, 0.08); color: #ffcc66; border-color: rgba(243, 156, 18, 0.2); border-left: 4px solid #ffc107; }
        .alert-danger { background: rgba(220, 53, 69, 0.08); color: #ff9999; border-color: rgba(220, 53, 69, 0.2); border-left: 4px solid #dc3545; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes floatingEffect { 0% { transform: translateY(0) rotate(0deg) scale(1); opacity: 0.4; } 100% { transform: translateY(-20px) rotate(35deg) scale(1.1); opacity: 0.8; } }

        @media (max-width: 768px) {
            .profile-container { flex-direction: column; align-items: stretch; }
            .form-row { grid-template-columns: 1fr; gap: 15px; }
            .floating-star { display: none; }
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    <div class="dashboard-wrapper">
        <jsp:include page="includes/sidebar.jsp" />

        <div class="profile-wrapper-container">
            <i class="fa-solid fa-sparkles floating-star star-left"></i>
            <i class="fa-solid fa-star floating-star star-right"></i>

            <div class="main-content">
                <div class="page-header">
                    <h2><i class="fa-solid fa-user-gear" style="color: #f39c12;"></i> My Profile Settings</h2>
                    <p>View your account details and update your security preferences.</p>
                </div>

                <% if(request.getParameter("msg") != null) { %>
                    <% if(request.getParameter("msg").equals("profile_updated")) { %>
                        <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Your profile details have been updated successfully!</div>
                    <% } else if(request.getParameter("msg").equals("password_updated")) { %>
                        <div class="alert alert-success"><i class="fa-solid fa-shield-check"></i> Security updated! Your password has been changed.</div>
                    <% } %>
                <% } %>

                <% if(request.getParameter("error") != null) { %>
                    <% if(request.getParameter("error").equals("wrong_password")) { %>
                        <div class="alert alert-warning"><i class="fa-solid fa-triangle-exclamation"></i> The current password you entered is incorrect.</div>
                    <% } else if(request.getParameter("error").equals("update_failed")) { %>
                        <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> System error: Could not update details. Please try again.</div>
                    <% } %>
                <% } %>

                <div class="profile-container">
                    <div class="avatar-card">
                        <div class="avatar-circle"><i class="fa-regular fa-user"></i></div>
                        <h3><%= (currentUser != null) ? currentUser.getFullName() : "Valued Member" %></h3>
                        <p>Membership ID: <%= (currentUser != null) ? currentUser.getUserId() : "N/A" %></p>
                        <span class="badge-member"><i class="fa-solid fa-star"></i> GOLD MEMBER</span>
                    </div>

                    <div class="form-card">
                        <h3 class="section-title"><i class="fa-solid fa-address-card"></i> Personal Information</h3>
                        <form action="UpdateProfileServlet" method="POST">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Full Name</label>
                                    <input type="text" name="fullName" class="form-control" value="<%= (currentUser != null) ? currentUser.getFullName() : "" %>" required>
                                </div>
                                <div class="form-group">
                                    <label>Phone Number</label>
                                    <input type="text" name="phoneNumber" class="form-control" value="<%= (currentUser != null) ? currentUser.getPhoneNumber() : "" %>" pattern="[0-9]{10}" maxlength="10" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Email Address (Primary)</label>
                                    <input type="email" class="form-control readonly-input" value="<%= userEmail %>" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Account User ID</label>
                                    <input type="text" class="form-control readonly-input" value="<%= (currentUser != null) ? currentUser.getUserId() : "" %>" readonly>
                                </div>
                            </div>
                            <button type="submit" class="btn-action btn-update"><i class="fa-solid fa-floppy-disk"></i> Save Changes</button>
                        </form>

                        <h3 class="section-title" style="margin-top: 45px;">
                            <i class="fa-solid fa-shield-halved"></i> Security & Password
                        </h3>
                        <form action="ChangePasswordServlet" method="POST">
                            <div class="form-row">
                                <div class="form-group">
                                    <label>Current Password</label>
                                    <input type="password" name="oldPassword" class="form-control" placeholder="Required for verification" required>
                                </div>
                                <div class="form-group">
                                    <label>New Secure Password</label>
                                    <input type="password" name="newPassword" class="form-control" placeholder="Enter new password" required>
                                </div>
                            </div>
                            <button type="submit" class="btn-action btn-security"><i class="fa-solid fa-lock"></i> Update Security</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>