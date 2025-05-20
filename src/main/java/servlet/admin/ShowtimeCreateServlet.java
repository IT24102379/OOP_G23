package servlet.admin;

import model.Showtime;
import util.ShowtimeFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "ShowtimeCreateServlet", value = "/ShowtimeCreateServlet")
public class ShowtimeCreateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        String showtimeDateStr = request.getParameter("showtimeDate");
        String movieIdStr = request.getParameter("movieId");
        String theaterIdStr = request.getParameter("theaterId");

        // Validate input parameters
        if (showtimeDateStr == null || showtimeDateStr.trim().isEmpty() ||
                movieIdStr == null || movieIdStr.trim().isEmpty() ||
                theaterIdStr == null || theaterIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        LocalDateTime showtimeDate;
        int movieId;
        int theaterId;
        try {
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
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid movie ID or theater ID format");
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            List<Showtime> showtimes = ShowtimeFileUtil.getAllShowtimes(context);
            int newId = showtimes.isEmpty() ? 1 : showtimes.get(showtimes.size() - 1).getShowtimeId() + 1;
            Showtime showtime = new Showtime(newId, showtimeDate, movieId, theaterId);
            ShowtimeFileUtil.saveShowtime(showtime, context);
            response.sendRedirect("Admin/adminLoginSuccess.jsp?success=Showtime%20created%20successfully");
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error saving showtime: " + e.getMessage());
            request.getRequestDispatcher("Admin/showtime-create.jsp").forward(request, response);
        }
    }
}