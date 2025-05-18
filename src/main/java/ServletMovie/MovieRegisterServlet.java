package ServletMovie;

import model.model.Movie;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet(name = "MovieRegisterServlet", value = "/MovieRegisterServlet")
public class MovieRegisterServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        String relativePath = "/WEB-INF/Data/Movies.txt";
        String filePath = getServletContext().getRealPath(relativePath);
        Movie.setFilePath(filePath);
        Movie.loadFromFile();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String movieID = request.getParameter("movieID");
        String title = request.getParameter("title");
        String durationStr = request.getParameter("duration");
        String genre = request.getParameter("genre");
        String releaseDateStr = request.getParameter("releaseDate");

        if (movieID == null || title == null || durationStr == null || genre == null || releaseDateStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        int duration;
        try {
            duration = Integer.parseInt(durationStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid duration");
            return;
        }

        LocalDate releaseDate;
        try {
            releaseDate = LocalDate.parse(releaseDateStr); // Expected format: YYYY-MM-DD
        } catch (DateTimeParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid release date format (use YYYY-MM-DD)");
            return;
        }

        new Movie(movieID, title, duration, genre, releaseDate);
        response.sendRedirect("Admin/movieRegisterSuccess.jsp");
    }
}