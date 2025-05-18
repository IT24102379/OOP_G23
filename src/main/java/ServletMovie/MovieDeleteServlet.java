package ServletMovie;

import model.model.Movie;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "MovieDeleteServlet", value = "/MovieDeleteServlet")
public class MovieDeleteServlet extends HttpServlet {
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

        if (movieID == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Movie ID required");
            return;
        }

        if (Movie.deleteMovieByID(movieID)) {
            response.sendRedirect("Admin/movieDeleteSuccess.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found");
        }
    }
}