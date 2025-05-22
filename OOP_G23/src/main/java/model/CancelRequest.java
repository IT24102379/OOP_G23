package model;

public class CancelRequest {
    private int bookingId;
    private String sessionId;
    private String contextPath;

    public CancelRequest(int bookingId, String sessionId, String contextPath) {
        this.bookingId = bookingId;
        this.sessionId = sessionId;
        this.contextPath = contextPath;
    }

    public int getBookingId() {
        return bookingId;
    }

    public String getSessionId() {
        return sessionId;
    }

    public String getContextPath() {
        return contextPath;
    }
}