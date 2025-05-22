package model;

public class BookingRequest {
    private int showtimeId;
    private int movieId;
    private int[] seatIds; // Changed from List<Integer> to int[]
    private double amount;
    private String paymentMethod;
    private int customerId;
    private String sessionId;
    private String contextPath;

    public BookingRequest(int showtimeId, int movieId, int[] seatIds, double amount, String paymentMethod, int customerId, String sessionId, String contextPath) {
        this.showtimeId = showtimeId;
        this.movieId = movieId;
        this.seatIds = seatIds;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.customerId = customerId;
        this.sessionId = sessionId;
        this.contextPath = contextPath;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public int getMovieId() {
        return movieId;
    }

    public int[] getSeatIds() {
        return seatIds;
    }

    public double getAmount() {
        return amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public int getCustomerId() {
        return customerId;
    }

    public String getSessionId() {
        return sessionId;
    }

    public String getContextPath() {
        return contextPath;
    }
}