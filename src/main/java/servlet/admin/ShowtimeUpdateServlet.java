package servlet.admin;

import model.Showtime;
import util.ShowtimeFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

@WebServlet(name = "ShowtimeUpdateServlet", value = "/ShowtimeUpdateServlet")
public class ShowtimeUpdateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        String showtimeIdStr = request.getParameter("showtimeId");
        if (showtimeIdStr == null || showtimeIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing showtime ID");
            return;
        }

        int showtimeId;
        try {
            showtimeId = Integer.parseInt(showtimeIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid showtime ID format");
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            Showtime showtime = ShowtimeFileUtil.getShowtimeById(showtimeId, context);
            if (showtime == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Showtime not found");
                return;
            }
            request.setAttribute("showtime", showtime);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/showtime-update.jsp");
            dispatcher.forward(request, response);
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error retrieving showtime: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/showtime-update.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        String showtimeIdStr = request.getParameter("showtimeId");
        String showtimeDateStr = request.getParameter("showtimeDate");
        String movieIdStr = request.getParameter("movieId");
        String theaterIdStr = request.getParameter("theaterId");

        // Validate input parameters
        if (showtimeIdStr == null || showtimeIdStr.trim().isEmpty() ||
                showtimeDateStr == null || showtimeDateStr.trim().isEmpty() ||
                movieIdStr == null || movieIdStr.trim().isEmpty() ||
                theaterIdStr == null || theaterIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        int showtimeId;
        LocalDateTime showtimeDate;
        int movieId;
        int theaterId;
        try {
            showtimeId = Integer.parseInt(showtimeIdStr);
            showtimeDate = LocalDateTime.parse(showtimeDateStr);
            movieId = Integer.parseInt(movieIdStr);
            theaterId = Integer.parseInt(theaterIdStr);
            if (movieId <= 0 || theaterId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Movie ID and Theater ID must be positive");
                return;
            }
        } catch (DateTimeParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid showtime date format");
            return;
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid showtime ID, movie ID, or theater ID format");
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            Showtime updatedShowtime = new Showtime(showtimeId, showtimeDate, movieId, theaterId);
            if (ShowtimeFileUtil.updateShowtime(showtimeId, updatedShowtime, context)) {
                response.sendRedirect("ShowtimeListServlet?success=Showtime%20updated%20successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Showtime not found or could not be updated");
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error updating showtime: " + e.getMessage());
            request.getRequestDispatcher("Admin/showtime-update.jsp").forward(request, response);
        }
    }
}