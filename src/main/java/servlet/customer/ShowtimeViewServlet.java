package servlet.customer;

import model.Showtime;
import util.ShowtimeFileUtil;
import util.TheaterFileUtil;
import model.Theater;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "ShowtimeViewServlet", value = "/ShowtimeViewServlet")
public class ShowtimeViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"customer".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Customer/customer-login.jsp");
            return;
        }

        // Get and validate movieId parameter
        String movieIdStr = request.getParameter("movieId");
        System.out.println("Raw movieIdStr: " + movieIdStr);
        if (movieIdStr == null || movieIdStr.trim().isEmpty() || movieIdStr.contains("&")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid or missing movie ID: " + movieIdStr);
            return;
        }

        // Get and validate movieTitle parameter
        String movieTitle = request.getParameter("movieTitle");
        System.out.println("Raw movieTitle: " + movieTitle);
        if (movieTitle == null || movieTitle.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing movie title");
            return;
        }

        // Parse movieId
        int movieId;
        try {
            movieId = Integer.parseInt(movieIdStr);
            if (movieId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Movie ID must be positive");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid movie ID format: " + e.getMessage());
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            List<Showtime> showtimes = ShowtimeFileUtil.getAllShowtimes(context).stream()
                    .filter(showtime -> showtime.getMovieId() == movieId)
                    .collect(Collectors.toList());

            // Create a map of theaterId to theaterName with debugging
            Map<Integer, String> theaterNames = new HashMap<>();
            for (Showtime showtime : showtimes) {
                int theaterId = showtime.getTheaterId();
                System.out.println("Processing showtime with theaterId: " + theaterId);
                Theater theater = TheaterFileUtil.getTheaterById(context, theaterId);
                if (theater != null) {
                    String theaterName = theater.getName();
                    theaterNames.put(theaterId, theaterName);
                    System.out.println("Found theater - theaterId: " + theaterId + ", name: " + theaterName);
                } else {
                    theaterNames.put(theaterId, "Unknown Theater");
                    System.out.println("No theater found for theaterId: " + theaterId);
                }
            }

            request.setAttribute("showtimes", showtimes);
            request.setAttribute("movieId", movieId);
            request.setAttribute("movieTitle", movieTitle);
            request.setAttribute("theaterNames", theaterNames);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Customer/showtime-view.jsp");
            dispatcher.forward(request, response);
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error retrieving showtimes: " + e.getMessage());
            request.setAttribute("movieTitle", movieTitle);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Customer/showtime-view.jsp");
            dispatcher.forward(request, response);
        }
    }
}