package com.reservation.service;

import com.reservation.model.Reservation;
import com.reservation.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReservationService {

    public boolean addReservation(Reservation r) {
        String query = "INSERT INTO reservations (user_email, customer_name, phone, reservation_date, reservation_time, guests, table_type, pre_ordered_food, special_note, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, r.getUserEmail());
            ps.setString(2, r.getCustomerName());
            ps.setString(3, r.getPhone());
            ps.setString(4, r.getDate());
            ps.setString(5, r.getTime());
            ps.setInt(6, r.getGuests());
            ps.setString(7, r.getTableType());
            ps.setString(8, r.getPreOrderedFood());
            ps.setString(9, r.getSpecialNote());
            ps.setString(10, r.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String query = "SELECT * FROM reservations ORDER BY reservation_date DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Reservation(rs.getInt("id"), rs.getString("user_email"), rs.getString("customer_name"), rs.getString("phone"), rs.getString("reservation_date"), rs.getString("reservation_time"), rs.getInt("guests"), rs.getString("table_type"), rs.getString("pre_ordered_food"), rs.getString("special_note"), rs.getString("status")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Reservation> getReservationsByUser(String email) {
        List<Reservation> list = new ArrayList<>();
        String query = "SELECT * FROM reservations WHERE user_email = ? ORDER BY reservation_date DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Reservation(rs.getInt("id"), rs.getString("user_email"), rs.getString("customer_name"), rs.getString("phone"), rs.getString("reservation_date"), rs.getString("reservation_time"), rs.getInt("guests"), rs.getString("table_type"), rs.getString("pre_ordered_food"), rs.getString("special_note"), rs.getString("status")));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateReservationStatus(int id, String status) {
        String query = "UPDATE reservations SET status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, status); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateReservationDetails(int id, String date, String time, int guests, String tableType, String food, String note) {
        String query = "UPDATE reservations SET reservation_date=?, reservation_time=?, guests=?, table_type=?, pre_ordered_food=?, special_note=? WHERE id=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, date); ps.setString(2, time); ps.setInt(3, guests); ps.setString(4, tableType); ps.setString(5, food); ps.setString(6, note); ps.setInt(7, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean isTableAvailable(String date, String time, String tableType) {
        String query = "SELECT COUNT(*) FROM reservations WHERE reservation_date = ? AND reservation_time = ? AND table_type = ? AND status != 'Cancelled'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, date); ps.setString(2, time); ps.setString(3, tableType);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) { return rs.getInt(1) == 0; } // 0 නම් Available
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
    public Reservation getReservationById(int id) {
        String query = "SELECT * FROM reservations WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Reservation(
                            rs.getInt("id"), rs.getString("user_email"), rs.getString("customer_name"),
                            rs.getString("phone"), rs.getString("reservation_date"), rs.getString("reservation_time"),
                            rs.getInt("guests"), rs.getString("table_type"), rs.getString("pre_ordered_food"),
                            rs.getString("special_note"), rs.getString("status")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}