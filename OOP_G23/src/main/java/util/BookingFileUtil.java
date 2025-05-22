package util;

import model.Booking;

import javax.servlet.ServletContext;
import java.io.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookingFileUtil {
    private static final String RELATIVE_PATH = "/WEB-INF/Data/Bookings.txt";
    private static final Object FILE_LOCK = new Object();

    public static List<Booking> getAllBookings(ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            String filePath = context.getRealPath(RELATIVE_PATH);
            List<Booking> bookingList = new ArrayList<>();
            File file = new File(filePath);

            if (!file.exists()) {
                System.out.println("Bookings file does not exist, creating new: " + filePath);
                file.getParentFile().mkdirs();
                file.createNewFile();
                return bookingList;
            }

            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length == 6) {
                        int bookingId = Integer.parseInt(parts[0].trim());
                        int showtimeId = Integer.parseInt(parts[1].trim());
                        LocalDateTime bookingDate = LocalDateTime.parse(parts[2].trim());
                        int paymentId = Integer.parseInt(parts[3].trim());
                        int seatId = Integer.parseInt(parts[4].trim());
                        int customerId = Integer.parseInt(parts[5].trim());
                        Booking booking = new Booking(bookingId, showtimeId, bookingDate, paymentId, seatId, customerId);
                        bookingList.add(booking);
                    } else {
                        System.err.println("Invalid booking entry in file: " + line);
                    }
                }
            } catch (IOException e) {
                System.err.println("Error reading bookings file: " + e.getMessage());
                throw e;
            } catch (Exception e) {
                System.err.println("Error parsing bookings file: " + e.getMessage());
                throw new IOException("Error parsing bookings file", e);
            }
            return bookingList;
        }
    }

    public static Booking getBookingById(ServletContext context, int bookingId) throws IOException {
        synchronized (FILE_LOCK) {
            List<Booking> bookings = getAllBookings(context);
            for (Booking booking : bookings) {
                if (booking.getBookingId() == bookingId) {
                    return booking;
                }
            }
            return null;
        }
    }

    public static boolean addBooking(ServletContext context, Booking booking) throws IOException {
        synchronized (FILE_LOCK) {
            List<Booking> bookings = getAllBookings(context);
            bookings.add(booking);

            String filePath = context.getRealPath(RELATIVE_PATH);
            File file = new File(filePath);
            if (!file.exists()) {
                System.out.println("Bookings file does not exist, creating new: " + filePath);
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Booking b : bookings) {
                    String line = String.format("%d,%d,%s,%d,%d,%d",
                            b.getBookingId(),
                            b.getShowtimeId(),
                            b.getBookingDate().toString(),
                            b.getPaymentId(),
                            b.getSeatId(),
                            b.getCustomerId());
                    writer.write(line);
                    writer.newLine();
                }
                return true;
            } catch (IOException e) {
                System.err.println("Error writing to bookings file: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
        }
    }

    public static boolean cancelBooking(ServletContext context, int bookingId) throws IOException {
        synchronized (FILE_LOCK) {
            List<Booking> bookings = getAllBookings(context);
            List<Booking> updatedBookings = new ArrayList<>();

            boolean found = false;
            for (Booking booking : bookings) {
                if (booking.getBookingId() == bookingId) {
                    found = true;
                    continue;
                }
                updatedBookings.add(booking);
            }

            if (!found) {
                System.out.println("Booking not found for cancellation: " + bookingId);
                return false;
            }

            String filePath = context.getRealPath(RELATIVE_PATH);
            File file = new File(filePath);
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Booking b : updatedBookings) {
                    String line = String.format("%d,%d,%s,%d,%d,%d",
                            b.getBookingId(),
                            b.getShowtimeId(),
                            b.getBookingDate().toString(),
                            b.getPaymentId(),
                            b.getSeatId(),
                            b.getCustomerId());
                    writer.write(line);
                    writer.newLine();
                }
                System.out.println("Booking cancelled and file updated: " + bookingId);
                return true;
            } catch (IOException e) {
                System.err.println("Error writing to bookings file during cancellation: " + e.getMessage());
                e.printStackTrace();
                return false;
            }
        }
    }
}