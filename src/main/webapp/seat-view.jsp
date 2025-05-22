<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Select Seat - MovieMagnet</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
  <style>
    body {
      margin: 0;
      padding: 0;
      min-height: 100vh;
      overflow-x: hidden;
      font-family: 'Arial', sans-serif;
      background: linear-gradient(180deg, #1a1a1a 0%, #000000 100%);
      color: white;
      font-size: 18px;
    }

    /* Header Styles */
    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px 50px;
      background: rgba(0, 0, 0, 0.9);
      position: fixed;
      width: 100%;
      top: 0;
      z-index: 1000;
      border-bottom: 3px solid #ffeb3b;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
      box-sizing: border-box;
      transition: background 0.3s ease;
    }

    header:hover {
      background: rgba(0, 0, 0, 0.95);
    }

    .logo {
      display: flex;
      flex-direction: column;
      font-size: 40px;
      font-weight: bold;
      color: white;
      text-transform: uppercase;
      transition: transform 0.3s ease, color 0.3s ease;
    }

    .logo span {
      color: #ffeb3b;
      font-size: 26px;
      margin-top: 5px;
      transition: color 0.3s ease;
    }

    .logo:hover {
      transform: scale(1.1);
      color: #ffd700;
    }

    .logo:hover span {
      color: #ffca28;
    }

    nav ul {
      list-style: none;
      display: flex;
      align-items: center;
      margin: 0;
      gap: 25px;
    }

    nav ul li {
      margin: 0;
      position: relative;
    }

    nav ul li a {
      text-decoration: none;
      color: #ddd;
      font-size: 24px;
      font-weight: 600;
      text-transform: uppercase;
      padding: 5px 10px;
      transition: color 0.3s ease, transform 0.3s ease, background 0.3s ease;
      border-radius: 5px;
    }

    nav ul li a:hover, nav ul li a.active {
      color: #ffeb3b;
      transform: translateY(-3px);
      background: rgba(255, 235, 59, 0.2);
    }

    .login-link {
      margin-left: auto;
      margin-right: 20px;
      padding: 15px 35px;
      background: linear-gradient(45deg, #ffeb3b, #ffd700);
      border: none;
      border-radius: 30px;
      text-decoration: none;
      color: #1a1a1a;
      font-size: 24px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 12px;
      transition: all 0.3s ease, box-shadow 0.3s ease;
      box-shadow: 0 6px 20px rgba(255, 235, 59, 0.7);
      position: relative;
      overflow: hidden;
      z-index: 1;
    }

    .login-link i {
      font-size: 26px;
    }

    .login-link:hover {
      background: linear-gradient(45deg, #ffd700, #ffca28);
      transform: translateY(-4px);
      box-shadow: 0 10px 30px rgba(255, 235, 59, 0.9);
      color: #1a1a1a;
    }

    .login-link::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.5), transparent);
      transition: 0.6s;
    }

    .login-link:hover::before {
      left: 100%;
    }

    /* Modal Styles */
    .modal {
      display: none;
      position: fixed;
      z-index: 1001;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.8);
    }

    .modal-content {
      background: linear-gradient(135deg, rgba(26, 26, 26, 0.95), rgba(0, 0, 0, 0.95));
      margin: 5% auto;
      padding: 50px;
      border-radius: 20px;
      width: 90%;
      max-width: 600px;
      text-align: center;
      color: white;
      position: relative;
      animation: slideIn 0.5s ease;
      border: 3px solid #ffeb3b;
    }

    .modal-content h2 {
      font-size: 40px;
      margin-bottom: 30px;
      color: #ffeb3b;
      text-transform: uppercase;
      text-shadow: 2px 2px 8px rgba(255, 235, 59, 0.4);
    }

    .tabs {
      display: flex;
      justify-content: center;
      margin-bottom: 30px;
    }

    .tab-btn {
      flex: 1;
      padding: 15px;
      background: rgba(255, 255, 255, 0.1);
      border: none;
      color: white;
      font-size: 20px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      border-bottom: 3px solid transparent;
    }

    .tab-btn.active {
      background: rgba(255, 235, 59, 0.2);
      border-bottom: 3px solid #ffeb3b;
      color: #ffeb3b;
    }

    .tab-btn:hover {
      background: rgba(255, 235, 59, 0.3);
    }

    .tab-content {
      display: none;
    }

    .tab-content.active {
      display: block;
    }

    .modal-content .form-group {
      margin-bottom: 20px;
      text-align: left;
    }

    .modal-content label {
      display: block;
      margin-bottom: 8px;
      color: rgba(255, 255, 255, 0.9);
      font-weight: 600;
      font-size: 24px;
    }

    .modal-content input,
    .modal-content select {
      width: 100%;
      padding: 12px;
      border: 1px solid rgba(255, 255, 255, 0.2);
      background: rgba(255, 255, 255, 0.15);
      border-radius: 8px;
      font-size: 20px;
      color: #ffffff;
      transition: background 0.3s, border-color 0.3s;
    }

    .modal-content input:focus,
    .modal-content select:focus {
      outline: none;
      background: rgba(255, 255, 255, 0.25);
      border-color: #ffeb3b;
    }

    .modal-content .submit-btn {
      width: 100%;
      padding: 15px;
      background: linear-gradient(45deg, #ffeb3b, #ffd700);
      color: #1a1a1a;
      border: none;
      border-radius: 8px;
      font-size: 22px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .modal-content .submit-btn:hover {
      background: linear-gradient(45deg, #ffd700, #ffca28);
      transform: translateY(-3px);
      box-shadow: 0 6px 20px rgba(255, 235, 59, 0.6);
    }

    .modal-content .submit-btn::after {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
      transition: 0.5s;
    }

    .modal-content .submit-btn:hover::after {
      left: 100%;
    }

    .modal-content .switch-link {
      display: block;
      margin-top: 20px;
      color: #ffeb3b;
      text-decoration: none;
      font-size: 20px;
      transition: color 0.3s;
    }

    .modal-content .switch-link:hover {
      color: #ffd700;
    }

    .close {
      position: absolute;
      top: 20px;
      right: 25px;
      font-size: 36px;
      cursor: pointer;
      color: #ccc;
      transition: color 0.3s, transform 0.3s;
    }

    .close:hover {
      color: #ffeb3b;
      transform: rotate(90deg);
    }

    /* Booking Modal Specific Styles */
    #bookingModal .modal-content {
      max-width: 500px;
    }

    #bookingModal .seat-list {
      list-style: none;
      padding: 0;
      margin: 0 0 15px 0;
      text-align: left;
    }

    #bookingModal .seat-list li {
      padding: 5px 0;
      color: rgba(255, 255, 255, 0.9);
      font-size: 18px;
    }

    #bookingModal .price-label {
      color: rgba(255, 255, 255, 0.9);
      font-size: 16px;
      text-align: center;
      margin-bottom: 5px;
    }

    #bookingModal .price-display {
      color: #ffeb3b;
      font-weight: bold;
      font-size: 20px;
      margin-bottom: 15px;
      text-align: center;
      background-color: rgba(255, 235, 59, 0.2);
      padding: 10px;
      border-radius: 8px;
    }

    /* Payment Method Section Styling */
    #bookingModal .form-group.payment-method-section {
      background-color: #000000; /* Pure black background for the section */
      padding: 15px;
      border-radius: 8px;
      margin-bottom: 20px;
    }

    #bookingModal .form-group.payment-method-section label {
      color: #ffffff; /* White text for the label */
    }

    #bookingModal .form-group.payment-method-section select {
      background: #000000; /* Pure black background for the dropdown */
      color: #ffffff; /* White text for the dropdown */
      border: 1px solid #ffeb3b; /* Yellow border to match theme */
    }

    #bookingModal .form-group.payment-method-section select option {
      background: #000000; /* Black background for dropdown options */
      color: #ffffff; /* White text for dropdown options */
    }

    #bookingModal .form-group.payment-method-section select:focus {
      background: rgba(255, 235, 59, 0.1); /* Slightly lighter background on focus */
      border-color: #ffeb3b; /* Yellow border on focus */
      color: #ffffff; /* Ensure text remains white on focus */
    }

    /* Main Content Styles */
    .container {
      max-width: 1200px;
      margin: 150px auto 50px;
      padding: 30px;
      background: rgba(26, 26, 26, 0.9);
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.5);
      text-align: center;
    }

    h1 {
      font-size: 40px;
      color: #ffeb3b;
      text-transform: uppercase;
      margin-bottom: 30px;
      text-shadow: 2px 2px 8px rgba(255, 235, 59, 0.4);
    }

    .error-message {
      color: #ff4d4d;
      font-size: 20px;
      margin-bottom: 20px;
      text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.5);
      background-color: rgba(255, 107, 107, 0.1);
      padding: 12px 20px;
      border-radius: 8px;
      border-left: 4px solid #ff4d4d;
      position: relative;
    }

    .error-message::before {
      content: "⚠";
      margin-right: 10px;
    }

    .no-seats {
      font-size: 24px;
      color: rgba(255, 255, 255, 0.7);
      margin-top: 30px;
      text-shadow: 1px 1px 5px rgba(0, 0, 0, 0.5);
      background-color: rgba(176, 190, 197, 0.1);
      padding: 15px;
      border-radius: 8px;
      position: relative;
    }

    .no-seats::before {
      content: "🎬";
      margin-right: 10px;
    }

    .seat-legend {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-bottom: 20px;
    }

    .legend-item {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 16px;
    }

    .legend-item div {
      width: 20px;
      height: 20px;
      border-radius: 4px;
    }

    .legend-item .available {
      background-color: #4CAF50;
    }

    .legend-item .booked {
      background-color: #888;
    }

    .legend-item .selected {
      background-color: #ffeb3b;
    }

    .screen {
      background: linear-gradient(45deg, #ffeb3b, #ffd700);
      color: #1a1a1a;
      text-align: center;
      padding: 10px;
      border-radius: 8px;
      margin-bottom: 20px;
      font-weight: 600;
      font-size: 20px;
    }

    .seating-area {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(40px, 1fr));
      gap: 10px;
      margin: 20px 0;
      padding: 10px;
      border-radius: 8px;
      background-color: rgba(0, 0, 0, 0.2);
    }

    .seat {
      width: 40px;
      height: 40px;
      background-color: #4CAF50;
      border-radius: 8px;
      display: flex;
      justify-content: center;
      align-items: center;
      font-size: 14px;
      cursor: pointer;
      transition: background-color 0.3s, transform 0.2s ease, box-shadow 0.3s;
      position: relative;
      overflow: hidden;
    }

    .seat.booked {
      background-color: #888;
      cursor: not-allowed;
    }

    .seat.selected {
      background-color: #ffeb3b;
      color: #1a1a1a;
      box-shadow: 0 0 10px rgba(255, 235, 59, 0.7);
    }

    .seat:hover:not(.booked),
    .seat:focus:not(.booked) {
      transform: scale(1.1);
      background-color: #34a853;
      box-shadow: 0 4px 15px rgba(52, 168, 83, 0.5);
    }

    .seat::after {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
      transition: 0.5s;
    }

    .seat:hover:not(.booked)::after {
      left: 100%;
    }

    .seat:focus {
      outline: 2px solid #ffffff;
      outline-offset: 2px;
    }

    .selected-seats, .total-price {
      text-align: center;
      margin: 20px 0;
      font-size: 18px;
      color: rgba(255, 255, 255, 0.9);
    }

    .action-btn {
      display: inline-block;
      padding: 10px 20px;
      background: linear-gradient(45deg, #ffeb3b, #ffd700);
      color: #1a1a1a;
      text-decoration: none;
      border: none;
      border-radius: 8px;
      font-size: 18px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 4px 15px rgba(255, 235, 59, 0.4);
      position: relative;
      overflow: hidden;
    }

    .action-btn:disabled {
      background: #888;
      cursor: not-allowed;
      box-shadow: none;
    }

    .action-btn:hover:not(:disabled),
    .action-btn:focus:not(:disabled) {
      background: linear-gradient(45deg, #ffd700, #ffca28);
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(255, 235, 59, 0.6);
    }

    .action-btn::after {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
      transition: 0.5s;
    }

    .action-btn:hover::after {
      left: 100%;
    }

    .action-btn:focus {
      outline: 2px solid #ffffff;
      outline-offset: 2px;
    }

    .back-link {
      display: inline-block;
      margin: 30px 0;
      padding: 12px 30px;
      background: rgba(255, 235, 59, 0.2);
      color: #ffeb3b;
      text-decoration: none;
      border-radius: 8px;
      font-size: 20px;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .back-link:hover {
      background: rgba(255, 235, 59, 0.3);
      transform: translateY(-2px);
      box-shadow: 0 4px 15px rgba(255, 235, 59, 0.4);
    }

    .back-link:focus {
      outline: 2px solid #ffffff;
      outline-offset: 2px;
      border-radius: 4px;
    }

    /* Footer Styles */
    footer {
      background: linear-gradient(180deg, rgba(51, 51, 51, 0.9), rgba(0, 0, 0, 0.9)), url('${pageContext.request.contextPath}/img/footer-bg.jpg') center/cover no-repeat;
      color: white;
      padding: 50px 20px;
      text-align: center;
      font-family: Arial, sans-serif;
      font-size: 18px;
      position: relative;
      margin-top: auto;
    }

    .footer-content {
      display: flex;
      justify-content: space-around;
      flex-wrap: wrap;
      gap: 20px;
      max-width: 1200px;
      margin: 0 auto 30px;
    }

    .footer-section {
      flex: 1;
      min-width: 250px;
      text-align: left;
    }

    .footer-section h3 {
      font-size: 24px;
      color: #ffeb3b;
      margin-bottom: 20px;
      text-transform: uppercase;
    }

    .footer-section p, .footer-section a {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.8);
      margin: 5px 0;
      text-decoration: none;
      transition: color 0.3s ease;
    }

    .footer-section a:hover {
      color: #ffeb3b;
    }

    .footer-section.social .social-icons {
      display: flex;
      gap: 15px;
      margin-top: 10px;
    }

    .footer-section.social a {
      font-size: 24px;
      color: rgba(255, 255, 255, 0.8);
      transition: color 0.3s ease, transform 0.3s ease;
    }

    .footer-section.social a:hover {
      color: #ffeb3b;
      transform: translateY(-3px);
    }

    .footer-section.newsletter form {
      display: flex;
      gap: 10px;
      margin-top: 10px;
    }

    .footer-section.newsletter input {
      padding: 10px;
      border: none;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 5px;
      font-size: 16px;
      color: white;
      flex: 1;
    }

    .footer-section.newsletter input:focus {
      outline: none;
      background: rgba(255, 255, 255, 0.2);
    }

    .footer-section.newsletter button {
      padding: 10px 20px;
      background: linear-gradient(45deg, #ffeb3b, #ffd700);
      color: #1a1a1a;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .footer-section.newsletter button:hover {
      background: linear-gradient(45deg, #ffd700, #ffca28);
      transform: translateY(-2px);
      box-shadow: 0 4px 15px rgba(255, 235, 59, 0.5);
    }

    .footer-bottom {
      border-top: 1px solid rgba(255, 235, 59, 0.3);
      padding-top: 20px;
    }

    .footer-bottom .copyright {
      margin: 0;
    }

    .footer-bottom .company {
      color: #ffeb3b;
    }

    /* Animations */
    @keyframes slideIn {
      from { transform: translateY(-50px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }

    /* Responsive Styles */
    @media (max-width: 1024px) {
      header { padding: 15px 30px; }
      .logo { font-size: 36px; }
      .logo span { font-size: 22px; }
      nav ul { gap: 15px; }
      nav ul li a { font-size: 20px; }
      .login-link { font-size: 20px; padding: 12px 25px; margin-right: 15px; }
      .login-link i { font-size: 22px; }
      .container { padding: 20px; }
      h1 { font-size: 36px; }
      .seat { width: 35px; height: 35px; font-size: 12px; }
      .action-btn { font-size: 16px; padding: 8px 15px; }
      .back-link { font-size: 18px; padding: 10px 25px; }
      .modal-content { max-width: 500px; padding: 40px; }
      .footer-section h3 { font-size: 22px; }
      .footer-section p, .footer-section a { font-size: 14px; }
    }

    @media (max-width: 768px) {
      body { font-size: 16px; }
      header { padding: 10px 20px; flex-direction: column; gap: 10px; }
      .logo { font-size: 32px; }
      .logo span { font-size: 20px; }
      nav ul { gap: 10px; flex-wrap: wrap; justify-content: center; }
      nav ul li a { font-size: 18px; }
      .login-link { font-size: 18px; padding: 10px 20px; margin-right: 0; }
      .login-link i { font-size: 20px; }
      .container { margin: 120px auto 30px; padding: 15px; }
      h1 { font-size: 32px; }
      .seat { width: 35px; height: 35px; font-size: 12px; }
      .action-btn { font-size: 14px; padding: 8px 12px; }
      .back-link { font-size: 16px; }
      .error-message, .no-seats { font-size: 18px; }
      .modal-content { max-width: 400px; padding: 30px; }
      .modal-content h2 { font-size: 32px; }
      .modal-content label { font-size: 20px; }
      .modal-content input, .modal-content select { font-size: 18px; }
      .modal-content .submit-btn { font-size: 18px; }
      .tab-btn { font-size: 18px; }
      footer { font-size: 16px; padding: 30px 15px; }
      .footer-section { text-align: center; }
      .footer-section.newsletter form { flex-direction: column; }
      .footer-section.newsletter input, .footer-section.newsletter button { width: 100%; }
    }

    @media (max-width: 480px) {
      .logo { font-size: 28px; }
      .logo span { font-size: 18px; }
      nav ul li a { font-size: 16px; }
      .login-link { font-size: 16px; padding: 8px 15px; }
      .login-link i { font-size: 18px; }
      .container { margin: 100px auto 20px; padding: 10px; }
      h1 { font-size: 28px; }
      .seat { width: 30px; height: 30px; font-size: 10px; }
      .action-btn { font-size: 13px; padding: 6px 10px; }
      .back-link { font-size: 14px; padding: 8px 20px; }
      .error-message, .no-seats { font-size: 16px; }
      .modal-content { max-width: 300px; padding: 20px; }
      .modal-content h2 { font-size: 28px; }
      .modal-content label { font-size: 18px; }
      .modal-content input, .modal-content select { font-size: 16px; }
      .modal-content .submit-btn { font-size: 16px; }
      .tab-btn { font-size: 16px; }
      .footer-section h3 { font-size: 20px; }
    }
  </style>
</head>
<body>
<header>
  <div class="logo">
    Movie<span>MAGNET</span>
  </div>
  <nav>
    <ul>
      <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
      <li><a href="${pageContext.request.contextPath}/publicMovieList" class="active">Movies</a></li>
      <li><a href="${pageContext.request.contextPath}/contact-us.jsp">Contact us</a></li>
      <li><a href="${pageContext.request.contextPath}/about-us.jsp">About Us</a></li>
    </ul>
  </nav>
  <c:if test="${empty sessionScope.username}">
    <a href="#" class="login-link" id="loginLink"><i class="fa fa-fw fa-user"></i> Login</a>
  </c:if>
</header>

<div class="container" role="main" aria-label="Select Seats for Showtime">
  <h1>
    Select Seats for Showtime:
    <c:choose>
      <c:when test="${not empty showtime}">
        <fmt:parseDate value="${showtime.showtimeDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" />
        <fmt:setTimeZone value="Asia/Kolkata" />
        <fmt:formatDate value="${parsedDate}" pattern="MMMM d, yyyy 'at' h:mm a" />
      </c:when>
      <c:otherwise>
        ID ${showtimeId}
      </c:otherwise>
    </c:choose>
  </h1>
  <c:if test="${not empty param.error}">
    <p class="error-message" role="alert"><c:out value="${param.error}"/></p>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <p class="error-message" role="alert"><c:out value="${errorMessage}"/></p>
  </c:if>
  <c:choose>
    <c:when test="${empty seats}">
      <p class="no-seats" role="alert">No available seats for this showtime.</p>
    </c:when>
    <c:otherwise>
      <div class="seat-legend">
        <div class="legend-item"><div class="available"></div> Available</div>
        <div class="legend-item"><div class="booked"></div> Booked</div>
        <div class="legend-item"><div class="selected"></div> Selected</div>
      </div>
      <div class="screen">Screen</div>
      <div class="seating-area" role="grid" aria-label="Seating chart">
        <c:forEach var="seat" items="${seats}">
          <div class="seat ${seat.available ? '' : 'booked'}" data-seat-id="${seat.seatId}" data-seat-number="${seat.seatNumber}" tabindex="0" role="button" aria-label="Seat ${seat.seatNumber}, ${seat.available ? 'available' : 'booked'}">
            <c:out value="${seat.seatNumber}"/>
          </div>
        </c:forEach>
      </div>
      <div class="selected-seats" id="selected-seats">Selected Seats: None</div>
      <div class="total-price" id="total-price">Total Price: $0.00</div>
      <form id="booking-form" action="${pageContext.request.contextPath}/BookingCreateServlet" method="post">
        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
        <input type="hidden" name="seatIds" id="selected-seat-ids">
        <input type="hidden" name="seatNumbers" id="selected-seat-numbers">
        <input type="hidden" name="totalPrice" id="total-price-input">
        <input type="hidden" name="showtimeId" value="${showtimeId}">
        <input type="hidden" name="movieId" value="${movieId}">
        <input type="hidden" name="theaterId" value="${theaterId}">
        <button type="button" class="action-btn" id="book-btn" disabled>Proceed to Payment</button>
      </form>
    </c:otherwise>
  </c:choose>
  <a href="ShowtimeViewServlet?movieId=${movieId}" class="back-link" aria-label="Back to Showtimes">Back to Showtimes</a>
</div>

<!-- Booking Modal -->
<div id="bookingModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeBookingModal()">×</span>
    <h2>Book Seats</h2>
    <form id="booking-form-modal" action="${pageContext.request.contextPath}/BookingCreateServlet" method="post" onsubmit="return confirmBooking()">
      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
      <input type="hidden" name="showtimeId" id="modal-showtimeId">
      <input type="hidden" name="seatIds" id="modal-seatIds">
      <input type="hidden" name="movieId" id="modal-movieId">
      <input type="hidden" name="seatNumbers" id="modal-seatNumbers">
      <input type="hidden" name="amount" id="modal-amount">
      <div class="form-group">
        <label>Selected Seats</label>
        <ul class="seat-list" id="modal-seat-list"></ul>
      </div>
      <div class="form-group">
        <label class="price-label">Total Amount</label>
        <p class="price-display" id="modal-price-display">$0.00</p>
      </div>
      <div class="form-group payment-method-section">
        <label for="paymentMethod">Payment Method</label>
        <select id="paymentMethod" name="paymentMethod" required>
          <option value="Credit Card">Credit Card</option>
          <option value="Debit Card">Debit Card</option>
          <option value="PayPal">PayPal</option>
        </select>
      </div>
      <button type="submit" class="submit-btn">Confirm Booking</button>
    </form>
  </div>
</div>

<!-- Login Modal -->
<div id="loginModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeLoginModal()">×</span>
    <h2>Login</h2>
    <div class="tabs">
      <button class="tab-btn active" onclick="showTab('customer')">Customer</button>
      <button class="tab-btn" onclick="showTab('admin')">Admin</button>
    </div>
    <div id="customer" class="tab-content active">
      <form id="customerLoginForm" action="${pageContext.request.contextPath}/CustomerLoginServlet" method="post">
        <div class="form-group">
          <label for="customerUsername">Username</label>
          <input type="text" id="customerUsername" name="username" placeholder="Enter username" required>
        </div>
        <div class="form-group">
          <label for="customerPassword">Password</label>
          <input type="password" id="customerPassword" name="password" placeholder="Enter password" required>
        </div>
        <button type="submit" class="submit-btn">Login</button>
      </form>
      <a href="${pageContext.request.contextPath}/Customer/customer-register.jsp" class="switch-link">Don't have an account? Register</a>
    </div>
    <div id="admin" class="tab-content">
      <form id="adminLoginForm" action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
        <div class="form-group">
          <label for="adminUsername">Admin Username</label>
          <input type="text" id="adminUsername" name="adminUsername" placeholder="Enter admin username" required>
        </div>
        <div class="form-group">
          <label for="adminPassword">Admin Password</label>
          <input type="password" id="adminPassword" name="adminPassword" placeholder="Enter admin password" required>
        </div>
        <button type="submit" class="submit-btn">Login</button>
      </form>
      <a href="${pageContext.request.contextPath}/Admin/admin-register.jsp" class="switch-link">Don't have an account? Register</a>
    </div>
  </div>
</div>

<footer>
  <div class="footer-content">
    <div class="footer-section about">
      <h3>About MovieMagnet</h3>
      <p>We bring the magic of cinema to your fingertips with seamless booking and the latest movies.</p>
    </div>
    <div class="footer-section links">
      <h3>Quick Links</h3>
      <p><a href="${pageContext.request.contextPath}/index.jsp">Home</a></p>
      <p><a href="${pageContext.request.contextPath}/publicMovieList">Movies</a></p>
      <p><a href="${pageContext.request.contextPath}/contact-us.jsp">Contact Us</a></p>
      <p><a href="${pageContext.request.contextPath}/about-us.jsp">About Us</a></p>
    </div>
    <div class="footer-section social">
      <h3>Follow Us</h3>
      <div class="social-icons">
        <a href="#"><i class="fab fa-facebook-f"></i></a>
        <a href="#"><i class="fab fa-twitter"></i></a>
        <a href="#"><i class="fab fa-instagram"></i></a>
        <a href="#"><i class="fab fa-youtube"></i></a>
      </div>
    </div>
    <div class="footer-section newsletter">
      <h3>Newsletter</h3>
      <p>Stay updated with the latest movies and offers!</p>
      <form action="#" method="post">
        <input type="email" name="email" placeholder="Enter your email" required>
        <button type="submit">Subscribe</button>
      </form>
    </div>
  </div>
  <div class="footer-bottom">
    <p class="copyright">© <span class="company">Nexora</span> 2025. All rights reserved.</p>
  </div>
</footer>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const seats = document.querySelectorAll('.seat');
    const selectedSeatsDisplay = document.getElementById('selected-seats');
    const selectedSeatIdsInput = document.getElementById('selected-seat-ids');
    const selectedSeatNumbersInput = document.getElementById('selected-seat-numbers');
    const totalPriceDisplay = document.getElementById('total-price');
    const totalPriceInput = document.getElementById('total-price-input');
    const bookBtn = document.getElementById('book-btn');
    const bookingModal = document.getElementById('bookingModal');
    let selectedSeatIds = new Set();

    // Pricing logic based on seat position (row)
    const priceTiers = {
      standard: { rows: ['A', 'B'], price: 10.00 },
      premium: { rows: ['C', 'D'], price: 15.00 },
      vip: { rows: ['E', 'F', 'G', 'H'], price: 20.00 }
    };

    function getSeatPrice(seatNumber) {
      const row = seatNumber.charAt(0).toUpperCase();
      if (priceTiers.standard.rows.includes(row)) return priceTiers.standard.price;
      if (priceTiers.premium.rows.includes(row)) return priceTiers.premium.price;
      if (priceTiers.vip.rows.includes(row)) return priceTiers.vip.price;
      return priceTiers.standard.price; // Default to standard price
    }

    seats.forEach(seat => {
      seat.addEventListener('click', () => toggleSeat(seat));
      seat.addEventListener('keypress', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          toggleSeat(seat);
        }
      });
    });

    function toggleSeat(seat) {
      if (seat.classList.contains('booked')) return;

      const seatId = seat.dataset.seatId;
      const seatNumber = seat.dataset.seatNumber;

      if (selectedSeatIds.has(seatId)) {
        selectedSeatIds.delete(seatId);
        seat.classList.remove('selected');
        seat.setAttribute('aria-label', `Seat ${seatNumber}, available`);
      } else {
        selectedSeatIds.add(seatId);
        seat.classList.add('selected');
        seat.setAttribute('aria-label', `Seat ${seatNumber}, selected`);
      }

      updateDisplay();
    }

    function updateDisplay() {
      const seatIds = Array.from(selectedSeatIds);
      const seatNumbers = seatIds.map(id => Array.from(seats).find(s => s.dataset.seatId === id).dataset.seatNumber);

      selectedSeatsDisplay.textContent = `Selected Seats: ${seatNumbers.join(', ') || 'None'}`;
      selectedSeatIdsInput.value = seatIds.join(',');
      selectedSeatNumbersInput.value = seatNumbers.join(',');

      const totalPrice = seatNumbers.reduce((sum, seatNumber) => sum + getSeatPrice(seatNumber), 0);
      totalPriceDisplay.textContent = `Total Price: $${totalPrice.toFixed(2)}`;
      totalPriceInput.value = totalPrice.toFixed(2);

      bookBtn.disabled = selectedSeatIds.size === 0;
    }

    // Booking Modal Logic
    bookBtn.addEventListener('click', () => {
      if (selectedSeatIds.size > 0) {
        // Populate modal form fields
        document.getElementById('modal-showtimeId').value = document.querySelector('input[name="showtimeId"]').value;
        document.getElementById('modal-seatIds').value = selectedSeatIdsInput.value;
        document.getElementById('modal-movieId').value = document.querySelector('input[name="movieId"]').value;
        document.getElementById('modal-seatNumbers').value = selectedSeatNumbersInput.value;
        document.getElementById('modal-amount').value = totalPriceInput.value;

        // Display selected seats in the modal
        const seatNumbers = selectedSeatNumbersInput.value.split(',');
        const seatList = document.getElementById('modal-seat-list');
        seatList.innerHTML = ''; // Clear previous entries
        seatNumbers.forEach(seatNumber => {
          if (seatNumber.trim()) {
            const li = document.createElement('li');
            li.textContent = `Seat ${seatNumber}`;
            seatList.appendChild(li);
          }
        });

        // Display total price in the modal
        document.getElementById('modal-price-display').textContent = `$${totalPriceInput.value}`;
        bookingModal.style.display = 'block';
      }
    });

    window.closeBookingModal = function() {
      bookingModal.style.display = 'none';
    };

    window.addEventListener('click', (e) => {
      if (e.target == bookingModal) {
        bookingModal.style.display = 'none';
      }
    });

    window.confirmBooking = function() {
      const amount = document.getElementById('modal-amount').value;
      const seatNumbers = document.getElementById('modal-seatNumbers').value.split(',').filter(sn => sn.trim());
      const seatCount = seatNumbers.length;
      const confirmed = confirm(`Please confirm your booking.\nSeats: ${seatNumbers.join(', ')}\nTotal Amount: $${amount}\nProceed with payment for ${seatCount} seat${seatCount > 1 ? 's' : ''}?`);
      if (confirmed) {
        console.log(`Customer confirmed booking for ${seatCount} seats with total amount: $${amount}`);
        debugFormSubmission();
        return true;
      }
      return false;
    };

    function debugFormSubmission() {
      console.log("Submitting form from booking modal...");
      console.log("csrfToken: " + document.querySelector('#booking-form-modal input[name="csrfToken"]').value);
      console.log("showtimeId: " + document.querySelector('#booking-form-modal input[name="showtimeId"]').value);
      console.log("seatIds: " + document.querySelector('#booking-form-modal input[name="seatIds"]').value);
      console.log("movieId: " + document.querySelector('#booking-form-modal input[name="movieId"]').value);
      console.log("seatNumbers: " + document.querySelector('#booking-form-modal input[name="seatNumbers"]').value);
      console.log("amount: " + document.querySelector('#booking-form-modal input[name="amount"]').value);
      console.log("paymentMethod: " + document.querySelector('#booking-form-modal select[name="paymentMethod"]').value);
    }

    // Login Modal Logic
    const loginLink = document.getElementById('loginLink');
    const loginModal = document.getElementById('loginModal');

    if (loginLink) {
      loginLink.addEventListener('click', (e) => {
        e.preventDefault();
        loginModal.style.display = 'block';
      });
    }

    window.closeLoginModal = function() {
      loginModal.style.display = 'none';
    };

    window.addEventListener('click', (e) => {
      if (e.target == loginModal) {
        loginModal.style.display = 'none';
      }
    });

    window.showTab = function(tabName) {
      const tabs = document.querySelectorAll('.tab-content');
      const tabButtons = document.querySelectorAll('.tab-btn');
      tabs.forEach(tab => {
        tab.classList.remove('active');
        if (tab.id === tabName) {
          tab.classList.add('active');
        }
      });
      tabButtons.forEach(btn => {
        btn.classList.remove('active');
        if (btn.getAttribute('onclick').includes(tabName)) {
          btn.classList.add('active');
        }
      });
    };
  });
</script>
</body>
</html>