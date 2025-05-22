<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Bookings</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
      background: linear-gradient(135deg, #1a237e, #0d0d1a);
      display: flex;
      flex-direction: column;
      align-items: center;
      min-height: 100vh;
      color: #e0e0e0;
    }

    .container {
      background-color: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(5px);
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
      width: 100%;
      max-width: 950px;
      animation: fadeIn 0.5s ease-in;
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }

    h1 {
      color: #4CAF50;
      text-align: center;
      margin-bottom: 25px;
      font-size: 2rem;
      font-weight: 700;
      text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
    }

    .success-message {
      color: #27ae60;
      background-color: rgba(39, 174, 96, 0.1);
      padding: 12px 20px;
      border-radius: 8px;
      text-align: center;
      margin-bottom: 20px;
      font-weight: 500;
      border-left: 4px solid #27ae60;
      position: relative;
    }

    .success-message::before {
      content: "✅";
      margin-right: 10px;
    }

    .error-message {
      color: #ff6b6b;
      background-color: rgba(255, 107, 107, 0.1);
      padding: 12px 20px;
      border-radius: 8px;
      text-align: center;
      margin-bottom: 20px;
      font-weight: 500;
      border-left: 4px solid #ff6b6b;
      position: relative;
    }

    .error-message::before {
      content: "⚠";
      margin-right: 10px;
    }

    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      margin-top: 20px;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    }

    th, td {
      padding: 12px 18px;
      text-align: left;
      font-size: 0.95rem;
      transition: background-color 0.3s ease;
    }

    th {
      background: linear-gradient(135deg, #4CAF50, #3b9c43);
      color: white;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    td {
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      background-color: rgba(255, 255, 255, 0.05);
    }

    tr:last-child td {
      border-bottom: none;
    }

    tr:hover td {
      background-color: rgba(255, 255, 255, 0.15);
    }

    .action-btn {
      display: inline-block;
      padding: 8px 16px;
      background-color: #e74c3c;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 500;
      transition: background-color 0.3s, transform 0.1s;
      outline: none;
    }

    .action-btn:hover, .action-btn:focus {
      background-color: #c0392b;
      transform: translateY(-1px);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
    }

    .action-btn:focus {
      outline: 2px solid #ffffff;
      outline-offset: 2px;
    }

    .back-link {
      display: block;
      margin-top: 25px;
      color: #4CAF50;
      text-decoration: none;
      text-align: center;
      font-size: 1rem;
      font-weight: 500;
      transition: color 0.3s ease;
      padding: 8px 0;
    }

    .back-link:hover, .back-link:focus {
      color: #34a853;
      text-decoration: underline;
    }

    .back-link:focus {
      outline: 2px solid #ffffff;
      outline-offset: 2px;
      border-radius: 4px;
    }

    @media (max-width: 768px) {
      .container {
        padding: 20px;
      }

      h1 {
        font-size: 1.5rem;
      }

      th, td {
        padding: 10px 14px;
        font-size: 0.85rem;
      }

      .action-btn {
        padding: 6px 12px;
        font-size: 0.85rem;
      }
    }

    @media (max-width: 480px) {
      h1 {
        font-size: 1.2rem;
      }

      th, td {
        padding: 8px 10px;
        font-size: 0.8rem;
      }

      .action-btn {
        padding: 5px 10px;
        font-size: 0.8rem;
      }
    }
  </style>
</head>
<body>
<div class="container" role="main" aria-label="Your Booking List">
  <h1>My Bookings</h1>
  <c:if test="${not empty param.success}">
    <p class="success-message" role="alert"><c:out value="${param.success}"/></p>
  </c:if>
  <c:if test="${not empty param.error}">
    <p class="error-message" role="alert"><c:out value="${param.error}"/></p>
  </c:if>
  <table>
    <tr>
      <th>Booking ID</th>
      <th>Showtime ID</th>
      <th>Seat ID</th>
      <th>Booking Date</th>
      <th>Action</th>
    </tr>
    <c:forEach var="booking" items="${bookings}">
      <tr>
        <td><c:out value="${booking.bookingId}"/></td>
        <td><c:out value="${booking.showtimeId}"/></td>
        <td><c:out value="${booking.seatId}"/></td>
        <td><c:out value="${booking.bookingDate}"/></td>
        <td>
          <c:if test="${not empty sessionScope.csrfToken}">
            <form action="${pageContext.request.contextPath}/BookingCancelServlet" method="post" style="display:inline;">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
              <input type="hidden" name="bookingId" value="${booking.bookingId}">
              <button type="submit" class="action-btn" onclick="return confirm('Are you sure?')">Cancel</button>
            </form>
          </c:if>
          <c:if test="${empty sessionScope.csrfToken}">
            <p class="error-message" role="alert">Error: CSRF token missing. Please refresh the page.</p>
          </c:if>
        </td>
      </tr>
    </c:forEach>
  </table>
  <a href="${pageContext.request.contextPath}/CustomerLoginServlet" class="back-link" aria-label="Back to Dashboard">Back to Dashboard</a>
</div>
</body>
</html>