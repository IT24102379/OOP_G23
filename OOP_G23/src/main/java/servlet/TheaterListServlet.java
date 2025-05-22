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
import java.util.List;

@WebServlet(name = "TheaterListServlet", value = "/TheaterListServlet")
public class TheaterListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }

        try {
            List<Theater> theaters = TheaterFileUtil.getAllTheaters(getServletContext());
            request.setAttribute("theaters", theaters);

            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/theater-list.jsp");
            dispatcher.forward(request, response);
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving theaters: " + e.getMessage());
        }
    }
}