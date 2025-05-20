package servlet.admin;

import model.Showtime;
import util.ShowtimeFileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShowtimeListServlet", value = "/ShowtimeListServlet")
public class ShowtimeListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is an admin
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            // Retrieve all showtimes using ShowtimeFileUtil
            List<Showtime> showtimes = ShowtimeFileUtil.getAllShowtimes(getServletContext());
            // Set the showtimes list as a request attribute
            request.setAttribute("showtimes", showtimes);
            // Forward to the JSP page for display
            request.getRequestDispatcher("/Admin/showtime-list.jsp").forward(request, response);
        } catch (IOException e) {
            // Handle potential file access errors
            System.err.println("Error retrieving showtimes: " + e.getMessage());
            request.setAttribute("errorMessage", "Error retrieving showtimes: " + e.getMessage());
            request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
        }
    }
}