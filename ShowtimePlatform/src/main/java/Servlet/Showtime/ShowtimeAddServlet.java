package Servlet.Showtime;

import model.Movie;
import model.Seat;
import model.Showtime;
import model.Theater;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ShowtimeAddServlet", value = "/ShowtimeAddServlet")
public class ShowtimeAddServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Movie> movies = Movie.getAllMovies();
        List<Theater> theaters = Theater.getAllTheaters();

        if (movies.isEmpty()) {
            request.setAttribute("errorMessage", "No movies available. Please add movies before creating a showtime.");
        }
        if (theaters.isEmpty()) {
            request.setAttribute("errorMessage", "No theaters available. Please add theaters before creating a showtime.");
        }

        request.setAttribute("movies", movies);
        request.setAttribute("theaters", theaters);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/Showtime/addShowtime.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String movieId = request.getParameter("movieId");
            String theaterId = request.getParameter("theaterId");
            String startTimeStr = request.getParameter("startTime");

            List<Movie> movies = Movie.getAllMovies();
            List<Theater> theaters = Theater.getAllTheaters();

            if (movies.isEmpty() || theaters.isEmpty()) {
                throw new IllegalStateException("No movies or theaters available.");
            }

            Movie selectedMovie = movies.stream()
                    .filter(m -> m.getMovieId().equals(movieId))
                    .findFirst()
                    .orElse(null);
            Theater selectedTheater = theaters.stream()
                    .filter(t -> t.getTheaterId().equals(theaterId))
                    .findFirst()
                    .orElse(null);
            LocalDateTime startTime = LocalDateTime.parse(startTimeStr);

            if (selectedMovie == null || selectedTheater == null) {
                throw new IllegalArgumentException("Invalid movie or theater selected");
            }

            if (startTime.isBefore(LocalDateTime.now())) {
                throw new IllegalArgumentException("Start time must be in the future");
            }

            List<Seat> theaterSeats = new ArrayList<>();
            new Showtime(selectedMovie, selectedTheater, startTime, theaterSeats);
            response.sendRedirect(request.getContextPath() + "/");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error adding showtime: " + e.getMessage());
            doGet(request, response);
        }
    }
}