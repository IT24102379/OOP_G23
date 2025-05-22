package servlet;

import model.Seat;
import model.Showtime;
import util.SeatFileUtil;
import util.ShowtimeFileUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "SeatViewServlet", value = "/SeatViewServlet")
public class SeatViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check for valid customer session
        HttpSession session = request.getSession(false);
        if (session == null || !"customer".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Customer/customer-login.jsp");
            return;
        }

        // Generate and store CSRF token if not present
        if (session.getAttribute("csrfToken") == null) {
            String csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
        }

        // Retrieve and parse parameters
        int showtimeId;
        int movieId;
        int theaterId;
        try {
            showtimeId = Integer.parseInt(request.getParameter("showtimeId"));
            movieId = Integer.parseInt(request.getParameter("movieId"));
            theaterId = Integer.parseInt(request.getParameter("theaterId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("ShowtimeViewServlet?movieId=" + request.getParameter("movieId") + "&error=Invalid%20showtime%20or%20movie%20or%20theater%20ID");
            return;
        }

        // Fetch Showtime object for validation and display purposes
        Showtime showtime = ShowtimeFileUtil.getShowtimeById(showtimeId, getServletContext());
        if (showtime == null) {
            response.sendRedirect("ShowtimeViewServlet?movieId=" + movieId + "&error=Showtime%20not%20found");
            return;
        }
        if (showtime.getTheaterId() != theaterId) {
            System.out.println("Warning: theaterId from parameter (" + theaterId + ") does not match showtime theaterId (" + showtime.getTheaterId() + ")");
        }

        // Fetch available seats for the theater
        Seat[] seats = SeatFileUtil.getSeatsByTheaterId(getServletContext(), theaterId);
        if (seats == null || seats.length == 0) {
            response.sendRedirect("ShowtimeViewServlet?movieId=" + movieId + "&error=No%20seats%20available%20for%20this%20theater");
            return;
        }

        // Filter for available seats manually
        int availableCount = 0;
        for (int i = 0; i < seats.length; i++) {
            if (seats[i] != null && seats[i].isAvailable()) {
                availableCount++;
            }
        }

        Seat[] availableSeats = new Seat[availableCount];
        int index = 0;
        for (int i = 0; i < seats.length; i++) {
            if (seats[i] != null && seats[i].isAvailable()) {
                availableSeats[index++] = seats[i];
            }
        }

        if (availableCount == 0) {
            request.setAttribute("errorMessage", "No available seats for this showtime.");
        }

        // Set request attributes for JSP
        request.setAttribute("showtimeId", showtimeId);
        request.setAttribute("movieId", movieId);
        request.setAttribute("theaterId", theaterId);
        request.setAttribute("seats", availableSeats);
        request.setAttribute("showtime", showtime); // Include Showtime object for JSP

        // Forward to seat-view.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("Customer/seat-view.jsp");
        dispatcher.forward(request, response);
    }
}