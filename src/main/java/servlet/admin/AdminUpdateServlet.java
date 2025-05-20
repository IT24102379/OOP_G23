package servlet.admin;

import model.Admin;
import model.User;
import util.AdminFileUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "AdminUpdateServlet", value = "/AdminUpdateServlet")
public class AdminUpdateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userType"))) {
            response.sendRedirect("Admin/admin-login.jsp");
            return;
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/admin-update.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Validate input parameters
        String exEmail = request.getParameter("previous-email");
        String exPassword = request.getParameter("previous-password");
        String newPassword = request.getParameter("password");
        String newEmail = request.getParameter("email");
        String newName = request.getParameter("username");

        if (exEmail == null || exPassword == null || newName == null || newEmail == null || newPassword == null ||
                exEmail.isEmpty() || exPassword.isEmpty() || newName.isEmpty() || newEmail.isEmpty() || newPassword.isEmpty()) {
            sendErrorResponse(response, "All fields are required.");
            return;
        }

        // Create new Admin object with updated details
        User updateUser = new Admin(newName, newPassword, newEmail);

        String relativePath = "/WEB-INF/Data/Admins.txt";
        ServletContext context = request.getServletContext();
        String filePath = context.getRealPath(relativePath);

        // Verify and update admin details
        if (updateAdminDetails(filePath, exEmail, exPassword, (Admin) updateUser)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.setAttribute("username", newName);
                session.setAttribute("email", newEmail);
            }
            DynamicallySendAdmin(request, response, newName, filePath);
        } else {
            sendErrorResponse(response, "Error updating admin details. Please check your current email and password.");
        }
    }

    private boolean updateAdminDetails(String filePath, String exEmail, String exPassword, Admin updatedAdmin) {
        List<Admin> admins = AdminFileUtil.getAllAdmins(filePath);
        boolean isUpdated = false;

        for (Admin admin : admins) {
            if (admin.getEmail().equals(exEmail) && admin.getPassword().equals(exPassword)) {
                updatedAdmin.setUserId(admin.getUserId());
                updatedAdmin.setPhoneNumber(admin.getPhoneNumber());
                updatedAdmin.setAdminLevel(admin.getAdminLevel());
                isUpdated = AdminFileUtil.updateAdmin(filePath, admin.getUserId(), updatedAdmin);
                break;
            }
        }
        return isUpdated;
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script type=\"text/javascript\">");
        out.println("alert('" + message + "');");
        out.println("window.location.href = 'Admin/admin-update.jsp';");
        out.println("</script>");
    }

    static void DynamicallySendAdmin(HttpServletRequest request, HttpServletResponse response, String newName, String filePath) throws ServletException, IOException {
        List<Admin> admins = AdminFileUtil.getAllAdmins(filePath);
        for (Admin admin : admins) {
            if (admin.getUsername().equals(newName)) {
                request.setAttribute("userId", admin.getUserId());
                request.setAttribute("username", admin.getUsername());
                request.setAttribute("email", admin.getEmail());
                RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/adminLoginSuccess.jsp");
                dispatcher.forward(request, response);
                return;
            }
        }
        // Fallback in case the admin is not found
        response.sendRedirect("Admin/admin-update.jsp");
    }
}