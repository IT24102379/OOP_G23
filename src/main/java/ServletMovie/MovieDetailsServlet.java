package ServletMovie;

import model.model.Movie;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "MovieDetailsServlet", value = "/MovieDetailsServlet")
public class MovieDetailsServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        String relativePath = "/WEB-INF/Data/Movies.txt";
        String filePath = getServletContext().getRealPath(relativePath);
        Movie.setFilePath(filePath);
        Movie.loadFromFile();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String movieID = request.getParameter("movieID");
        if (movieID == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Movie ID required");
            return;
        }

        Movie movie = Movie.findMovieByID(movieID);
        if (movie == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found");
            return;
        }

        // Add some sample showtimes (since they aren't in the file)
        movie.addShowtime(LocalDateTime.now().withHour(10).withMinute(0)); // 10:00 today
        movie.addShowtime(LocalDateTime.now().withHour(14).withMinute(0)); // 14:00 today
        movie.addShowtime(LocalDateTime.now().withHour(18).withMinute(0)); // 18:00 today

        request.setAttribute("movie", movie);
        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/movieDetails.jsp");
        dispatcher.forward(request, response);
    }
}