package model;

public class Seat {
    private int seatId;
    private int theaterId;
    private int seatNumber;
    private boolean available;

    public Seat(int seatId, int theaterId, int seatNumber, boolean available) {
        this.seatId = seatId;
        this.theaterId = theaterId;
        this.seatNumber = seatNumber;
        this.available = available;
    }

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getTheaterId() {
        return theaterId;
    }

    public void setTheaterId(int theaterId) {
        this.theaterId = theaterId;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(int seatNumber) {
        this.seatNumber = seatNumber;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }
}