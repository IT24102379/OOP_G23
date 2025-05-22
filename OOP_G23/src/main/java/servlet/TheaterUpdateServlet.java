package servlet;

import model.Theater;
import util.TheaterFileUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "TheaterUpdateServlet", value = "/TheaterUpdateServlet")
public class TheaterUpdateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        int theaterId;
        try {
            theaterId = Integer.parseInt(request.getParameter("theaterId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("TheaterListServlet?error=Invalid%20theater%20ID");
            return;
        }

        Theater theater = TheaterFileUtil.getTheaterById(getServletContext(), theaterId);
        if (theater == null) {
            response.sendRedirect("TheaterListServlet?error=Theater%20not%20found");
            return;
        }

        request.setAttribute("theater", theater);
        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/theater-update.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        int theaterId;
        try {
            theaterId = Integer.parseInt(request.getParameter("theaterId"));
        } catch (NumberFormatException e) {
            response.sendRedirect("TheaterListServlet?error=Invalid%20theater%20ID");
            return;
        }

        String name = request.getParameter("name");
        String location = request.getParameter("location");
        int capacity;
        try {
            capacity = Integer.parseInt(request.getParameter("capacity"));
        } catch (NumberFormatException e) {
            response.sendRedirect("TheaterListServlet?error=Invalid%20capacity");
            return;
        }

        // Validate inputs
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("TheaterListServlet?error=Name%20is%20required");
            return;
        }
        if (location == null || location.trim().isEmpty()) {
            response.sendRedirect("TheaterListServlet?error=Location%20is%20required");
            return;
        }
        if (capacity <= 0) {
            response.sendRedirect("TheaterListServlet?error=Capacity%20must%20be%20positive");
            return;
        }

        // Create the updated theater object
        Theater updatedTheater = new Theater(theaterId, name, location, capacity);

        // Update the theater
        if (TheaterFileUtil.updateTheater(getServletContext(), theaterId, updatedTheater)) {
            response.sendRedirect("TheaterListServlet?success=Theater%20updated%20successfully");
        } else {
            response.sendRedirect("TheaterListServlet?error=Error%20updating%20theater");
        }
    }
}