<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Seats</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .form-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 100%;
            max-width: 400px;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        input[type="number"],
        input[type="hidden"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }

        input[type="number"]:focus,
        select:focus {
            border-color: #4CAF50;
            outline: none;
        }

        .book-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s;
        }

        .book-btn:hover {
            background-color: #45a049;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #34a853;
            text-decoration: none;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 20px;
        }

        .price-display {
            color: #4CAF50;
            font-weight: bold;
            font-size: 20px;
            margin-bottom: 15px;
            text-align: center;
            background-color: #e8f5e9;
            padding: 10px;
            border-radius: 4px;
        }

        .price-label {
            color: #555;
            font-size: 16px;
            text-align: center;
            margin-bottom: 5px;
        }

        .seat-list {
            list-style: none;
            padding: 0;
            margin: 0 0 15px 0;
        }

        .seat-list li {
            padding: 5px 0;
            color: #333;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>Book Seats</h1>
    <c:if test="${not empty param.error}">
        <p class="error-message"><c:out value="${param.error}"/></p>
        <script>
            window.location.href = "SeatViewServlet?showtimeId=${param.showtimeId}&movieId=${param.movieId}&error=${param.error}";
        </script>
    </c:if>
    <c:choose>
        <c:when test="${empty param.showtimeId or empty param.seatIds or empty param.movieId or empty param.seatNumbers or empty param.totalPrice}">
            <p class="error-message">Missing required parameters. Please select seats again.</p>
            <a href="ShowtimeViewServlet?movieId=${param.movieId}" class="back-link">Back to Showtimes</a>
        </c:when>
        <c:otherwise>
            <form action="${pageContext.request.contextPath}/BookingCreateServlet" method="post" onsubmit="return confirmBooking()">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="showtimeId" value="${param.showtimeId}">
                <input type="hidden" name="seatIds" id="seatIds" value="${param.seatIds}">
                <input type="hidden" name="movieId" value="${param.movieId}">
                <input type="hidden" name="seatNumbers" id="seatNumbers" value="${param.seatNumbers}">
                <input type="hidden" name="amount" id="amount" value="${param.totalPrice}">
                <div class="form-group">
                    <label>Selected Seats</label>
                    <ul class="seat-list" id="seat-list"></ul>
                </div>
                <div class="form-group">
                    <label class="price-label">Total Amount</label>
                    <p class="price-display" id="price-display">$0.00</p>
                </div>
                <div class="form-group">
                    <label for="paymentMethod">Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod" required>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="PayPal">PayPal</option>
                    </select>
                </div>
                <button type="submit" class="book-btn">Confirm Booking</button>
            </form>
            <a href="SeatViewServlet?showtimeId=${param.showtimeId}&movieId=${param.movieId}" class="back-link">Back to Seat Selection</a>
        </c:otherwise>
    </c:choose>
</div>
<script>
    // Get total price from URL parameter
    const totalPrice = parseFloat("${param.totalPrice}") || 0;

    // Display selected seats
    const seatNumbers = document.getElementById('seatNumbers').value.split(',');
    const seatList = document.getElementById('seat-list');

    seatNumbers.forEach(seatNumber => {
        if (seatNumber.trim()) {
            const li = document.createElement('li');
            li.textContent = `Seat ${seatNumber}`;
            seatList.appendChild(li);
        }
    });

    // Display total price
    document.getElementById('price-display').textContent = `$${totalPrice.toFixed(2)}`;
    document.getElementById('amount').value = totalPrice.toFixed(2);
    console.log(`Displayed total amount to customer: $${totalPrice.toFixed(2)}`);

    function confirmBooking() {
        const amount = document.getElementById('amount').value;
        const seatCount = seatNumbers.filter(sn => sn.trim()).length;
        const confirmed = confirm(`Please confirm your booking.\nSeats: ${seatNumbers.join(', ')}\nTotal Amount: $${amount}\nProceed with payment for ${seatCount} seat${seatCount > 1 ? 's' : ''}?`);
        if (confirmed) {
            console.log(`Customer confirmed booking for ${seatCount} seats with total amount: $${amount}`);
            debugFormSubmission();
            return true;
        }
        return false;
    }

    function debugFormSubmission() {
        console.log("Submitting form from seate-book.jsp...");
        console.log("csrfToken: " + document.querySelector('input[name="csrfToken"]').value);
        console.log("showtimeId: " + document.querySelector('input[name="showtimeId"]').value);
        console.log("seatIds: " + document.querySelector('input[name="seatIds"]').value);
        console.log("movieId: " + document.querySelector('input[name="movieId"]').value);
        console.log("seatNumbers: " + document.querySelector('input[name="seatNumbers"]').value);
        console.log("amount: " + document.querySelector('input[name="amount"]').value);
        console.log("paymentMethod: " + document.querySelector('select[name="paymentMethod"]').value);
    }
</script>
</body>
</html>