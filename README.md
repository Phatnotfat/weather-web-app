# 🌤️ Weather Forecast Web App

A modern weather forecast application built with **Flutter Web**, using **GetX** for state management and **Firebase Cloud Functions** as backend for secure API access and scheduled email notifications.

---

## Live Demo

[Try the App](https://weather-web-b1e1e.web.app)

---

## Features

- Search city name and display current weather
- Show 4-day forecast with “Load More” functionality
- Get weather by current location
- Save daily search history (localStorage)
- Subscribe to daily forecast emails (via email verification)
- Unsubscribe via confirmation link
- Secure API Key usage via Firebase Functions

---

## Run the Project Locally

This guide will walk you through setting up the Weather Forecast Web App locally for development and testing purposes.

---

### 1. Clone the Repository

```bash
git clone https://github.com/Phatnotfat/weather-web-app.git
cd weather-web-app
```

### 2. Set Up Environment Variables

Create a `.env` file inside the `functions` folder:

```bash
cd functions
cp .env.example .env
```

Then update the `.env` with your credentials:

```dotenv
GMAIL_EMAIL=your-email@gmail.com
GMAIL_PASS=your-app-password
JWT_SECRET=your-random-secret
WEATHER_API=your-weatherapi-key
```

---

### 3. Install Dependencies

#### Flutter Dependencies:

```bash
flutter pub get
```

#### Firebase Functions:

```bash
cd functions
npm install
```

---

### 4. Emulate Firebase Functions (Optional)

If you want to test functions locally:

```bash
firebase emulators:start --only functions
```

---

### 5. Deploy to Firebase (If Needed)

```bash
firebase deploy --only functions,hosting
```

---

### 6. Run Flutter Web Locally

```bash
flutter run -d chrome
```

Now you can view the app at http\://localhost:5000 or the port Flutter binds to.
