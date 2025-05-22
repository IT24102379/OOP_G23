package servlet;

import util.TheaterFileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "TheaterDeleteServlet", value = "/TheaterDeleteServlet")
public class TheaterDeleteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        // Retrieve and parse theaterId
        int theaterId;
        try {
            theaterId = Integer.parseInt(request.getParameter("theaterId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("TheaterListServlet?error=Invalid%20theater%20ID");
            return;
        }

        try {
            // Delete the theater and associated seats and showtimes
            if (TheaterFileUtil.deleteTheater(getServletContext(), theaterId)) {
                response.sendRedirect("TheaterListServlet?success=Theater%20deleted%20successfully");
            } else {
                response.sendRedirect("TheaterListServlet?error=Theater%20not%20found");
            }
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting theater: " + e.getMessage());
        }
    }
}