package util;

import model.Show;

import javax.servlet.ServletContext;
import java.io.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ShowFileUtil {
    private static final String RELATIVE_PATH = "/WEB-INF/Data/Shows.txt";

    public static List<Show> getAllShows(ServletContext context) throws IOException {
        String filePath = context.getRealPath(RELATIVE_PATH);
        List<Show> showList = new ArrayList<>();
        File file = new File(filePath);

        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
            return showList;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 4) {
                    int showtimeId = Integer.parseInt(parts[0].trim());
                    int movieId = Integer.parseInt(parts[1].trim());
                    int theaterId = Integer.parseInt(parts[2].trim());
                    LocalDateTime showDateTime = LocalDateTime.parse(parts[3].trim());
                    Show show = new Show(showtimeId, movieId, theaterId, showDateTime);
                    showList.add(show);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading shows file: " + e.getMessage());
            throw e;
        }
        return showList;
    }

    public static Show getShowById(ServletContext context, int showtimeId) throws IOException {
        List<Show> shows = getAllShows(context);
        for (Show show : shows) {
            if (show.getShowtimeId() == showtimeId) {
                return show;
            }
        }
        return null;
    }

    public static boolean deleteShowsByTheaterId(ServletContext context, int theaterId) throws IOException {
        List<Show> shows = getAllShows(context);
        List<Show> updatedShows = shows.stream()
                .filter(show -> show.getTheaterId() != theaterId)
                .collect(Collectors.toList());

        String filePath = context.getRealPath(RELATIVE_PATH);
        File file = new File(filePath);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Show s : updatedShows) {
                String line = String.format("%d,%d,%d,%s",
                        s.getShowtimeId(),
                        s.getMovieId(),
                        s.getTheaterId(),
                        s.getShowDateTime().toString());
                writer.write(line);
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            System.err.println("Error writing to shows file during deletion: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}