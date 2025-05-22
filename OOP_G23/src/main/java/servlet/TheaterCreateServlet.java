package servlet;

import model.Theater;
import util.TheaterFileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TheaterCreateServlet", value = "/TheaterCreateServlet")
public class TheaterCreateServlet extends HttpServlet {
    private static final int MAX_CAPACITY = 500;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/Admin/admin-login.jsp");
            return;
        }

        // Retrieve and validate parameters
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        int capacity;

        try {
            capacity = Integer.parseInt(request.getParameter("capacity"));
            if (capacity <= 0 || capacity > MAX_CAPACITY) {
                response.sendRedirect(request.getContextPath() + "/Admin/theater-create.jsp?error=Capacity%20must%20be%20between%201%20and%20" + MAX_CAPACITY);
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Admin/theater-create.jsp?error=Invalid%20capacity");
            return;
        }

        // Validate inputs
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Admin/theater-create.jsp?error=Name%20is%20required");
            return;
        }
        if (location == null || location.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Admin/theater-create.jsp?error=Location%20is%20required");
            return;
        }

        // Generate a unique theaterId
        int theaterId;
        try {
            List<Theater> theaters = TheaterFileUtil.getAllTheaters(getServletContext());
            theaterId = theaters.isEmpty() ? 1 : theaters.stream()
                    .mapToInt(Theater::getTheaterId)
                    .max()
                    .orElse(0) + 1;
        } catch (IOException e) {
            request.setAttribute("error", "Error generating theater ID: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // Create and save the theater
        Theater theater = new Theater(theaterId, name.trim(), location.trim(), capacity);
        try {
            if (TheaterFileUtil.saveTheater(getServletContext(), theater)) {
                response.sendRedirect(request.getContextPath() + "/TheaterListServlet?success=Theater%20created%20successfully");
            } else {
                throw new IOException("Failed to save theater");
            }
        } catch (IOException e) {
            request.setAttribute("error", "Error creating theater: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}