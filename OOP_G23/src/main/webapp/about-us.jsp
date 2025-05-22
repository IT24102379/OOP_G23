<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - MovieMagnet</title>
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

        .about-section {
            background: rgba(26, 26, 26, 0.9);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.5);
            animation: fadeIn 1s ease;
        }

        .about-section h1 {
            font-size: 48px;
            color: #ffeb3b;
            text-transform: uppercase;
            margin-bottom: 30px;
            text-shadow: 2px 2px 10px rgba(255, 235, 59, 0.3);
        }

        .about-section p {
            font-size: 22px;
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.8;
            margin-bottom: 20px;
            text-align: justify;
        }

        .highlight {
            color: #ffeb3b;
            font-weight: 700;
        }

        .mission-vision {
            display: flex;
            justify-content: space-around;
            margin-top: 40px;
            flex-wrap: wrap;
            gap: 20px;
        }

        .mission, .vision {
            background: rgba(255, 235, 59, 0.1);
            padding: 20px;
            border-radius: 10px;
            width: 45%;
            min-width: 300px;
            text-align: left;
            transition: transform 0.3s ease;
        }

        .mission:hover, .vision:hover {
            transform: translateY(-5px);
        }

        .mission h3, .vision h3 {
            font-size: 28px;
            color: #ffeb3b;
            margin-bottom: 15px;
        }

        .mission p, .vision p {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.8);
        }

        .cta-button {
            padding: 15px 30px;
            background: linear-gradient(45deg, #ffeb3b, #ffd700);
            color: #1a1a1a;
            text-decoration: none;
            border-radius: 8px;
            font-size: 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-top: 30px;
            display: inline-block;
        }

        .cta-button:hover {
            background: linear-gradient(45deg, #ffd700, #ffca28);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 235, 59, 0.6);
        }

        .cta-button::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: 0.5s;
        }

        .cta-button:hover::after {
            left: 100%;
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
            .about-section { padding: 30px; }
            .about-section h1 { font-size: 40px; }
            .about-section p { font-size: 20px; }
            .mission h3, .vision h3 { font-size: 24px; }
            .mission p, .vision p { font-size: 16px; }
            .cta-button { font-size: 18px; padding: 12px 25px; }
        }

        @media (max-width: 768px) {
            .about-section { padding: 20px; }
            .about-section h1 { font-size: 32px; }
            .about-section p { font-size: 18px; }
            .mission, .vision { width: 100%; }
            .mission h3, .vision h3 { font-size: 22px; }
            .cta-button { font-size: 16px; padding: 10px 20px; }
        }

        @media (max-width: 480px) {
            .about-section h1 { font-size: 28px; }
            .about-section p { font-size: 16px; }
            .mission h3, .vision h3 { font-size: 20px; }
            .cta-button { font-size: 14px; padding: 8px 15px; }
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
            <li><a href="#">Contact us</a></li>
            <li><a href="${pageContext.request.contextPath}/about-us.jsp" class="active">About Us</a></li>
        </ul>
    </nav>
    <c:if test="${empty sessionScope.username}">
        <a href="#" class="login-link" id="loginLink"><i class="fa fa-fw fa-user"></i> Login</a>
    </c:if>
</header>

<div class="container">
    <section class="about-section">
        <h1>About Us</h1>
        <p>Welcome to MovieMagnet, where movies come to life! Our easy-to-use booking platform lets you secure your seats instantly, skipping the long queues. Enjoy the latest blockbusters, exclusive screenings, and a top-tier cinematic experience with comfortable seating, stunning visuals, and immersive sound. At MovieMagnet, we are passionate about bringing the magic of cinema to every viewer, ensuring every visit is unforgettable.</p>
        <p>Our mission is to provide a seamless and enjoyable movie-going experience, leveraging cutting-edge technology and a customer-first approach. We collaborate with top theaters and studios to bring you the best in entertainment, from Hollywood hits to local masterpieces.</p>
        <div class="mission-vision">
            <div class="mission">
                <h3>Our Mission</h3>
                <p>To revolutionize the movie-going experience by offering a hassle-free booking process, diverse film selections, and exceptional service, making cinema accessible and enjoyable for everyone.</p>
            </div>
            <div class="vision">
                <h3>Our Vision</h3>
                <p>To be the leading global platform for movie enthusiasts, setting the standard for innovation, comfort, and cinematic excellence by <span class="highlight">2025</span> and beyond.</p>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/publicMovieList" class="cta-button"><i class="fa-solid fa-ticket"></i> Explore Movies Now</a>
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

        // Reuse the tab functionality from index.jsp if needed, but it's not required here
    });
</script>