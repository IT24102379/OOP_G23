package util;

import model.Seat;
import model.Theater;

import javax.servlet.ServletContext;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class TheaterFileUtil {
    private static final String RELATIVE_PATH = "/WEB-INF/Data/Theaters.txt";

    public static boolean saveTheater(ServletContext context, Theater theater) throws IOException {
        List<Theater> theaters = getAllTheaters(context);
        theaters.add(theater);

        String filePath = context.getRealPath(RELATIVE_PATH);
        File file = new File(filePath);
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Theater t : theaters) {
                String line = String.format("%d,%s,%s,%d",
                        t.getTheaterId(),
                        t.getName(),
                        t.getLocation(),
                        t.getCapacity());
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing to theaters file: " + e.getMessage());
            e.printStackTrace();
            return false;
        }

        // Create seats for the theater
        for (int i = 1; i <= theater.getCapacity(); i++) {
            Seat seat = new Seat(i, theater.getTheaterId(), i, true);
            SeatFileUtil.saveSeat(context, seat);
        }

        return true;
    }

    public static List<Theater> getAllTheaters(ServletContext context) throws IOException {
        String filePath = context.getRealPath(RELATIVE_PATH);
        List<Theater> theaters = new ArrayList<>();
        File file = new File(filePath);

        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
            return theaters;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty()) {
                    System.err.println("Skipping empty line at line " + lineNumber);
                    continue;
                }

                String[] parts = line.split(",");
                if (parts.length == 4) {
                    try {
                        int theaterId = Integer.parseInt(parts[0].trim());
                        String name = parts[1].trim();
                        String location = parts[2].trim();
                        int capacity = Integer.parseInt(parts[3].trim());
                        Theater theater = new Theater(theaterId, name, location, capacity);
                        theaters.add(theater);
                    } catch (NumberFormatException e) {
                        System.err.println("Error parsing line " + lineNumber + " in Theaters.txt: " + line + " - " + e.getMessage());
                        continue;
                    }
                } else {
                    System.err.println("Invalid line format at line " + lineNumber + " in Theaters.txt: " + line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading theaters file: " + e.getMessage());
            throw e;
        }
        return theaters;
    }

    public static Theater getTheaterById(ServletContext context, int theaterId) throws IOException {
        List<Theater> theaters = getAllTheaters(context);
        for (Theater theater : theaters) {
            if (theater.getTheaterId() == theaterId) {
                return theater;
            }
        }
        return null;
    }

    public static boolean updateTheater(ServletContext context, int theaterId, Theater updatedTheater) throws IOException {
        List<Theater> theaters = getAllTheaters(context);
        boolean found = false;

        for (int i = 0; i < theaters.size(); i++) {
            if (theaters.get(i).getTheaterId() == theaterId) {
                theaters.set(i, updatedTheater);
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
            for (Theater t : theaters) {
                String line = String.format("%d,%s,%s,%d",
                        t.getTheaterId(),
                        t.getName(),
                        t.getLocation(),
                        t.getCapacity());
                writer.write(line);
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error writing to theaters file: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteTheater(ServletContext context, int theaterId) throws IOException {
        List<Theater> theaters = getAllTheaters(context);
        List<Theater> updatedTheaters = new ArrayList<>();

        boolean found = false;
        for (Theater theater : theaters) {
            if (theater.getTheaterId() == theaterId) {
                found = true;
                continue;
            }
            updatedTheaters.add(theater);
        }

        if (!found) {
            return false;
        }

        // Delete associated showtimes
        if (!ShowFileUtil.deleteShowsByTheaterId(context, theaterId)) {
            return false;
        }

        // Delete associated seats
        if (!SeatFileUtil.deleteSeatsByTheaterId(context, theaterId)) {
            return false;
        }

        String filePath = context.getRealPath(RELATIVE_PATH);
        File file = new File(filePath);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Theater t : updatedTheaters) {
                String line = String.format("%d,%s,%s,%d",
                        t.getTheaterId(),
                        t.getName(),
                        t.getLocation(),
                        t.getCapacity());
                writer.write(line);
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error writing to theaters file during deletion: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}