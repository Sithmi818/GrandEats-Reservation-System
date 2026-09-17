package com.reservation.model;

public class Message {
    private int id;
    private String name;
    private String email;
    private String content;
    private String date;
    private String status;

    // Default Constructor
    public Message() {}

    public Message(int id, String name, String email, String content, String date, String status) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.content = content;
        this.date = date;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}