package util;

import model.Admin;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class AdminFileUtil {
    private static final ReentrantReadWriteLock lock = new ReentrantReadWriteLock();

    public static void saveAdmin(String filePath, Admin admin) {
        lock.writeLock().lock();
        try {
            List<Admin> admins = getAllAdmins(filePath);
            int newId = admins.isEmpty() ? 1 : admins.get(admins.size() - 1).getUserId() + 1;
            admin.setUserId(newId);

            File file = new File(filePath);
            File directory = file.getParentFile();
            if (directory != null && !directory.exists() && !directory.mkdirs()) {
                throw new RuntimeException("Failed to create directory: " + directory.getAbsolutePath());
            }

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
                bw.write(admin.getUserId() + "," + (admin.getUsername() != null ? admin.getUsername() : "") + "," +
                        (admin.getEmail() != null ? admin.getEmail() : "") + "," +
                        (admin.getPassword() != null ? admin.getPassword() : "") + "," +
                        (admin.getPhoneNumber() != null ? admin.getPhoneNumber() : "") + "," +
                        (admin.getAdminLevel() != null ? admin.getAdminLevel() : ""));
                bw.newLine();
            }
        } catch (Exception e) {
            throw new RuntimeException("Failed to save admin to file: " + e.getMessage(), e);
        } finally {
            lock.writeLock().unlock();
        }
    }

    public static boolean isEmailRegistered(String filePath, String email) {
        lock.readLock().lock();
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                return false;
            }

            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length >= 6 && parts[2] != null && parts[2].equalsIgnoreCase(email)) {
                        return true;
                    }
                }
            }
            return false;
        } catch (Exception e) {
            throw new RuntimeException("Failed to check email in file: " + e.getMessage(), e);
        } finally {
            lock.readLock().unlock();
        }
    }

    public static List<Admin> getAllAdmins(String filePath) {
        lock.readLock().lock();
        try {
            List<Admin> admins = new ArrayList<>();
            File file = new File(filePath);
            if (!file.exists()) {
                return admins;
            }

            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length >= 6) {
                        try {
                            Admin admin = new Admin(
                                    Integer.parseInt(parts[0]),
                                    parts[1],
                                    parts[2],
                                    parts[3],
                                    parts[4],
                                    parts[5]
                            );
                            admins.add(admin);
                        } catch (NumberFormatException | NullPointerException e) {
                            System.err.println("Invalid data format in line: " + line + " - " + e.getMessage());
                        }
                    }
                }
            }
            return admins;
        } catch (Exception e) {
            throw new RuntimeException("Failed to read admins from file: " + e.getMessage(), e);
        } finally {
            lock.readLock().unlock();
        }
    }

    public static Admin getAdminById(String filePath, int adminId) {
        lock.readLock().lock();
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                return null;
            }

            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length >= 6 && Integer.parseInt(parts[0]) == adminId) {
                        return new Admin(
                                Integer.parseInt(parts[0]),
                                parts[1],
                                parts[2],
                                parts[3],
                                parts[4],
                                parts[5]
                        );
                    }
                }
            }
            return null;
        } catch (Exception e) {
            throw new RuntimeException("Failed to retrieve admin by ID: " + e.getMessage(), e);
        } finally {
            lock.readLock().unlock();
        }
    }

    public static boolean updateAdmin(String filePath, int adminId, Admin updatedAdmin) {
        lock.writeLock().lock();
        try {
            List<String> lines = new ArrayList<>();
            boolean isUpdated = false;
            File file = new File(filePath);
            if (!file.exists()) {
                return false;
            }

            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length >= 6 && Integer.parseInt(parts[0]) == adminId) {
                        String newLine = updatedAdmin.getUserId() + "," + (updatedAdmin.getUsername() != null ? updatedAdmin.getUsername() : "") + "," +
                                (updatedAdmin.getEmail() != null ? updatedAdmin.getEmail() : "") + "," +
                                (updatedAdmin.getPassword() != null ? updatedAdmin.getPassword() : "") + "," +
                                (updatedAdmin.getPhoneNumber() != null ? updatedAdmin.getPhoneNumber() : "") + "," +
                                (updatedAdmin.getAdminLevel() != null ? updatedAdmin.getAdminLevel() : "");
                        lines.add(newLine);
                        isUpdated = true;
                    } else {
                        lines.add(line);
                    }
                }
            }

            if (isUpdated) {
                try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
                    for (String l : lines) {
                        bw.write(l);
                        bw.newLine();
                    }
                }
            }
            return isUpdated;
        } catch (Exception e) {
            throw new RuntimeException("Failed to update admin in file: " + e.getMessage(), e);
        } finally {
            lock.writeLock().unlock();
        }
    }

    public static boolean deleteAdmin(String filePath, int adminId) {
        lock.writeLock().lock();
        try {
            List<String> lines = new ArrayList<>();
            boolean isDeleted = false;
            File file = new File(filePath);
            if (!file.exists()) {
                return false;
            }

            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length >= 6 && Integer.parseInt(parts[0]) != adminId) {
                        lines.add(line);
                    } else {
                        isDeleted = true;
                    }
                }
            }

            if (isDeleted) {
                try (BufferedWriter bw = new BufferedWriter(new FileWriter(file))) {
                    for (String l : lines) {
                        bw.write(l);
                        bw.newLine();
                    }
                }
            }
            return isDeleted;
        } catch (Exception e) {
            throw new RuntimeException("Failed to delete admin from file: " + e.getMessage(), e);
        } finally {
            lock.writeLock().unlock();
        }
    }
}