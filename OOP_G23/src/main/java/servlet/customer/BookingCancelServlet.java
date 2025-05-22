package servlet.customer;

import model.CancelRequest;
import util.BookingQueueProcessor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "BookingCancelServlet", value = "/BookingCancelServlet")
public class BookingCancelServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"customer".equals(session.getAttribute("userType"))) {
            System.out.println("Session validation failed: No session or userType is not customer");
            response.sendRedirect(request.getContextPath() + "/Customer/customer-login.jsp");
            return;
        }

        String csrfToken = request.getParameter("csrfToken");
        if (!validateCsrfToken(session, csrfToken)) {
            System.out.println("CSRF token validation failed: Provided token = [" + csrfToken + "]");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        int bookingId;
        try {
            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Booking ID is missing");
            }
            bookingId = Integer.parseInt(bookingIdStr.trim());
        } catch (IllegalArgumentException e) {
            System.out.println("Booking ID validation error: " + e.getMessage());
            String redirectUrl = response.encodeRedirectURL(request.getContextPath() + "/BookingListServlet?error=Invalid%20booking%20ID");
            response.sendRedirect(redirectUrl);
            return;
        }

        String contextPath = request.getContextPath();
        // Store the session in the ServletContext for retrieval by BookingQueueProcessor
        getServletContext().setAttribute("session_" + session.getId(), session);

        CancelRequest cancelRequest = new CancelRequest(bookingId, session.getId(), contextPath);
        BookingQueueProcessor processor = BookingQueueProcessor.getInstance(getServletContext());
        processor.addCancelRequest(cancelRequest);

        response.sendRedirect(contextPath + "/Customer/booking-processing.jsp?sessionId=" + session.getId());
    }

    private boolean validateCsrfToken(HttpSession session, String token) {
        String sessionToken = (String) session.getAttribute("csrfToken");
        System.out.println("CSRF token validation - Provided: [" + token + "], Expected: [" + sessionToken + "]");
        return token != null && !token.trim().isEmpty() && token.equals(sessionToken);
    }
}