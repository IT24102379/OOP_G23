package util;

import model.Seat;

import javax.servlet.ServletContext;
import java.io.*;

public class SeatFileUtil {
    private static final String RELATIVE_PATH = "/WEB-INF/Data/Seats.txt";
    private static final Object FILE_LOCK = new Object();
    private static final int INITIAL_CAPACITY = 10; // Initial capacity, can be adjusted

    public static Seat[] getAllSeats(ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            String filePath = context.getRealPath(RELATIVE_PATH);
            File file = new File(filePath);

            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
                return new Seat[0];
            }

            int size = 0;
            Seat[] seats = new Seat[INITIAL_CAPACITY];
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length == 4) {
                        try {
                            int seatId = Integer.parseInt(parts[0].trim());
                            int theaterId = Integer.parseInt(parts[1].trim());
                            int seatNumber = Integer.parseInt(parts[2].trim());
                            boolean available = Boolean.parseBoolean(parts[3].trim());
                            Seat seat = new Seat(seatId, theaterId, seatNumber, available);
                            if (size >= seats.length) {
                                seats = resizeArray(seats, seats.length * 2);
                            }
                            seats[size++] = seat;
                        } catch (NumberFormatException | ArrayIndexOutOfBoundsException e) {
                            System.err.println("Invalid seat entry in file: " + line + " - " + e.getMessage());
                        }
                    }
                }
            } catch (IOException e) {
                System.err.println("Error reading seats file: " + e.getMessage());
                throw e;
            }

            // Trim the array to the actual size
            Seat[] trimmedSeats = new Seat[size];
            for (int i = 0; i < size; i++) {
                trimmedSeats[i] = seats[i];
            }
            return trimmedSeats;
        }
    }

    public static Seat getSeatById(ServletContext context, int seatId) throws IOException {
        synchronized (FILE_LOCK) {
            Seat[] seats = getAllSeats(context);
            for (int i = 0; i < seats.length; i++) {
                if (seats[i] != null && seats[i].getSeatId() == seatId) {
                    return seats[i];
                }
            }
            return null;
        }
    }

    public static Seat[] getSeatsByTheaterId(ServletContext context, int theaterId) throws IOException {
        synchronized (FILE_LOCK) {
            Seat[] allSeats = getAllSeats(context);
            int count = 0;
            // First pass: count matching seats
            for (int i = 0; i < allSeats.length; i++) {
                if (allSeats[i] != null && allSeats[i].getTheaterId() == theaterId) {
                    count++;
                }
            }
            // Second pass: create result array and copy matching seats
            Seat[] result = new Seat[count];
            int index = 0;
            for (int i = 0; i < allSeats.length; i++) {
                if (allSeats[i] != null && allSeats[i].getTheaterId() == theaterId) {
                    result[index++] = allSeats[i];
                }
            }
            return result;
        }
    }

    public static boolean saveSeat(ServletContext context, Seat seat) throws IOException {
        synchronized (FILE_LOCK) {
            Seat[] seats = getAllSeats(context);
            int size = seats.length;
            // Check if seat already exists
            for (int i = 0; i < size; i++) {
                if (seats[i] != null && seats[i].getSeatId() == seat.getSeatId()) {
                    return false; // Seat ID already exists, consider updating instead
                }
            }
            // Create a new array with extra space
            Seat[] newSeats = new Seat[size + 1];
            for (int i = 0; i < size; i++) {
                newSeats[i] = seats[i];
            }
            newSeats[size] = seat;

            String filePath = context.getRealPath(RELATIVE_PATH);
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (int i = 0; i <= size; i++) {
                    if (newSeats[i] != null) {
                        String line = String.format("%d,%d,%d,%b",
                                newSeats[i].getSeatId(),
                                newSeats[i].getTheaterId(),
                                newSeats[i].getSeatNumber(),
                                newSeats[i].isAvailable());
                        writer.write(line);
                        writer.newLine();
                    }
                }
                return true;
            } catch (IOException e) {
                System.err.println("Error writing to seats file: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
        }
    }

    public static boolean deleteSeatsByTheaterId(ServletContext context, int theaterId) throws IOException {
        synchronized (FILE_LOCK) {
            Seat[] seats = getAllSeats(context);
            int count = 0;
            // First pass: count seats to keep
            for (int i = 0; i < seats.length; i++) {
                if (seats[i] != null && seats[i].getTheaterId() != theaterId) {
                    count++;
                }
            }
            // Second pass: create new array with seats to keep
            Seat[] updatedSeats = new Seat[count];
            int index = 0;
            for (int i = 0; i < seats.length; i++) {
                if (seats[i] != null && seats[i].getTheaterId() != theaterId) {
                    updatedSeats[index++] = seats[i];
                }
            }

            String filePath = context.getRealPath(RELATIVE_PATH);
            File file = new File(filePath);
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (int i = 0; i < updatedSeats.length; i++) {
                    if (updatedSeats[i] != null) {
                        String line = String.format("%d,%d,%d,%b",
                                updatedSeats[i].getSeatId(),
                                updatedSeats[i].getTheaterId(),
                                updatedSeats[i].getSeatNumber(),
                                updatedSeats[i].isAvailable());
                        writer.write(line);
                        writer.newLine();
                    }
                }
                return true;
            } catch (IOException e) {
                System.err.println("Error writing to seats file during deletion: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
        }
    }

    public static boolean updateSeat(ServletContext context, int seatId, Seat updatedSeat) throws IOException {
        synchronized (FILE_LOCK) {
            Seat[] seats = getAllSeats(context);
            boolean found = false;

            for (int i = 0; i < seats.length; i++) {
                if (seats[i] != null && seats[i].getSeatId() == seatId) {
                    seats[i] = updatedSeat;
                    found = true;
                    break;
                }
            }

            if (!found) {
                return false;
            }

            String filePath = context.getRealPath(RELATIVE_PATH);
            File file = new File(filePath);
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (int i = 0; i < seats.length; i++) {
                    if (seats[i] != null) {
                        String line = String.format("%d,%d,%d,%b",
                                seats[i].getSeatId(),
                                seats[i].getTheaterId(),
                                seats[i].getSeatNumber(),
                                seats[i].isAvailable());
                        writer.write(line);
                        writer.newLine();
                    }
                }
                return true;
            } catch (IOException e) {
                System.err.println("Error writing to seats file: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
        }
    }

    // Helper method to resize the array
    private static Seat[] resizeArray(Seat[] oldArray, int newCapacity) {
        Seat[] newArray = new Seat[newCapacity];
        for (int i = 0; i < oldArray.length; i++) {
            newArray[i] = oldArray[i];
        }
        return newArray;
    }
}