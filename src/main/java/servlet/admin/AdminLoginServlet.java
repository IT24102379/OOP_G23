package servlet.admin;

import model.Admin; // Corrected import from model package
import util.AdminFileUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "AdminLoginServlet", value = "/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("adminUsername");
        String password = request.getParameter("adminPassword");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
            return;
        }

        // Input sanitization to prevent CSV injection
        if (username.contains(",") || password.contains(",")) {
            request.setAttribute("errorMessage", "Invalid characters in username or password.");
            request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
            return;
        }

        String relativePath = "/WEB-INF/Data/Admins.txt";
        ServletContext context = request.getServletContext();
        String filePath = context.getRealPath(relativePath);

        if (filePath == null) {
            System.err.println("ServletContext.getRealPath returned null, using fallback path.");
            filePath = System.getProperty("java.io.tmpdir") + File.separator + "MovieMagnet" + File.separator + "Admins.txt";
            File fallbackFile = new File(filePath);
            File fallbackDir = fallbackFile.getParentFile();
            if (!fallbackDir.exists() && !fallbackDir.mkdirs()) {
                request.setAttribute("errorMessage", "Server error: Could not create fallback directory.");
                request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
                return;
            }
        }

        File file = new File(filePath);
        File directory = file.getParentFile();
        if (directory != null && !directory.exists()) {
            if (!directory.mkdirs()) {
                System.err.println("Failed to create directory: " + directory.getAbsolutePath());
                request.setAttribute("errorMessage", "Server error: Could not create directory.");
                request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
                return;
            }
        }

        if (!file.exists()) {
            try {
                file.createNewFile();
                System.err.println("Created new Admins.txt file at: " + filePath);
            } catch (IOException e) {
                System.err.println("Failed to create Admins.txt file: " + e.getMessage());
                request.setAttribute("errorMessage", "Server error: Could not create file.");
                request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
                return;
            }
        }

        // Validate admin credentials
        boolean isValid = false;
        try {
            System.err.println("Attempting to validate admin credentials for username: " + username);
            for (model.Admin admin : AdminFileUtil.getAllAdmins(filePath)) { // Updated to model.Admin
                System.err.println("Checking admin: " + admin.getUsername());
                if (admin.getUsername().equals(username) && admin.getPassword().equals(password)) {
                    isValid = true;
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", admin.getUserId());
                    session.setAttribute("username", admin.getUsername());
                    session.setAttribute("email", admin.getEmail());
                    session.setAttribute("userType", "admin");
                    request.setAttribute("userId", admin.getUserId());
                    request.setAttribute("username", admin.getUsername());
                    request.setAttribute("email", admin.getEmail());
                    System.err.println("Admin credentials validated successfully.");
                    break;
                }
            }
        } catch (RuntimeException e) {
            System.err.println("Error during credential validation: " + e.getMessage());
            request.setAttribute("errorMessage", "Error validating credentials: " + e.getMessage());
            request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
            return;
        }

        if (isValid) {
            System.err.println("Forwarding to adminLoginSuccess.jsp for username: " + username);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/adminLoginSuccess.jsp");
            dispatcher.forward(request, response);
        } else {
            System.err.println("Invalid credentials for username: " + username);
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("/Admin/adminLoginFailed.jsp").forward(request, response);
        }
    }
}