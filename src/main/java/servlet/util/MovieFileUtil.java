package util;

import model.Movie;

import javax.servlet.ServletContext;
import java.io.*;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class MovieFileUtil {

    private static final Logger LOGGER = Logger.getLogger(MovieFileUtil.class.getName());
    private static final Object FILE_LOCK = new Object();
    private static final String RELATIVE_PATH = "/WEB-INF/Data/Movies.txt";

    private static String getFilePath(ServletContext context) {
        String path = context.getRealPath(RELATIVE_PATH);
        LOGGER.info("Resolved file path: " + path);
        return path;
    }

    private static String sanitizeField(String field) {
        if (field == null) return "";
        return field.replace(",", "\\,").replace("\"", "\\\"");
    }

    private static String unsanitizeField(String field) {
        if (field == null) return "";
        return field.replace("\\,", ",").replace("\\\"", "\"");
    }

    public static void saveMovie(Movie movie, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            String filePath = getFilePath(context);
            File file = new File(filePath);
            File directory = file.getParentFile();
            if (!directory.exists() && !directory.mkdirs()) {
                throw new IOException("Could not create directory: " + directory.getAbsolutePath());
            }

            // Generate new movie ID
            int newMovieId = 1;
            if (file.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] parts = line.split(",", -1);
                        if (parts.length >= 1) {
                            try {
                                int existingId = Integer.parseInt(parts[0]);
                                if (existingId >= newMovieId) {
                                    newMovieId = existingId + 1;
                                }
                            } catch (NumberFormatException e) {
                                LOGGER.warning("Invalid movie ID format in file: " + line);
                            }
                        }
                    }
                }
            }
            movie.setMovieId(newMovieId);

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
                bw.write(movie.getMovieId() + "," +
                        sanitizeField(movie.getTitle()) + "," +
                        sanitizeField(movie.getGenre()) + "," +
                        movie.getDuration() + "," +
                        sanitizeField(movie.getImageLink()) + "," +
                        (movie.getReleaseDate() != null ? movie.getReleaseDate().toString() : ""));
                bw.newLine();
                LOGGER.info("Saved movie: " + movie.getTitle() + " with ID: " + newMovieId);
            }
        }
    }

    public static List<Movie> getAllMovies(ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            LOGGER.info("Starting getAllMovies");

            List<Movie> movies = new ArrayList<>();

            String filePath = getFilePath(context);
            File file = new File(filePath);
            if (!file.exists()) {
                LOGGER.warning("Movies.txt does not exist at: " + filePath);
                return new ArrayList<>();
            }

            LOGGER.info("Reading Movies.txt from: " + filePath);
            try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                String line;
                int lineNumber = 0;
                while ((line = br.readLine()) != null) {
                    lineNumber++;
                    LOGGER.fine("Processing line " + lineNumber + ": " + line);
                    String[] parts = line.split(",", -1);
                    if (parts.length >= 6) {
                        try {
                            int movieId = Integer.parseInt(parts[0]);
                            String title = unsanitizeField(parts[1]);
                            String genre = unsanitizeField(parts[2]);
                            int duration = Integer.parseInt(parts[3]);
                            String imageLink = unsanitizeField(parts[4]);
                            LocalDate releaseDate = parts[5].isEmpty() ? null : LocalDate.parse(parts[5]);

                            Movie movie = new Movie(movieId, title, genre, duration, imageLink, releaseDate);
                            movies.add(movie);
                            LOGGER.fine("Added movie: " + title + " (Release Date: " + (releaseDate != null ? releaseDate.toString() : "null") + ")");
                        } catch (NumberFormatException e) {
                            LOGGER.warning("Invalid number format at line " + lineNumber + ": " + line + " - " + e.getMessage());
                            continue;
                        } catch (DateTimeParseException e) {
                            LOGGER.warning("Invalid date format at line " + lineNumber + ": " + line + " - " + e.getMessage());
                            continue;
                        } catch (Exception e) {
                            LOGGER.warning("Error parsing line " + lineNumber + ": " + line + " - " + e.getMessage());
                            continue;
                        }
                    } else {
                        LOGGER.warning("Invalid line format at line " + lineNumber + ": " + line);
                    }
                }
            }

            // Insertion Sort by release date (descending order)
            for (int i = 1; i < movies.size(); i++) {
                Movie key = movies.get(i);
                int j = i - 1;

                while (j >= 0) {
                    Movie current = movies.get(j);
                    boolean shouldSwap;
                    if (key.getReleaseDate() == null && current.getReleaseDate() == null) {
                        shouldSwap = false;
                    } else if (key.getReleaseDate() == null) {
                        shouldSwap = false;
                    } else if (current.getReleaseDate() == null) {
                        shouldSwap = true;
                    } else {
                        shouldSwap = current.getReleaseDate().compareTo(key.getReleaseDate()) < 0;
                    }

                    if (!shouldSwap) break;

                    movies.set(j + 1, movies.get(j));
                    j--;
                }
                movies.set(j + 1, key);
            }

            LOGGER.info("Total movies retrieved: " + movies.size());
            return movies;
        }
    }

    public static Movie getMovieById(int movieId, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            String filePath = getFilePath(context);
            File file = new File(filePath);
            if (!file.exists()) {
                return null;
            }
            try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",", -1);
                    if (parts.length >= 6 && Integer.parseInt(parts[0]) == movieId) {
                        LocalDate releaseDate = parts[5].isEmpty() ? null : LocalDate.parse(parts[5]);
                        return new Movie(
                                Integer.parseInt(parts[0]),
                                unsanitizeField(parts[1]),
                                unsanitizeField(parts[2]),
                                Integer.parseInt(parts[3]),
                                unsanitizeField(parts[4]),
                                releaseDate
                        );
                    }
                }
            } catch (Exception e) {
                return null;
            }
            return null;
        }
    }

    public static boolean updateMovie(int movieId, Movie updatedMovie, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            List<String> lines = new ArrayList<>();
            String filePath = getFilePath(context);
            File file = new File(filePath);
            boolean isUpdated = false;

            if (file.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] parts = line.split(",", -1);
                        if (parts.length >= 6 && Integer.parseInt(parts[0]) == movieId) {
                            String newLine = updatedMovie.getMovieId() + "," +
                                    sanitizeField(updatedMovie.getTitle()) + "," +
                                    sanitizeField(updatedMovie.getGenre()) + "," +
                                    updatedMovie.getDuration() + "," +
                                    sanitizeField(updatedMovie.getImageLink()) + "," +
                                    (updatedMovie.getReleaseDate() != null ? updatedMovie.getReleaseDate().toString() : "");
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

    public static boolean deleteMovie(int movieId, ServletContext context) throws IOException {
        synchronized (FILE_LOCK) {
            List<String> lines = new ArrayList<>();
            String filePath = getFilePath(context);
            File file = new File(filePath);
            boolean isDeleted = false;

            if (file.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] parts = line.split(",", -1);
                        if (parts.length >= 6 && Integer.parseInt(parts[0]) != movieId) {
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