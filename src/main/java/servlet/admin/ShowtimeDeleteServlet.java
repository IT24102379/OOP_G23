package servlet.admin;

import util.ShowtimeFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ShowtimeDeleteServlet", value = "/ShowtimeDeleteServlet")
public class ShowtimeDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        String showtimeIdStr = request.getParameter("showtimeId");
        if (showtimeIdStr == null || showtimeIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing showtime ID");
            return;
        }

        int showtimeId;
        try {
            showtimeId = Integer.parseInt(showtimeIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid showtime ID format");
            return;
        }

        ServletContext context = request.getServletContext();
        try {
            if (ShowtimeFileUtil.deleteShowtime(showtimeId, context)) {
                response.sendRedirect("ShowtimeListServlet?success=Showtime%20deleted%20successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Showtime not found or could not be deleted");
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error deleting showtime: " + e.getMessage());
            request.getRequestDispatcher("Admin/showtime-list.jsp").forward(request, response);
        }
    }
}