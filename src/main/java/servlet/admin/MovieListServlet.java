package servlet.admin;

import model.Movie;
import util.MovieFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "MovieListServlet", value = "/MovieListServlet")
public class MovieListServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MovieListServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("Starting doGet in MovieListServlet");

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            LOGGER.warning("Unauthorized access attempt; redirecting to admin-login.jsp");
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            List<Movie> movies = MovieFileUtil.getAllMovies(context);
            LOGGER.info("Retrieved " + (movies != null ? movies.size() : 0) + " movies for admin");
            for (Movie movie : movies) {
                LOGGER.fine("Movie in admin list: " + movie.getTitle() + " (Release Date: " + (movie.getReleaseDate() != null ? movie.getReleaseDate().toString() : "null") + ")");
            }

            request.setAttribute("movies", movies);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/movie-list.jsp");
            dispatcher.forward(request, response);
        } catch (IOException e) {
            String errorMessage = "Error retrieving movie list: " + e.getMessage();
            LOGGER.severe(errorMessage);
            request.setAttribute("errorMessage", errorMessage);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/movie-list.jsp");
            dispatcher.forward(request, response);
        }
    }
}