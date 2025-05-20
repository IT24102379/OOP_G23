package util;

import model.Showtime;

import javax.servlet.ServletContext;
import java.io.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ShowtimeFileUtil {

    private static final Object FILE_LOCK = new Object();
    private static final String RELATIVE_PATH = "/WEB-INF/Data/Showtimes.txt";

    private static String getFilePath(ServletContext context) {
        return context.getRealPath(RELATIVE_PATH);
    }

    public static void saveShowtime(Showtime showtime, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            String filePath = getFilePath(context);
            File file = new File(filePath);
            File directory = file.getParentFile();
            if (!directory.exists() && !directory.mkdirs()) {
                throw new IOException("Could not create directory: " + directory.getAbsolutePath());
            }
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
                bw.write(showtime.getShowtimeId() + "," + showtime.getShowtimeDate() + "," +
                        showtime.getMovieId() + "," + showtime.getTheaterId());
                bw.newLine();
            }
        }
    }

    public static List<Showtime> getAllShowtimes(ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            List<Showtime> showtimes = new ArrayList<>();
            String filePath = getFilePath(context);
            File file = new File(filePath);
            if (!file.exists()) {
                return showtimes; // Return empty list if file doesn't exist
            }
            try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length >= 4) {
                        Showtime showtime = new Showtime(
                                Integer.parseInt(parts[0]), LocalDateTime.parse(parts[1]),
                                Integer.parseInt(parts[2]), Integer.parseInt(parts[3])
                        );
                        showtimes.add(showtime);
                    }
                }
            }
            return showtimes;
        }
    }

    public static Showtime getShowtimeById(int showtimeId, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            String filePath = getFilePath(context);
            File file = new File(filePath);
            if (!file.exists()) {
                return null;
            }
            try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",");
                    if (parts.length >= 4 && Integer.parseInt(parts[0]) == showtimeId) {
                        return new Showtime(
                                Integer.parseInt(parts[0]), LocalDateTime.parse(parts[1]),
                                Integer.parseInt(parts[2]), Integer.parseInt(parts[3])
                        );
                    }
                }
            }
            return null;
        }
    }

    public static boolean updateShowtime(int showtimeId, Showtime updatedShowtime, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            List<String> lines = new ArrayList<>();
            String filePath = getFilePath(context);
            File file = new File(filePath);
            boolean isUpdated = false;

            if (file.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] parts = line.split(",");
                        if (parts.length >= 4 && Integer.parseInt(parts[0]) == showtimeId) {
                            String newLine = updatedShowtime.getShowtimeId() + "," + updatedShowtime.getShowtimeDate() + "," +
                                    updatedShowtime.getMovieId() + "," + updatedShowtime.getTheaterId();
                            lines.add(newLine);
                            isUpdated = true;
                        } else {
                            lines.add(line);
                        }
                    }
                }
            }

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
                for (String l : lines) {
                    bw.write(l);
                    bw.newLine();
                }
            }
            return isUpdated;
        }
    }

    public static boolean deleteShowtime(int showtimeId, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            List<String> lines = new ArrayList<>();
            String filePath = getFilePath(context);
            File file = new File(filePath);
            boolean isDeleted = false;

            if (file.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] parts = line.split(",");
                        if (parts.length >= 4 && Integer.parseInt(parts[0]) != showtimeId) {
                            lines.add(line);
                        } else {
                            isDeleted = true;
                        }
                    }
                }
            }

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath))) {
                for (String l : lines) {
                    bw.write(l);
                    bw.newLine();
                }
            }
            return isDeleted;
        }
    }
}