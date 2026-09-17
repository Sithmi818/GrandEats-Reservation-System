package com.reservation.model;

public class MenuItem {
    private int id;
    private String name;
    private String category;
    private double price;
    private String status;
    private String imageUrl;

    public MenuItem(String name, String category, double price, String status, String imageUrl) {
        this.name = name;
        this.category = category;
        this.price = price;
        this.status = status;
        this.imageUrl = imageUrl;
    }

    public MenuItem(int id, String name, String category, double price, String status, String imageUrl) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.status = status;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}