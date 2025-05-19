package util;

import model.Admin;
import model.Customer;
import model.User;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class FileUtil {

    public static boolean validateUser(String filePath, String username, String password) {
        File file = new File(filePath);
        if (!file.exists()) {
            return false; // Return false if file doesn't exist
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7 && parts[1].equals(username) && parts[3].equals(password)) {
                    return true;
                }
                if (parts.length == 6 && parts[1].equals(username) && parts[3].equals(password)) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static String[] readUserFromFile(String filePath, String username) {
        File file = new File(filePath);
        if (!file.exists()) {
            return null; // Return null if file doesn't exist
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 6 && parts[1].equals(username)) {
                    return parts;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean updateCustomerDetails(String filePath, String exEmail, String exPassword, User updatedUser) {
        Customer updatedCustomer = (Customer) updatedUser;
        List<String> lines = new ArrayList<>();
        boolean isUpdated = false;

        File file = new File(filePath);
        if (!file.exists()) {
            return false; // Return false if file doesn't exist
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7 && parts[2].equals(exEmail) && parts[3].equals(exPassword)) {
                    updatedCustomer.setUserId(Integer.parseInt(parts[0]));
                    String newLine = updatedCustomer.getUserId() + "," + updatedCustomer.getUsername() + "," +
                            updatedCustomer.getEmail() + "," + updatedCustomer.getPassword() + "," +
                            updatedCustomer.getPhoneNumber() + "," + updatedCustomer.getCustomerType() + "," +
                            updatedCustomer.getLoyaltyPoints();
                    lines.add(newLine);
                    isUpdated = true;
                } else {
                    lines.add(line);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isUpdated) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
                for (String l : lines) {
                    bw.write(l);
                    bw.newLine();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return isUpdated;
    }

    public static boolean updateAdminDetails(String filePath, String exEmail, String exPassword, User updatedUser) {
        Admin updatedAdmin = (Admin) updatedUser;
        List<String> lines = new ArrayList<>();
        boolean isUpdated = false;

        File file = new File(filePath);
        if (!file.exists()) {
            return false; // Return false if file doesn't exist
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 6 && parts[2].equals(exEmail) && parts[3].equals(exPassword)) {
                    updatedAdmin.setUserId(Integer.parseInt(parts[0]));
                    String newLine = updatedAdmin.getUserId() + "," + updatedAdmin.getUsername() + "," +
                            updatedAdmin.getEmail() + "," + updatedAdmin.getPassword() + "," +
                            updatedAdmin.getPhoneNumber() + "," + updatedAdmin.getAdminLevel();
                    lines.add(newLine);
                    isUpdated = true;
                } else {
                    lines.add(line);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isUpdated) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
                for (String l : lines) {
                    bw.write(l);
                    bw.newLine();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return isUpdated;
    }

    public static boolean delete(String filePath, String email, String password) {
        List<String> lines = new ArrayList<>();
        boolean isDeleted = false;

        File file = new File(filePath);
        if (!file.exists()) {
            return false; // Return false if file doesn't exist
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 6 && parts[2].equals(email) && parts[3].equals(password)) {
                    isDeleted = true;
                } else {
                    lines.add(line);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (isDeleted) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
                for (String l : lines) {
                    bw.write(l);
                    bw.newLine();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return isDeleted;
    }
}