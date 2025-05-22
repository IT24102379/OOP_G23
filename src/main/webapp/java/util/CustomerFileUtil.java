package util;

import model.Customer;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class CustomerFileUtil {

    public static void saveCustomer(String filePath, Customer customer) {
        try {
            // Generate new user ID
            List<Customer> customers = getAllCustomers(filePath);
            int newId = customers.isEmpty() ? 1 : customers.get(customers.size() - 1).getUserId() + 1;
            customer.setUserId(newId);

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
                bw.write(customer.getUserId() + "," + customer.getUsername() + "," +
                        customer.getEmail() + "," + customer.getPassword() + "," +
                        customer.getPhoneNumber() + "," + customer.getCustomerType() + "," +
                        customer.getLoyaltyPoints());
                bw.newLine();
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to save customer to file: " + e.getMessage(), e);
        }
    }

    public static boolean isEmailRegistered(String filePath, String email) {
        File file = new File(filePath);
        if (!file.exists()) {
            return false; // If file doesn't exist, no emails are registered
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7 && parts[2].equalsIgnoreCase(email)) {
                    return true;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to check email in file: " + e.getMessage(), e);
        }
        return false;
    }

    public static List<Customer> getAllCustomers(String filePath) {
        List<Customer> customers = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) {
            return customers; // Return empty list if file doesn't exist
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7) {
                    try {
                        Customer customer = new Customer(
                                Integer.parseInt(parts[0]), parts[1], parts[2], parts[3], parts[4], parts[5]
                        );
                        customer.setLoyaltyPoints(Integer.parseInt(parts[6]));
                        customers.add(customer);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid user ID or loyalty points format in line: " + line);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to read customers from file: " + e.getMessage(), e);
        }
        return customers;
    }

    public static Customer getCustomerById(String filePath, int customerId) {
        File file = new File(filePath);
        if (!file.exists()) {
            return null; // Return null if file doesn't exist
        }

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7 && Integer.parseInt(parts[0]) == customerId) {
                    Customer customer = new Customer(
                            Integer.parseInt(parts[0]), parts[1], parts[2], parts[3], parts[4], parts[5]
                    );
                    customer.setLoyaltyPoints(Integer.parseInt(parts[6]));
                    return customer;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to retrieve customer by ID: " + e.getMessage(), e);
        }
        return null;
    }

    public static boolean updateCustomer(String filePath, int customerId, Customer updatedCustomer) {
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
                if (parts.length >= 7 && Integer.parseInt(parts[0]) == customerId) {
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
            throw new RuntimeException("Failed to read customers for update: " + e.getMessage(), e);
        }

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (String l : lines) {
                bw.write(l);
                bw.newLine();
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to write updated customers to file: " + e.getMessage(), e);
        }
        return isUpdated;
    }

    public static boolean deleteCustomer(String filePath, int customerId) {
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
                if (parts.length >= 7 && Integer.parseInt(parts[0]) != customerId) {
                    lines.add(line);
                } else {
                    isDeleted = true;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to read customers for deletion: " + e.getMessage(), e);
        }

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
            for (String l : lines) {
                bw.write(l);
                bw.newLine();
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to write customers after deletion: " + e.getMessage(), e);
        }
        return isDeleted;
    }
}