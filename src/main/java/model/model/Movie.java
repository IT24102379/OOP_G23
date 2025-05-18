package model.model;

import java.io.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

public class Movie {
    private final String movieID;
    private String title;
    private int duration;
    private String genre;
    private LocalDate releaseDate; // For sorting movies
    private List<LocalDateTime> showtimes; // Relationship: showtimes for this movie
    private Queue<String> bookingQueue; // Queue for booking requests (user IDs)
    private static List<Movie> allMovies = new ArrayList<>();
    private static String filePath;

    public Movie(String movieID, String title, int duration, String genre, LocalDate releaseDate) {
        if (movieID == null || movieID.trim().isEmpty()) {
            throw new IllegalArgumentException("Movie ID cannot be null or empty");
        }
        this.movieID = movieID;
        this.title = title != null ? title : "Untitled";
        this.duration = duration > 0 ? duration : 120;
        this.genre = genre != null ? genre : "Unknown";
        this.releaseDate = releaseDate != null ? releaseDate : LocalDate.now();
        this.showtimes = new ArrayList<>(); // Initialize showtimes
        this.bookingQueue = new LinkedList<>(); // Initialize booking queue
        allMovies.add(this);
        saveToFile();
    }

    // Add a showtime to this movie
    public void addShowtime(LocalDateTime showtime) {
        if (showtime != null) {
            showtimes.add(showtime);
        }
    }

    // Get all showtimes for this movie
    public List<LocalDateTime> getShowtimes() {
        return Collections.unmodifiableList(showtimes);
    }

    // Add a booking request to the queue
    public boolean addBookingRequest(String userID) {
        if (userID == null || userID.trim().isEmpty()) {
            return false;
        }
        return bookingQueue.offer(userID);
    }

    // Process the next booking request
    public String processNextBooking() {
        return bookingQueue.poll();
    }

    // Get the current queue size
    public int getBookingQueueSize() {
        return bookingQueue.size();
    }

    public static void setFilePath(String path) {
        filePath = path;
    }

    public String getMovieDetails() {
        return String.format("Movie ID: %s, Title: %s, Duration: %d minutes, Genre: %s, Release Date: %s, Showtimes: %d, Bookings in Queue: %d",
                movieID, title, duration, genre, releaseDate, showtimes.size(), bookingQueue.size());
    }

    public static List<Movie> getAllMovies() {
        return Collections.unmodifiableList(allMovies);
    }

    // Sort movies by release date using Insertion Sort
    public static void sortMoviesByReleaseDate() {
        List<Movie> sortedMovies = new ArrayList<>(allMovies);
        int n = sortedMovies.size();
        for (int i = 1; i < n; i++) {
            Movie key = sortedMovies.get(i);
            int j = i - 1;
            while (j >= 0 && sortedMovies.get(j).getReleaseDate().isAfter(key.getReleaseDate())) {
                sortedMovies.set(j + 1, sortedMovies.get(j));
                j--;
            }
            sortedMovies.set(j + 1, key);
        }
        allMovies.clear();
        allMovies.addAll(sortedMovies);
        saveToFile();
    }

    public static Movie findMovieByID(String movieID) {
        for (Movie movie : allMovies) {
            if (movie.movieID.equals(movieID)) {
                return movie;
            }
        }
        return null;
    }

    public void updateMovie(String title, int duration, String genre, LocalDate releaseDate) {
        this.title = title != null ? title : this.title;
        this.duration = duration > 0 ? duration : this.duration;
        this.genre = genre != null ? genre : this.genre;
        this.releaseDate = releaseDate != null ? releaseDate : this.releaseDate;
        saveToFile();
    }

    public void deleteMovie() {
        allMovies.remove(this);
        saveToFile();
    }

    public static boolean deleteMovieByID(String movieID) {
        Movie movie = findMovieByID(movieID);
        if (movie != null) {
            allMovies.remove(movie);
            saveToFile();
            return true;
        }
        return false;
    }

    private static void saveToFile() {
        if (filePath == null) return;
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Movie movie : allMovies) {
                writer.write(movie.movieID + "," + movie.title + "," + movie.duration + "," + movie.genre + "," + movie.releaseDate);
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving movies to file: " + e.getMessage());
        }
    }

    public static void loadFromFile() {
        if (filePath == null) return;
        allMovies.clear();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 5) {
                    String movieID = parts[0];
                    String title = parts[1];
                    int duration = Integer.parseInt(parts[2]);
                    String genre = parts[3];
                    LocalDate releaseDate = LocalDate.parse(parts[4]);
                    new Movie(movieID, title, duration, genre, releaseDate);
                }
            }
        } catch (FileNotFoundException e) {
            System.out.println("No movie file found, starting fresh.");
        } catch (IOException e) {
            System.err.println("Error loading movies from file: " + e.getMessage());
        }
    }

    // Getters and setters
    public String getMovieID() { return movieID; }
    public String getTitle() { return title; }
    public int getDuration() { return duration; }
    public String getGenre() { return genre; }
    public LocalDate getReleaseDate() { return releaseDate; }

    public void setTitle(String title) {
        this.title = title != null ? title : this.title;
        saveToFile();
    }
    public void setDuration(int duration) {
        this.duration = duration > 0 ? duration : this.duration;
        saveToFile();
    }
    public void setGenre(String genre) {
        this.genre = genre != null ? genre : this.genre;
        saveToFile();
    }
    public void setReleaseDate(LocalDate releaseDate) {
        this.releaseDate = releaseDate != null ? releaseDate : this.releaseDate;
        saveToFile();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Movie movie = (Movie) o;
        return movieID.equals(movie.movieID);
    }

    @Override
    public int hashCode() {
        return Objects.hash(movieID);
    }

    @Override
    public String toString() {
        return getMovieDetails();
    }
}