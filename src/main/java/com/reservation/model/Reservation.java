package com.reservation.model;

public class Reservation {
    private int id;
    private String userEmail;
    private String customerName;
    private String phone;
    private String date;
    private String time;
    private int guests;
    private String tableType;
    private String preOrderedFood;
    private String specialNote;
    private String status;

    public Reservation(String userEmail, String customerName, String phone, String date, String time, int guests, String tableType, String preOrderedFood, String specialNote, String status) {
        this.userEmail = userEmail;
        this.customerName = customerName;
        this.phone = phone;
        this.date = date;
        this.time = time;
        this.guests = guests;
        this.tableType = tableType;
        this.preOrderedFood = preOrderedFood;
        this.specialNote = specialNote;
        this.status = status;
    }

    public Reservation(int id, String userEmail, String customerName, String phone, String date, String time, int guests, String tableType, String preOrderedFood, String specialNote, String status) {
        this.id = id;
        this.userEmail = userEmail;
        this.customerName = customerName;
        this.phone = phone;
        this.date = date;
        this.time = time;
        this.guests = guests;
        this.tableType = tableType;
        this.preOrderedFood = preOrderedFood;
        this.specialNote = specialNote;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }
    public int getGuests() { return guests; }
    public void setGuests(int guests) { this.guests = guests; }
    public String getTableType() { return tableType; }
    public void setTableType(String tableType) { this.tableType = tableType; }
    public String getPreOrderedFood() { return preOrderedFood; }
    public void setPreOrderedFood(String preOrderedFood) { this.preOrderedFood = preOrderedFood; }
    public String getSpecialNote() { return specialNote; }
    public void setSpecialNote(String specialNote) { this.specialNote = specialNote; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}