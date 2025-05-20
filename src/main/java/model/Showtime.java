package model;

import java.time.LocalDateTime;

public class Showtime {
    private int showtimeId;
    private LocalDateTime showtimeDate;
    private int movieId;
    private int theaterId;


    public Showtime(int showtimeId, LocalDateTime showtimeDate, int movieId, int theaterId) {
        this.showtimeId = showtimeId;
        this.showtimeDate = showtimeDate;
        this.movieId = movieId;
        this.theaterId = theaterId;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public LocalDateTime getShowtimeDate() {
        return showtimeDate;
    }

    public void setShowtimeDate(LocalDateTime showtimeDate) {
        this.showtimeDate = showtimeDate;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getTheaterId() {
        return theaterId;
    }

    public void setTheaterId(int theaterId) {
        this.theaterId = theaterId;
    }
}