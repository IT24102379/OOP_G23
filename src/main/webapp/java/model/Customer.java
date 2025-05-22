package model;

public class Customer extends User {
    private String customerType;
    private int loyaltyPoints;

    public Customer(int userId, String username, String email, String password, String phoneNumber, String customerType) {
        super(userId, username, email, password, phoneNumber);
        this.customerType = customerType;
        this.loyaltyPoints = 0;
    }

    public Customer(String username, String password, String email) {
        super(username, password, email);
        this.customerType = "Regular";
        this.loyaltyPoints = 0;
    }

    public String getCustomerType() {
        return customerType;
    }

    public void setCustomerType(String customerType) {
        this.customerType = customerType;
    }

    public int getLoyaltyPoints() {
        return loyaltyPoints;
    }

    public void setLoyaltyPoints(int loyaltyPoints) {
        this.loyaltyPoints = loyaltyPoints;
    }
}