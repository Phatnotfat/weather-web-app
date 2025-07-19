require("dotenv").config();

const functions = require("firebase-functions/v2");
const { onRequest } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");

const admin = require("firebase-admin");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const axios = require("axios");
const cors = require("cors")({ origin: true });

admin.initializeApp();
const db = admin.firestore();

const secret = process.env.JWT_SECRET;
const mailUser = process.env.GMAIL_EMAIL;
const mailPass = process.env.GMAIL_PASS;
const weatherApiKey = process.env.WEATHER_API;

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: mailUser,
    pass: mailPass,
  },
});

exports.subscribe = onRequest((req, res) => {
  cors(req, res, async () => {
    const { email, lat, lng, city } = req.body;
    if (!email) return res.status(400).send("Missing email");

    try {
      const userDoc = await db.collection("subscribed_emails").doc(email).get();
      if (userDoc.exists) {
        const userData = userDoc.data();
        if (userData.verified) {
          return res.status(400).send("You are already subscribed.");
        }
      }

      const token = jwt.sign({ email }, secret, { expiresIn: "1h" });
      const link = `https://weather-web-b1e1e.web.app/verify-subscribe.html?token=${token}`;

      const message = {
        from: mailUser,
        to: email,
        subject: "Confirm your weather subscription",
        html: `<p>Click below to verify your subscription:</p><a href="${link}">${link}</a>`,
      };

      await db
        .collection("subscribed_emails")
        .doc(email)
        .set({
          verified: false,
          createdAt: new Date(),
          lat: parseFloat(lat),
          lng: parseFloat(lng),
          city: city || null,
        });

      await transporter.sendMail(message);
      res.status(200).send("Verification email sent");
    } catch (error) {
      console.error("Error sending verification email:", error);
      res.status(500).send("Error sending verification email");
    }
  });
});

exports.unsubscribe = onRequest((req, res) => {
  cors(req, res, async () => {
    const { email } = req.body;
    if (!email) return res.status(400).send("Missing email");

    try {
      const userDoc = await db.collection("subscribed_emails").doc(email).get();
      if (!userDoc.exists || userDoc.data().verified === false) {
        return res.status(400).send("You have not subscribed yet.");
      }

      const token = jwt.sign({ email }, secret, { expiresIn: "1h" });
      const link = `https://weather-web-b1e1e.web.app/verify-unsubscribe.html?token=${token}`;

      const message = {
        from: mailUser,
        to: email,
        subject: "Confirm your unsubscribe request",
        html: `<p>Click below to confirm unsubscription:</p><a href="${link}">${link}</a>`,
      };

      await transporter.sendMail(message);
      res.status(200).send("Unsubscribe confirmation email sent");
    } catch (error) {
      console.error("Error sending unsubscribe email:", error);
      res.status(500).send("Error sending unsubscribe email");
    }
  });
});

exports.verifySubscribeToken = onRequest((req, res) => {
  cors(req, res, async () => {
    const token = req.query.token;
    if (!token)
      return res.status(400).json({ success: false, message: "Missing token" });

    try {
      const decoded = jwt.verify(token, secret);
      const email = decoded.email;

      await db
        .collection("subscribed_emails")
        .doc(email)
        .update({ verified: true });

      res
        .status(200)
        .json({ success: true, message: "Subscription verified successfully" });
    } catch (e) {
      console.error("Invalid or expired token:", e.message);
      res
        .status(400)
        .json({ success: false, message: "Invalid or expired token" });
    }
  });
});

exports.verifyUnsubscribeToken = onRequest((req, res) => {
  cors(req, res, async () => {
    const token = req.query.token;
    if (!token)
      return res.status(400).json({ success: false, message: "Missing token" });

    try {
      const decoded = jwt.verify(token, secret);
      const email = decoded.email;

      await db.collection("subscribed_emails").doc(email).delete();

      res
        .status(200)
        .json({ success: true, message: "Unsubscribed successfully" });
    } catch (e) {
      console.error("Invalid or expired token:", e.message);
      res
        .status(400)
        .json({ success: false, message: "Invalid or expired token" });
    }
  });
});

exports.sendDailyWeatherEmails = onSchedule(
  { schedule: "0 0 * * *", timeZone: "Asia/Ho_Chi_Minh" },
  async () => {
    try {
      const snapshot = await db
        .collection("subscribed_emails")
        .where("verified", "==", true)
        .get();

      if (snapshot.empty) {
        console.log("No verified subscribers found.");
        return null;
      }

      const sendPromises = snapshot.docs.map(async (doc) => {
        const email = doc.id;
        const { lat, lng, city } = doc.data();

        if (!lat || !lng) {
          console.log(`Skipping ${email} due to missing coordinates.`);
          return;
        }

        try {
          const weatherRes = await axios.get(
            `https://api.weatherapi.com/v1/forecast.json?key=${weatherApiKey}&q=${lat},${lng}&days=1&lang=en`
          );

          const forecast = weatherRes.data.forecast.forecastday[0];

          const subject = `Weather forecast for ${city || "your area"} - ${
            forecast.date
          }`;
          const content = `
            <h3>Weather Update - ${forecast.date}</h3>
            <p>Temperature: ${forecast.day.avgtemp_c}°C</p>
            <p>Condition: ${forecast.day.condition.text}</p>
            <p>Rain Chance: ${forecast.day.daily_chance_of_rain}%</p>
          `;

          const mail = {
            from: mailUser,
            to: email,
            subject,
            html: content,
          };

          await transporter.sendMail(mail);
          console.log(`Email sent to ${email}`);
        } catch (err) {
          console.error(`Failed to send email to ${email}: ${err.message}`);
        }
      });

      await Promise.all(sendPromises);
      console.log(`Finished sending ${sendPromises.length} emails`);
    } catch (err) {
      console.error("Error in sendDailyWeatherEmails:", err.message);
    }
  }
);

exports.getWeatherForecast = onRequest((req, res) => {
  cors(req, res, async () => {
    const { city, lat, lng } = req.query;

    if (!city && (!lat || !lng)) {
      return res
        .status(400)
        .json({ success: false, message: "Missing city or coordinates" });
    }

    try {
      const query = city ? city : `${lat},${lng}`;
      const isLoadMore = req.query.isLoadMore === "true";
      const days = isLoadMore ? 9 : 5;
      const url = `https://api.weatherapi.com/v1/forecast.json?key=${weatherApiKey}&q=${query}&days=${days}&aqi=no&alerts=no&lang=en`;

      const response = await axios.get(url);
      const data = response.data;

      const current = {
        temp_c: data.current.temp_c,
        wind_kph: data.current.wind_kph,
        humidity: data.current.humidity,
        condition: data.current.condition.text,
        icon: data.current.condition.icon,
        city: data.location.name,
        country: data.location.country,
        last_updated: data.current.last_updated,
      };

      const forecast = data.forecast.forecastday.map((day) => ({
        date: day.date,
        avgtemp_c: day.day.avgtemp_c,
        condition: day.day.condition.text,
        icon: day.day.condition.icon,
        rain_chance: day.day.daily_chance_of_rain,
      }));

      res.status(200).json({ success: true, current, forecast });
    } catch (err) {
      console.error("Weather API error:", err.message);
      res
        .status(500)
        .json({ success: false, message: "Failed to fetch weather data" });
    }
  });
});
