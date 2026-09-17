package com.reservation.service;

import com.reservation.model.User;
import com.reservation.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserService {

    public String loginUser(String email, String password) {
        String query = "SELECT role FROM users WHERE email = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("role");
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateProfile(String fullName, String phoneNumber, String email) {
        String query = "UPDATE users SET name = ?, phoneNumber = ? WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, fullName);
            ps.setString(2, phoneNumber);
            ps.setString(3, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updatePassword(String email, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean registerUser(User user) {
        String query = "INSERT INTO users (id, name, email, phoneNumber, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, user.getUserId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhoneNumber()); // 🟢 ෆෝන් නම්බර් එක සේව් වෙනවා
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getRole());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getString("id"), rs.getString("name"), rs.getString("email"),
                        rs.getString("phoneNumber"), rs.getString("password"), rs.getString("role"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean deleteUser(String email) {
        String query = "DELETE FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String query = "SELECT * FROM users WHERE role != 'admin'";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                userList.add(new User(rs.getString("id"), rs.getString("name"), rs.getString("email"),
                        rs.getString("phoneNumber"), rs.getString("password"), rs.getString("role")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return userList;
    }

    public String getNextUserId() {
        String query = "SELECT id FROM users WHERE id LIKE 'U-%' ORDER BY CAST(SUBSTRING(id, 3) AS UNSIGNED) DESC LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(query)) {

            if (rs.next()) {
                String lastId = rs.getString("id");
                if (lastId != null && lastId.length() > 2) {
                    int nextNum = Integer.parseInt(lastId.substring(2)) + 1;
                    return "U-" + nextNum;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "U-10000";
    }
}