<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - MovieMagnet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
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

        .container {
            max-width: 1400px;
            margin: 150px auto 50px;
            padding: 50px;
            text-align: center;
        }

        .contact-section {
            background: rgba(26, 26, 26, 0.9);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.5);
            animation: fadeIn 1s ease;
        }

        .contact-section h1 {
            font-size: 48px;
            color: #ffeb3b;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-shadow: 2px 2px 10px rgba(255, 235, 59, 0.3);
        }

        .contact-info {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 40px;
        }

        .info-card {
            background: rgba(255, 235, 59, 0.1);
            padding: 20px;
            border-radius: 10px;
            width: 30%;
            min-width: 250px;
            text-align: left;
            transition: transform 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
        }

        .info-card i {
            font-size: 28px;
            color: #ffeb3b;
            margin-bottom: 15px;
        }

        .info-card h3 {
            font-size: 24px;
            color: white;
            margin-bottom: 10px;
        }

        .info-card p {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.8);
        }

        .contact-form {
            max-width: 600px;
            margin: 0 auto;
            text-align: left;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 600;
            font-size: 20px;
        }

        .form-group input, .form-group textarea {
            width: 100%;
            padding: 12px;
            border: none;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            font-size: 18px;
            color: white;
            transition: background 0.3s;
        }

        .form-group input:focus, .form-group textarea:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.2);
        }

        .form-group textarea {
            height: 150px;
            resize: vertical;
        }

        .submit-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(45deg, #ffeb3b, #ffd700);
            color: #1a1a1a;
            border: none;
            border-radius: 8px;
            font-size: 20px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            background: linear-gradient(45deg, #ffd700, #ffca28);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 235, 59, 0.6);
        }

        .map-section {
            margin-top: 40px;
            text-align: center;
        }

        .map-section h2 {
            font-size: 32px;
            color: #ffeb3b;
            margin-bottom: 20px;
        }

        .map-placeholder {
            background: #333;
            height: 300px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: rgba(255, 255, 255, 0.6);
            font-size: 18px;
        }

        footer {
            background-color: #333;
            color: white;
            padding: 20px;
            text-align: center;
            font-family: Arial, sans-serif;
            margin-top: auto;
            font-size: 18px;
        }

        .custom-footer .copyright {
            margin: 0;
        }

        .custom-footer .company {
            color: #ffeb3b;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 1024px) {
            .contact-section { padding: 30px; }
            .contact-section h1 { font-size: 40px; }
            .info-card { width: 45%; }
            .form-group label { font-size: 18px; }
            .map-section h2 { font-size: 28px; }
        }

        @media (max-width: 768px) {
            .contact-section { padding: 20px; }
            .contact-section h1 { font-size: 32px; }
            .info-card { width: 100%; }
            .form-group label { font-size: 16px; }
            .form-group input, .form-group textarea { font-size: 16px; }
            .submit-btn { font-size: 18px; }
            .map-section h2 { font-size: 24px; }
            .map-placeholder { height: 250px; }
        }

        @media (max-width: 480px) {
            .contact-section h1 { font-size: 28px; }
            .info-card h3 { font-size: 20px; }
            .info-card p { font-size: 16px; }
            .form-group label { font-size: 14px; }
            .form-group input, .form-group textarea { font-size: 14px; }
            .submit-btn { font-size: 16px; }
            .map-section h2 { font-size: 20px; }
            .map-placeholder { height: 200px; }
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
            <li><a href="${pageContext.request.contextPath}/publicMovieList">Movies</a></li>
            <li><a href="${pageContext.request.contextPath}/contact-us.jsp" class="active">Contact us</a></li>
            <li><a href="${pageContext.request.contextPath}/about-us.jsp">About Us</a></li>
        </ul>
    </nav>
    <c:if test="${empty sessionScope.username}">
        <a href="#" class="login-link" id="loginLink"><i class="fa fa-fw fa-user"></i> Login</a>
    </c:if>
</header>

<div class="container">
    <section class="contact-section">
        <h1>Contact Us</h1>
        <p>Get in touch with us for support, inquiries, or feedback. We're here to help you enjoy the ultimate movie experience!</p>

        <div class="contact-info">
            <div class="info-card">
                <i class="fa fa-phone"></i>
                <h3>Phone</h3>
                <p>+1-800-MOVIE-MAG (1-800-668-4362)</p>
            </div>
            <div class="info-card">
                <i class="fa fa-envelope"></i>
                <h3>Email</h3>
                <p>support@moviemagnet.com</p>
            </div>
            <div class="info-card">
                <i class="fa fa-map-marker"></i>
                <h3>Address</h3>
                <p>123 Cinema Lane, Hollywood, CA 90028, USA</p>
            </div>
        </div>

        <div class="contact-form">
            <form action="#" method="post">
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" placeholder="Enter your name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" placeholder="Enter your message" required></textarea>
                </div>
                <button type="submit" class="submit-btn">Send Message</button>
            </form>
        </div>

        <div class="map-section">
            <h2>Find Us</h2>
            <div class="map-placeholder">
                [Map Placeholder - Integrate Google Maps API here]
            </div>
        </div>
    </section>
</div>

<footer>
    <div class="custom-footer">
        <p class="copyright">© <span class="company">Nexora</span> 2025. All rights reserved.</p>
    </div>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const loginLink = document.getElementById('loginLink');
        const modal = document.getElementById('loginModal');

        loginLink.addEventListener('click', (e) => {
            e.preventDefault();
            modal.style.display = 'block';
        });

        window.closeLoginModal = function() {
            modal.style.display = 'none';
        };

        window.addEventListener('click', (e) => {
            if (e.target == modal) {
                modal.style.display = 'none';
            }
        });
    });
</script>