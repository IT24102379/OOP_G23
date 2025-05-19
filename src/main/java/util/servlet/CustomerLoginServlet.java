package servlet.customer;

import model.Movie;
import util.FileUtil;
import util.MovieFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerLoginServlet", value = "/CustomerLoginServlet")
public class CustomerLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"customer".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Customer/customer-login.jsp");
            return;
        }

        // Reload movies for the dashboard
        ServletContext context = request.getServletContext();
        List<Movie> movies = MovieFileUtil.getAllMovies(context);
        request.setAttribute("movies", movies);

        // Pass session attributes to the JSP
        request.setAttribute("userId", session.getAttribute("userId"));
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("email", session.getAttribute("email"));

        RequestDispatcher dispatcher = request.getRequestDispatcher("Customer/customerLoginSuccess.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("username");
        String password = request.getParameter("password");

        if (name == null || name.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect("Customer/customerLoginFailed.jsp?error=Username%20or%20password%20cannot%20be%20empty");
            return;
        }

        String relativePath = "/WEB-INF/Data/Customers.txt";
        ServletContext context = request.getServletContext();
        String filePath = context.getRealPath(relativePath);

        try {
            if (FileUtil.validateUser(filePath, name, password)) {
                String[] user = FileUtil.readUserFromFile(filePath, name);
                HttpSession session = request.getSession();
                session.setAttribute("userId", user[0]);
                session.setAttribute("username", user[1]);
                session.setAttribute("email", user[2]);
                session.setAttribute("userType", "customer");

                // Fetch movie list
                List<Movie> movies = MovieFileUtil.getAllMovies(context);
                request.setAttribute("movies", movies);

                request.setAttribute("userId", user[0]);
                request.setAttribute("username", user[1]);
                request.setAttribute("email", user[2]);
                RequestDispatcher dispatcher = request.getRequestDispatcher("Customer/customerLoginSuccess.jsp");
                System.out.println("Customer Login Success");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("Customer/customerLoginFailed.jsp?error=Invalid%20username%20or%20password");
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Error during login: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("Customer/customerLoginFailed.jsp");
            dispatcher.forward(request, response);
        }
    }
}