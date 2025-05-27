package model;

import java.io.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

public class Showtime {
    private String showtimeId;
    private Movie movie;
    private Theater theater;
    private LocalDateTime startTime;
    private List<Seat> seats;
    private static List<Showtime> allShowtimes = new ArrayList<>();
    private static String filePath;

    public Showtime(Movie movie, Theater theater, LocalDateTime startTime, List<Seat> seats) {
        this.showtimeId = UUID.randomUUID().toString();
        this.movie = movie;
        this.theater = theater;
        this.startTime = startTime;
        this.seats = seats != null ? seats : new ArrayList<>();
        allShowtimes.add(this);
        saveToFile();
    }

    // Constructor for loading from file
    public Showtime(String showtimeId, Movie movie, Theater theater, LocalDateTime startTime, List<Seat> seats) {
        this.showtimeId = showtimeId;
        this.movie = movie;
        this.theater = theater;
        this.startTime = startTime;
        this.seats = seats != null ? seats : new ArrayList<>();
    }

    public static void setFilePath(String path) {
        filePath = path;
    }

    // Save all showtimes to file
    private static void saveToFile() {
        if (filePath == null) return;
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Showtime showtime : allShowtimes) {
                writer.write(showtime.getShowtimeId() + "," +
                        showtime.getMovie().getMovieId() + "," +
                        showtime.getTheater().getTheaterId() + "," +
                        showtime.getStartTime().toString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving showtimes to file: " + e.getMessage());
        }
    }

    // Load showtimes from file
    public static void loadFromFile() {
        if (filePath == null) return;
        allShowtimes.clear();

        List<Movie> movies = Movie.getAllMovies();
        List<Theater> theaters = Theater.getAllTheaters();

        if (movies.isEmpty()) {
            System.out.println("No movies available. Please add movies before loading showtimes.");
            return;
        }
        if (theaters.isEmpty()) {
            System.out.println("No theaters available. Please add theaters before loading showtimes.");
            return;
        }

        List<Seat> dummySeats = new ArrayList<>();
        Seat dummySeat1 = new Seat();
        dummySeat1.setTheaterId("theater1");
        dummySeats.add(dummySeat1);
        Seat dummySeat2 = new Seat();
        dummySeat2.setTheaterId("theater2");
        dummySeats.add(dummySeat2);

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length != 4) continue;
                String showtimeId = parts[0];
                String movieId = parts[1];
                String theaterId = parts[2];
                LocalDateTime startTime = LocalDateTime.parse(parts[3]);

                Movie movie = movies.stream()
                        .filter(m -> m.getMovieId().equals(movieId))
                        .findFirst()
                        .orElse(null);
                Theater theater = theaters.stream()
                        .filter(t -> t.getTheaterId().equals(theaterId))
                        .findFirst()
                        .orElse(null);
                List<Seat> theaterSeats = dummySeats.stream()
                        .filter(s -> s.getTheaterId().equals(theaterId))
                        .toList();

                if (movie != null && theater != null) {
                    Showtime showtime = new Showtime(showtimeId, movie, theater, startTime, theaterSeats);
                    allShowtimes.add(showtime);
                } else {
                    System.out.println("Skipping showtime " + showtimeId + ": Movie or theater not found (movieId=" + movieId + ", theaterId=" + theaterId + ")");
                }
            }
        } catch (FileNotFoundException e) {
            System.out.println("No showtimes file found, starting fresh.");
        } catch (IOException e) {
            System.err.println("Error loading showtimes from file: " + e.getMessage());
        }
    }

    public void updateShowtime(Movie movie, Theater theater, LocalDateTime startTime) {
        this.movie = movie != null ? movie : this.movie;
        this.theater = theater != null ? theater : this.theater;
        this.startTime = startTime != null ? startTime : this.startTime;
        saveToFile();
    }

    public static Showtime findShowtimeById(String showtimeId) {
        for (Showtime showtime : allShowtimes) {
            if (showtime.showtimeId.equals(showtimeId)) {
                return showtime;
            }
        }
        return null;
    }

    public static boolean deleteShowtimeById(String showtimeId) {
        Showtime showtime = findShowtimeById(showtimeId);
        if (showtime != null) {
            allShowtimes.remove(showtime);
            saveToFile();
            return true;
        }
        return false;
    }

    public static List<Showtime> getAllShowtimes() {
        return Collections.unmodifiableList(allShowtimes);
    }

    // Getters
    public String getShowtimeId() {
        return showtimeId;
    }

    public Movie getMovie() {
        return movie;
    }

    public Theater getTheater() {
        return theater;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public List<Seat> getSeats() {
        return Collections.unmodifiableList(seats);
    }
}