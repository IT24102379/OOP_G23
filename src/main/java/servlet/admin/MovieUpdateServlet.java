package servlet.admin;

import model.Movie;
import util.MovieFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.regex.Pattern;

@WebServlet(name = "MovieUpdateServlet", value = "/MovieUpdateServlet")
public class MovieUpdateServlet extends HttpServlet {

    private static final Pattern PATH_PATTERN = Pattern.compile("^/images/.*\\.(?:png|jpg|jpeg|gif)$", Pattern.CASE_INSENSITIVE);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        String movieIdStr = request.getParameter("movieId");
        if (movieIdStr == null || movieIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing movie ID");
            return;
        }

        int movieId;
        try {
            movieId = Integer.parseInt(movieIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid movie ID format");
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            Movie movie = MovieFileUtil.getMovieById(movieId, context);
            if (movie == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found");
                return;
            }
            request.setAttribute("movie", movie);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/movie-update.jsp");
            dispatcher.forward(request, response);
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error retrieving movie: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/movie-update.jsp");
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

        String movieIdStr = request.getParameter("movieId");
        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String durationStr = request.getParameter("duration");
        String imageLink = request.getParameter("imageLink");
        String releaseDateStr = request.getParameter("releaseDate");

        // Validate input parameters
        if (movieIdStr == null || movieIdStr.trim().isEmpty() || title == null || title.trim().isEmpty() ||
                genre == null || genre.trim().isEmpty() || durationStr == null || releaseDateStr == null || releaseDateStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing or empty required parameters");
            request.getRequestDispatcher("Admin/movie-update.jsp").forward(request, response);
            return;
        }

        title = title.trim();
        genre = genre.trim();
        imageLink = imageLink != null ? imageLink.trim() : "";

        int movieId;
        int duration;
        try {
            movieId = Integer.parseInt(movieIdStr);
            duration = Integer.parseInt(durationStr);
            if (duration <= 0) {
                request.setAttribute("errorMessage", "Duration must be positive");
                request.getRequestDispatcher("Admin/movie-update.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid movie ID or duration format");
            request.getRequestDispatcher("Admin/movie-update.jsp").forward(request, response);
            return;
        }

        if (!imageLink.isEmpty() && (!PATH_PATTERN.matcher(imageLink).matches() || imageLink.contains(".."))) {
            request.setAttribute("errorMessage", "Invalid image path. Must start with '/images/' and end with .png, .jpg, .jpeg, or .gif");
            request.getRequestDispatcher("Admin/movie-update.jsp").forward(request, response);
            return;
        }

        LocalDate releaseDate;
        try {
            releaseDate = LocalDate.parse(releaseDateStr);
            if (releaseDate.isAfter(LocalDate.now())) {
                request.setAttribute("errorMessage", "Release date cannot be in the future");
                request.getRequestDispatcher("Admin/movie-update.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid release date format");
            request.getRequestDispatcher("Admin/movie-update.jsp").forward(request, response);
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            Movie updatedMovie = new Movie(movieId, title, genre, duration, imageLink, releaseDate);
            if (MovieFileUtil.updateMovie(movieId, updatedMovie, context)) {
                response.sendRedirect("MovieListServlet?success=Movie%20updated%20successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found or could not be updated");
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error updating movie: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/movie-update.jsp");
            dispatcher.forward(request, response);
        }
    }
}