package servlet.customer;

import model.Booking;
import util.BookingFileUtil;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@WebServlet(name = "BookingListServlet", value = "/BookingListServlet")
public class BookingListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("BookingListServlet: Handling GET request");

        HttpSession session = request.getSession(false);
        if (session == null || !"customer".equals(session.getAttribute("userType"))) {
            System.out.println("BookingListServlet: Session validation failed - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/Customer/customer-login.jsp");
            return;
        }

        Object userIdObj = session.getAttribute("userId");
        if (userIdObj == null) {
            System.out.println("BookingListServlet: User ID missing - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/Customer/customer-login.jsp?error=User%20not%20logged%20in");
            return;
        }

        int customerId;
        try {
            customerId = Integer.parseInt(userIdObj.toString());
        } catch (NumberFormatException e) {
            System.out.println("BookingListServlet: Invalid user ID - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/Customer/customer-login.jsp?error=Invalid%20user%20ID");
            return;
        }

        try {
            // Generate and store CSRF token in session
            String csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
            System.out.println("BookingListServlet: Generated CSRF token - " + csrfToken);

            List<Booking> bookings = BookingFileUtil.getAllBookings(getServletContext()).stream()
                    .filter(booking -> booking.getCustomerId() == customerId)
                    .collect(Collectors.toList());
            request.setAttribute("bookings", bookings);
            System.out.println("BookingListServlet: Retrieved " + bookings.size() + " bookings for customer " + customerId);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/Customer/booking-list.jsp");
            System.out.println("BookingListServlet: Forwarding to booking-list.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println("BookingListServlet: Error processing request: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Customer/customer-login.jsp?error=Error%20loading%20bookings");
        }
    }
}