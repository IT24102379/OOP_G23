package model;

public class Admin extends User {
    private String adminLevel;

    public Admin(int userId, String username, String email, String password, String phoneNumber, String adminLevel) {
        super(userId, username, email, password, phoneNumber);
        this.adminLevel = adminLevel;
    }

    public Admin(String username, String password, String email) {
        super(username, password, email);
        this.adminLevel = "Level1";
    }

    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }
}