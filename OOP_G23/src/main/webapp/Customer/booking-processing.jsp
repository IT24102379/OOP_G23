<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing Booking - MovieMagnet</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(180deg, #1a1a1a 0%, #000000 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-x: hidden;
        }

        .container {
            background: rgba(26, 26, 26, 0.9);
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.5);
            padding: 40px;
            width: 100%;
            max-width: 450px;
            text-align: center;
            color: #ffffff;
            animation: fadeIn 0.5s ease;
            border: 3px solid #ffeb3b;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h1 {
            color: #ffeb3b;
            font-size: 28px;
            margin-bottom: 25px;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(255, 235, 59, 0.4);
        }

        .spinner {
            border: 5px solid rgba(255, 255, 255, 0.2);
            border-top: 5px solid #ffeb3b;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1.2s linear infinite;
            margin: 0 auto 25px;
            box-shadow: 0 0 15px rgba(255, 235, 59, 0.7);
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .progress-text {
            color: rgba(255, 255, 255, 0.9);
            font-size: 18px;
            margin-bottom: 20px;
        }

        .progress-indicator {
            color: #ffeb3b;
            font-weight: bold;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .container {
                padding: 30px;
                max-width: 350px;
            }
            h1 {
                font-size: 24px;
            }
            .spinner {
                width: 40px;
                height: 40px;
            }
            .progress-text {
                font-size: 16px;
            }
        }

        @media (max-width: 480px) {
            .container {
                padding: 20px;
                max-width: 300px;
            }
            h1 {
                font-size: 20px;
            }
            .spinner {
                width: 35px;
                height: 35px;
            }
            .progress-text {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Processing Your Booking</h1>
    <div class="spinner"></div>
    <div class="progress-text">
        Please wait while we process your request...
        <span class="progress-indicator">Estimated time: ~5 seconds</span>
    </div>
</div>
<script>
    function checkBookingResult() {
        <%
            String bookingResult = (String) session.getAttribute("bookingResult");
            if (bookingResult != null) {
                session.removeAttribute("bookingResult"); // Clean up the session attribute
        %>
        window.location.href = "<%= response.encodeRedirectURL(request.getContextPath() + "/BookingListServlet?" + bookingResult) %>";
        <% } else { %>
        setTimeout(checkBookingResult, 1000); // Check again after 1 second
        <% } %>
    }

    // Start checking for the booking result immediately
    setTimeout(checkBookingResult, 1000);

    // Fallback redirect after 5 seconds if no result is found
    setTimeout(() => {
        window.location.href = "<%= response.encodeRedirectURL(request.getContextPath() + "/BookingListServlet?error=Processing%20timeout") %>";
    }, 5000);
</script>
</body>
</html>