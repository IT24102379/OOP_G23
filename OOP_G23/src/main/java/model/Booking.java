package model;

import java.time.LocalDateTime;

public class Booking {
    private int bookingId;
    private int showtimeId;
    private LocalDateTime bookingDate;
    private int paymentId;
    private int seatId;
    private int customerId;

    public Booking(int bookingId, int showtimeId, LocalDateTime bookingDate, int paymentId, int seatId, int customerId) {
        this.bookingId = bookingId;
        this.showtimeId = showtimeId;
        this.bookingDate = bookingDate;
        this.paymentId = paymentId;
        this.seatId = seatId;
        this.customerId = customerId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public LocalDateTime getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDateTime bookingDate) {
        this.bookingDate = bookingDate;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }
}