package servlet.admin;

import util.MovieFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "MovieDeleteServlet", value = "/MovieDeleteServlet")
public class MovieDeleteServlet extends HttpServlet {
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
            if (MovieFileUtil.deleteMovie(movieId, context)) {
                response.sendRedirect("MovieListServlet?success=Movie%20deleted%20successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found or could not be deleted");
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error deleting movie: " + e.getMessage());
            request.getRequestDispatcher("Admin/movie-list.jsp").forward(request, response);
        }
    }
}