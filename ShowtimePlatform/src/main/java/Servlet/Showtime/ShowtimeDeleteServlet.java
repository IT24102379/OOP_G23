package Servlet.Showtime;

import model.Showtime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ShowtimeDeleteServlet", value = "/ShowtimeDeleteServlet")
public class ShowtimeDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String showtimeId = request.getParameter("showtimeId");
        Showtime.deleteShowtimeById(showtimeId);
        response.sendRedirect(request.getContextPath() + "/");
    }
}