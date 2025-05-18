package ServletMovie;

import model.model.Movie;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "MovieListServlet", value = "/MovieListServlet")
public class MovieListServlet extends HttpServlet {
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
        Movie.sortMoviesByReleaseDate(); // Sort movies by release date
        request.setAttribute("movies", Movie.getAllMovies());
        RequestDispatcher dispatcher = request.getRequestDispatcher("Customer/movieList.jsp");
        dispatcher.forward(request, response);
    }
}