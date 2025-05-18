package ServletMovie;

import model.model.Movie;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet(name = "MovieUpdateServlet", value = "/MovieUpdateServlet")
public class MovieUpdateServlet extends HttpServlet {
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

        if (movieID == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Movie ID required");
            return;
        }

        Movie movie = Movie.findMovieByID(movieID);
        if (movie == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found");
            return;
        }

        int duration;
        try {
            duration = durationStr != null ? Integer.parseInt(durationStr) : movie.getDuration();
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid duration");
            return;
        }

        LocalDate releaseDate;
        try {
            releaseDate = releaseDateStr != null ? LocalDate.parse(releaseDateStr) : movie.getReleaseDate();
        } catch (DateTimeParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid release date format (use YYYY-MM-DD)");
            return;
        }

        movie.updateMovie(title, duration, genre, releaseDate);
        response.sendRedirect("Admin/movieUpdateSuccess.jsp");
    }
}