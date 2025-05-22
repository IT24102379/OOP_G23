package util;

import model.Booking;
import model.BookingRequest;
import model.CancelRequest;
import model.Payment;
import model.Seat;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.time.LocalDateTime;

public class BookingQueueProcessor {
    private static BookingQueueProcessor instance;
    private final CustomQueue queue;
    private final Thread processorThread;
    private final ServletContext servletContext;
    private volatile boolean running;

    private BookingQueueProcessor(ServletContext context) {
        this.servletContext = context;
        this.queue = new CustomQueue(100); // Fixed size of 100, adjustable as needed
        this.running = true;
        this.processorThread = new Thread(this::processQueue);
        this.processorThread.start();
    }

    public static synchronized BookingQueueProcessor getInstance(ServletContext context) {
        if (instance == null) {
            instance = new BookingQueueProcessor(context);
        }
        return instance;
    }

    public void addBookingRequest(BookingRequest request) {
        synchronized (queue) {
            // *** Enqueue Operation ***
            while (!queue.enqueue(request)) {
                try {
                    queue.wait(); // Wait if queue is full
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    System.err.println("Interrupted while adding booking request: " + e.getMessage());
                    return;
                }
            }
            System.out.println("Added booking request to queue for session: " + request.getSessionId() + ", queue size: " + queue.size());
            queue.notifyAll(); // Notify waiting threads
        }
    }

    public void addCancelRequest(CancelRequest request) {
        synchronized (queue) {
            // *** Enqueue Operation ***
            while (!queue.enqueue(request)) {
                try {
                    queue.wait(); // Wait if queue is full
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    System.err.println("Interrupted while adding cancel request: " + e.getMessage());
                    return;
                }
            }
            System.out.println("Added cancel request to queue for session: " + request.getSessionId() + ", queue size: " + queue.size());
            queue.notifyAll(); // Notify waiting threads
        }
    }

    private void processQueue() {
        while (running) {
            Object request;
            synchronized (queue) {
                while (queue.isEmpty()) {
                    try {
                        queue.wait(); // Wait if queue is empty
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        System.err.println("Interrupted while processing queue: " + e.getMessage());
                        return;
                    }
                }
                // *** Dequeue Operation ***
                request = queue.dequeue();
                queue.notifyAll(); // Notify waiting threads
            }
            try {
                if (request instanceof BookingRequest) {
                    System.out.println("Processing booking request for session: " + ((BookingRequest) request).getSessionId());
                    processBookingRequest((BookingRequest) request);
                } else if (request instanceof CancelRequest) {
                    System.out.println("Processing cancel request for session: " + ((CancelRequest) request).getSessionId());
                    processCancelRequest((CancelRequest) request);
                }
            } catch (IOException e) {
                System.err.println("IOException while processing queue: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    private void processBookingRequest(BookingRequest request) throws IOException {
        Object[] bookedSeats = new Object[10]; // Assuming max 10 seats per booking, adjust as needed
        Object[] createdPayments = new Object[1]; // Assuming one payment per booking
        Object[] createdBookings = new Object[10]; // Assuming max 10 bookings per request, adjust as needed
        int seatCount = 0, paymentCount = 0, bookingCount = 0;

        HttpSession session = getSessionById(request.getSessionId());
        if (session == null) {
            System.err.println("Session not found for sessionId: " + request.getSessionId());
            return;
        }

        try {
            int[] seatIds = request.getSeatIds();
            if (seatIds == null) {
                throw new IOException("Seat IDs cannot be null");
            }
            int seatIdsLength = seatIds.length;

            for (int seatId : seatIds) {
                Seat seat = SeatFileUtil.getSeatById(servletContext, seatId);
                if (seat == null) {
                    throw new IOException("Seat " + seatId + " not found");
                }
                System.out.println("Seat " + seatId + " found, availability: " + seat.isAvailable());
                if (!seat.isAvailable()) {
                    throw new IOException("Seat " + seatId + " is not available");
                }

                seat.setAvailable(false);
                System.out.println("Updating seat " + seatId + " availability to false");
                if (!SeatFileUtil.updateSeat(servletContext, seatId, seat)) {
                    throw new IOException("Error updating seat " + seatId + " availability");
                }
                bookedSeats[seatCount++] = seat;
            }

            int paymentId = generatePaymentId();
            System.out.println("Generated paymentId: " + paymentId);

            LocalDateTime paymentDate = LocalDateTime.now();
            Payment payment = new Payment(paymentId, request.getAmount(), request.getPaymentMethod(), paymentDate);
            System.out.println("Saving payment for " + seatIdsLength + " seats");
            if (!PaymentFileUtil.addPayment(servletContext, payment)) {
                throw new IOException("Error saving payment for seats");
            }
            createdPayments[paymentCount++] = payment;

            for (int seatId : seatIds) {
                int bookingId = generateBookingId();
                System.out.println("Generated bookingId: " + bookingId + " for seat " + seatId);
                LocalDateTime bookingDate = LocalDateTime.now();
                Booking booking = new Booking(bookingId, request.getShowtimeId(), bookingDate, paymentId, seatId, request.getCustomerId());
                System.out.println("Saving booking for seat " + seatId);
                if (!BookingFileUtil.addBooking(servletContext, booking)) {
                    throw new IOException("Error creating booking for seat " + seatId);
                }
                createdBookings[bookingCount++] = booking;
            }

            System.out.println("Booking successful for " + seatIdsLength + " seats");
            session.setAttribute("bookingResult", "success=Booking%20created%20successfully%20for%20" + seatIdsLength + "%20seat" + (seatIdsLength > 1 ? "s" : ""));
        } catch (Exception e) {
            System.err.println("Booking error for session " + request.getSessionId() + ": " + e.getMessage());
            e.printStackTrace();
            for (int i = 0; i < seatCount; i++) {
                if (bookedSeats[i] != null) {
                    Seat seat = (Seat) bookedSeats[i];
                    seat.setAvailable(true);
                    System.out.println("Rolling back seat " + seat.getSeatId() + " availability to true");
                    SeatFileUtil.updateSeat(servletContext, seat.getSeatId(), seat);
                }
            }
            for (int i = 0; i < paymentCount; i++) {
                if (createdPayments[i] != null) {
                    System.err.println("Orphaned payment " + ((Payment) createdPayments[i]).getPaymentId() + " created without booking; requires manual cleanup");
                }
            }
            session.setAttribute("bookingResult", "error=" + e.getMessage().replace(" ", "%20"));
        }
    }

    private void processCancelRequest(CancelRequest request) {
        HttpSession session = getSessionById(request.getSessionId());
        if (session == null) {
            System.err.println("Session not found for sessionId: " + request.getSessionId());
            return;
        }

        try {
            Booking booking = BookingFileUtil.getBookingById(servletContext, request.getBookingId());
            if (booking == null) {
                System.out.println("Booking not found for bookingId: " + request.getBookingId());
                session.setAttribute("bookingResult", "error=Booking%20not%20found");
                return;
            }

            Seat seat = SeatFileUtil.getSeatById(servletContext, booking.getSeatId());
            if (seat == null) {
                System.out.println("Seat not found for seatId: " + booking.getSeatId());
                session.setAttribute("bookingResult", "error=Seat%20not%20found");
                return;
            }

            seat.setAvailable(true);
            if (!SeatFileUtil.updateSeat(servletContext, seat.getSeatId(), seat)) {
                throw new IOException("Error updating seat availability for seatId: " + seat.getSeatId());
            }

            if (!BookingFileUtil.cancelBooking(servletContext, request.getBookingId())) {
                seat.setAvailable(false);
                SeatFileUtil.updateSeat(servletContext, seat.getSeatId(), seat);
                throw new IOException("Error cancelling booking for bookingId: " + request.getBookingId());
            }

            System.out.println("Booking cancelled successfully for bookingId: " + request.getBookingId());
            session.setAttribute("bookingResult", "success=Booking%20cancelled%20successfully");
        } catch (Exception e) {
            System.err.println("Cancellation error for session " + request.getSessionId() + ": " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("bookingResult", "error=" + e.getMessage().replace(" ", "%20"));
        }
    }

    public void shutdown() {
        running = false;
        processorThread.interrupt();
    }

    private int generateBookingId() throws IOException {
        Object[] bookings = BookingFileUtil.getAllBookings(servletContext).toArray();
        if (bookings == null || bookings.length == 0) {
            return 1;
        }
        int maxId = 0;
        for (Object obj : bookings) {
            Booking booking = (Booking) obj;
            if (booking.getBookingId() > maxId) {
                maxId = booking.getBookingId();
            }
        }
        return maxId + 1;
    }

    private int generatePaymentId() throws IOException {
        Object[] payments = PaymentFileUtil.getAllPayments(servletContext).toArray();
        if (payments == null || payments.length == 0) {
            return 1;
        }
        int maxId = 0;
        for (Object obj : payments) {
            Payment payment = (Payment) obj;
            if (payment.getPaymentId() > maxId) {
                maxId = payment.getPaymentId();
            }
        }
        return maxId + 1;
    }

    private HttpSession getSessionById(String sessionId) {
        return (HttpSession) servletContext.getAttribute("session_" + sessionId);
    }

    // Command-line interface for testing the queue
    public static void main(String[] args) {
        // Note: ServletContext is null in this context; this is for demo purposes
        BookingQueueProcessor processor = new BookingQueueProcessor(null);
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Booking Queue Processor Command Line Interface");
        System.out.println("Commands: enqueue_booking, enqueue_cancel, dequeue, size, exit");

        while (true) {
            try {
                System.out.print("Enter command: ");
                String command = reader.readLine().trim().toLowerCase();

                if (command.equals("exit")) {
                    processor.shutdown();
                    break;
                } else if (command.equals("enqueue_booking")) {
                    System.out.print("Enter showtimeId: ");
                    int showtimeId = Integer.parseInt(reader.readLine());
                    System.out.print("Enter movieId: ");
                    int movieId = Integer.parseInt(reader.readLine());
                    System.out.print("Enter seatIds (comma-separated, e.g., 1,2,3): ");
                    String[] seatIdStrs = reader.readLine().split(",");
                    int[] seatIds = new int[seatIdStrs.length];
                    for (int i = 0; i < seatIdStrs.length; i++) {
                        seatIds[i] = Integer.parseInt(seatIdStrs[i].trim());
                    }
                    System.out.print("Enter amount: ");
                    double amount = Double.parseDouble(reader.readLine());
                    System.out.print("Enter paymentMethod: ");
                    String paymentMethod = reader.readLine();
                    System.out.print("Enter customerId: ");
                    int customerId = Integer.parseInt(reader.readLine());
                    System.out.print("Enter sessionId: ");
                    String sessionId = reader.readLine();
                    System.out.print("Enter contextPath: ");
                    String contextPath = reader.readLine();

                    BookingRequest request = new BookingRequest(showtimeId, movieId, seatIds, amount, paymentMethod, customerId, sessionId, contextPath);
                    processor.addBookingRequest(request);
                } else if (command.equals("enqueue_cancel")) {
                    System.out.print("Enter bookingId: ");
                    int bookingId = Integer.parseInt(reader.readLine());
                    System.out.print("Enter sessionId: ");
                    String sessionId = reader.readLine();
                    System.out.print("Enter contextPath: ");
                    String contextPath = reader.readLine();

                    CancelRequest request = new CancelRequest(bookingId, sessionId, contextPath);
                    processor.addCancelRequest(request);
                } else if (command.equals("dequeue")) {
                    synchronized (processor.queue) {
                        if (processor.queue.isEmpty()) {
                            System.out.println("Queue is empty");
                        } else {
                            // *** Dequeue Operation ***
                            Object request = processor.queue.dequeue();
                            System.out.println("Dequeued request: " + request);
                            processor.queue.notifyAll();
                        }
                    }
                } else if (command.equals("size")) {
                    System.out.println("Queue size: " + processor.queue.size());
                } else {
                    System.out.println("Unknown command. Available commands: enqueue_booking, enqueue_cancel, dequeue, size, exit");
                }
            } catch (Exception e) {
                System.err.println("Error: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    // Custom Queue implementation
    private static class CustomQueue {
        private final Object[] elements;
        private int front;
        private int rear;
        private int size;
        private final int capacity;

        public CustomQueue(int capacity) {
            this.capacity = capacity;
            this.elements = new Object[capacity];
            this.front = 0;
            this.rear = -1;
            this.size = 0;
        }

        public synchronized boolean enqueue(Object item) {
            if (size == capacity) {
                return false; // Queue is full
            }
            rear = (rear + 1) % capacity;
            elements[rear] = item;
            size++;
            return true;
        }

        public synchronized Object dequeue() {
            if (isEmpty()) {
                return null; // Queue is empty
            }
            Object item = elements[front];
            elements[front] = null;
            front = (front + 1) % capacity;
            size--;
            return item;
        }

        public synchronized boolean isEmpty() {
            return size == 0;
        }

        public synchronized int size() {
            return size;
        }
    }
}