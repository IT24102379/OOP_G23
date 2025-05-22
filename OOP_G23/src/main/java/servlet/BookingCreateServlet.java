package servlet;

import model.BookingRequest;
import util.BookingQueueProcessor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "BookingCreateServlet", value = "/BookingCreateServlet")
public class BookingCreateServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"customer".equals(session.getAttribute("userType"))) {
            System.out.println("Session validation failed: No session or userType is not customer");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login as a customer");
            return;
        }

        String csrfToken = request.getParameter("csrfToken");
        if (!validateCsrfToken(session, csrfToken)) {
            System.out.println("CSRF token validation failed: Token mismatch or missing");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        Object userIdObj = session.getAttribute("userId");
        int customerId;
        try {
            if (userIdObj == null) {
                throw new IllegalArgumentException("User ID is missing in session");
            }
            customerId = Integer.parseInt(userIdObj.toString());
            if (customerId <= 0) {
                throw new IllegalArgumentException("User ID must be positive");
            }
        } catch (IllegalArgumentException e) {
            System.out.println("User ID validation error: " + e.getMessage());
            response.sendRedirect("Customer/customer-login.jsp?error=Invalid%20user%20ID");
            return;
        }

        int showtimeId;
        int movieId;
        double amount;
        String paymentMethod = request.getParameter("paymentMethod");
        String seatIdsParam = request.getParameter("seatIds");

        System.out.println("Received parameters in BookingCreateServlet:");
        System.out.println("csrfToken: " + csrfToken);
        System.out.println("showtimeId: " + request.getParameter("showtimeId"));
        System.out.println("movieId: " + request.getParameter("movieId"));
        System.out.println("seatIds: " + seatIdsParam);
        System.out.println("amount: " + request.getParameter("amount"));
        System.out.println("paymentMethod: " + paymentMethod);

        try {
            showtimeId = parsePositiveInt(request.getParameter("showtimeId"), "Showtime ID");
            movieId = parsePositiveInt(request.getParameter("movieId"), "Movie ID");
            amount = parsePositiveDouble(request.getParameter("amount"), "Amount");
        } catch (IllegalArgumentException e) {
            System.out.println("Validation error: " + e.getMessage());
            String redirectUrl = "SeatViewServlet?showtimeId=" + request.getParameter("showtimeId") + "&movieId=" + request.getParameter("movieId") + "&error=" + e.getMessage().replace(" ", "%20");
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
            return;
        }

        int[] seatIds;
        if (seatIdsParam == null || seatIdsParam.trim().isEmpty()) {
            System.out.println("Validation error: Seat IDs are missing");
            String redirectUrl = "SeatViewServlet?showtimeId=" + showtimeId + "&movieId=" + movieId + "&error=Seat%20IDs%20are%20missing";
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
            return;
        }
        try {
            String[] seatIdArray = seatIdsParam.split(",");
            seatIds = new int[seatIdArray.length];
            for (int i = 0; i < seatIdArray.length; i++) {
                seatIds[i] = parsePositiveInt(seatIdArray[i].trim(), "Seat ID");
            }
        } catch (IllegalArgumentException e) {
            System.out.println("Validation error: " + e.getMessage());
            String redirectUrl = "SeatViewServlet?showtimeId=" + showtimeId + "&movieId=" + movieId + "&error=" + e.getMessage().replace(" ", "%20");
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
            return;
        }

        if (amount <= 0) {
            System.out.println("Amount validation error: Amount must be positive");
            String redirectUrl = "SeatViewServlet?showtimeId=" + showtimeId + "&movieId=" + movieId + "&error=Amount%20must%20be%20positive";
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
            return;
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            System.out.println("Payment method validation error: Payment method is required");
            String redirectUrl = "SeatViewServlet?showtimeId=" + showtimeId + "&movieId=" + movieId + "&error=Payment%20method%20is%20required";
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
            return;
        }

        // Manual array for valid payment methods
        String[] validPaymentMethods = {"Credit Card", "Debit Card", "PayPal"};
        boolean isValidPaymentMethod = false;
        for (String method : validPaymentMethods) {
            if (method.equals(paymentMethod)) {
                isValidPaymentMethod = true;
                break;
            }
        }
        if (!isValidPaymentMethod) {
            System.out.println("Payment method validation error: Invalid payment method");
            String redirectUrl = "SeatViewServlet?showtimeId=" + showtimeId + "&movieId=" + movieId + "&error=Invalid%20payment%20method";
            System.out.println("Redirecting to: " + redirectUrl);
            response.sendRedirect(redirectUrl);
            return;
        }

        String contextPath = request.getContextPath();
        // Store the session in the ServletContext for retrieval by BookingQueueProcessor
        getServletContext().setAttribute("session_" + session.getId(), session);

        BookingRequest bookingRequest = new BookingRequest(
                showtimeId,
                movieId,
                seatIds,
                amount,
                paymentMethod,
                customerId,
                session.getId(),
                contextPath
        );

        BookingQueueProcessor processor = BookingQueueProcessor.getInstance(getServletContext());
        processor.addBookingRequest(bookingRequest);

        response.sendRedirect(contextPath + "/Customer/booking-processing.jsp?sessionId=" + session.getId());
    }

    private int parsePositiveInt(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " is missing");
        }
        try {
            int result = Integer.parseInt(value);
            if (result <= 0) {
                throw new IllegalArgumentException(fieldName + " must be positive");
            }
            return result;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(fieldName + " must be a valid number");
        }
    }

    private double parsePositiveDouble(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(fieldName + " is missing");
        }
        try {
            double result = Double.parseDouble(value);
            if (result <= 0) {
                throw new IllegalArgumentException(fieldName + " must be positive");
            }
            return result;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(fieldName + " must be a valid number");
        }
    }

    private boolean validateCsrfToken(HttpSession session, String token) {
        String sessionToken = (String) session.getAttribute("csrfToken");
        System.out.println("CSRF token validation - Provided: " + token + ", Expected: " + sessionToken);
        return token != null && token.equals(sessionToken);
    }
}