package servlet.admin;

import model.Movie;
import util.MovieFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.regex.Pattern;

@WebServlet(name = "MovieCreateServlet", value = "/MovieCreateServlet")
public class MovieCreateServlet extends HttpServlet {

    private static final Pattern PATH_PATTERN = Pattern.compile("^/images/.*\\.(?:png|jpg|jpeg|gif)$", Pattern.CASE_INSENSITIVE);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String durationStr = request.getParameter("duration");
        String imageLink = request.getParameter("imageLink");
        String releaseDateStr = request.getParameter("releaseDate");

        // Validate input parameters
        if (title == null || title.trim().isEmpty() || genre == null || genre.trim().isEmpty() || durationStr == null || releaseDateStr == null || releaseDateStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Missing or empty required parameters");
            request.getRequestDispatcher("/Admin/movie-create.jsp").forward(request, response);
            return;
        }

        title = title.trim();
        genre = genre.trim();
        imageLink = imageLink != null ? imageLink.trim() : "";

        int duration;
        try {
            duration = Integer.parseInt(durationStr);
            if (duration <= 0) {
                request.setAttribute("errorMessage", "Duration must be positive");
                request.getRequestDispatcher("/Admin/movie-create.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid duration format");
            request.getRequestDispatcher("/Admin/movie-create.jsp").forward(request, response);
            return;
        }

        if (!imageLink.isEmpty() && (!PATH_PATTERN.matcher(imageLink).matches() || imageLink.contains(".."))) {
            request.setAttribute("errorMessage", "Invalid image path. Must start with '/images/' and end with .png, .jpg, .jpeg, or .gif");
            request.getRequestDispatcher("/Admin/movie-create.jsp").forward(request, response);
            return;
        }

        LocalDate releaseDate;
        try {
            releaseDate = LocalDate.parse(releaseDateStr);
            if (releaseDate.isAfter(LocalDate.now())) {
                request.setAttribute("errorMessage", "Release date cannot be in the future");
                request.getRequestDispatcher("/Admin/movie-create.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Invalid release date format");
            request.getRequestDispatcher("/Admin/movie-create.jsp").forward(request, response);
            return;
        }

        ServletContext context = request.getServletContext();

        try {
            Movie movie = new Movie(0, title, genre, duration, imageLink, releaseDate); // Use 0 as a placeholder
            MovieFileUtil.saveMovie(movie, context);
            response.sendRedirect("Admin/adminLoginSuccess.jsp?success=Movie%20created%20successfully");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error saving movie: " + e.getMessage());
            request.getRequestDispatcher("/Admin/movie-create.jsp").forward(request, response);
        }
    }
}