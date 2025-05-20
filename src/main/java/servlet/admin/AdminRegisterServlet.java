package servlet.admin;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

import model.Admin;
import util.AdminFileUtil;

@WebServlet(name = "AdminRegisterServlet", value = "/AdminRegisterServlet")
public class AdminRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || email == null || password == null || name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/Admin/admin-register.jsp").forward(request, response);
            return;
        }

        String relativePath = "/WEB-INF/Data/Admins.txt";
        ServletContext context = request.getServletContext();
        String filePath = context.getRealPath(relativePath);

        if (filePath == null) {
            request.setAttribute("errorMessage", "Server error: Could not resolve file path.");
            request.getRequestDispatcher("/Admin/admin-register.jsp").forward(request, response);
            return;
        }

        File file = new File(filePath);
        File directory = file.getParentFile();
        if (directory != null && !directory.exists()) {
            if (!directory.mkdirs()) {
                request.setAttribute("errorMessage", "Server error: Could not create directory.");
                request.getRequestDispatcher("/Admin/admin-register.jsp").forward(request, response);
                return;
            }
        }

        // Create the file if it doesn't exist
        if (!file.exists()) {
            try {
                file.createNewFile();
            } catch (IOException e) {
                request.setAttribute("errorMessage", "Server error: Could not create file.");
                request.getRequestDispatcher("/Admin/admin-register.jsp").forward(request, response);
                return;
            }
        }

        // Check for duplicate email
        if (AdminFileUtil.isEmailRegistered(filePath, email)) {
            request.setAttribute("errorMessage", "This email is already registered.");
            request.getRequestDispatcher("/Admin/admin-register.jsp").forward(request, response);
            return;
        }

        Admin admin = new Admin(0, name, email, password, "", "Level1");

        try {
            AdminFileUtil.saveAdmin(filePath, admin);
            response.sendRedirect("index.jsp");
        } catch (RuntimeException e) {
            request.setAttribute("errorMessage", "Error saving admin data: " + e.getMessage());
            request.getRequestDispatcher("/Admin/admin-register.jsp").forward(request, response);
        }
    }
}