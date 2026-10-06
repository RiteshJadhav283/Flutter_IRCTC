# RailGo — Pure Frontend (Zero Backend, 100% Local Storage)

**RailGo** is an ultra-premium, production-grade IRCTC train booking and travel management frontend built in Flutter. This project is **100% frontend-only** with **zero backend / Firebase dependencies**. All data is saved directly on the phone's local storage via `SharedPreferences`.

---

## 🚀 Key Features

- **No Backend / 0 Cloud Dependencies:** Runs completely offline or standalone without Firebase, Node.js, or external database setups.
- **On-Device Local Storage:** 
  - User registration, passwords, and sessions are encrypted and stored in device memory (`SharedPreferences`).
  - Booked tickets, ticket cancellations, passenger master list, and dark mode preferences persist across app restarts.
- **Complete 20-Screen Implementation matching Idea.md:**
  1. **Splash Screen** — RailGo animated brand reveal.
  2. **Login Screen** — Fast email & password sign-in with phone storage verification (Demo account: `ritesh.jadhav@gmail.com` / `irctc2026`).
  3. **Register Screen** — Full name, email, password, and optional phone.
  4. **Home Screen** — Station swap selector, quick filters (Tatkal, Ladies, AC), live announcements, running status cards.
  5. **Train Search Results** — Real-time filter sheet (Class, Quota, Departure Time, Train Type).
  6. **Train Detail & Route** — Live stop-by-stop station timeline with delay indicators.
  7. **Interactive Coach Layout** — CustomPainter interactive train seat map (1A, 2A, 3A, SL, CC, EC, 2S, Executive Vande Bharat).
  8. **Passenger Details** — Master list integration, berth preferences, and food choices.
  9. **Fare Breakdown & Review** — Transparent base fare, Tatkal charges, GST, travel insurance.
  10. **Payment Gateway Simulator** — UPI (GPay, PhonePe, Paytm), Net Banking, IRCTC e-Wallet.
  11. **Booking Confirmation** — Confetti celebration, dynamic QR code ticket, PDF download & share simulator.
  12. **My Bookings Screen** — Upcoming, Completed, and Cancelled tabs with filter chips.
  13. **Booking Detail Screen** — Detailed ticket card with IRCTC cancellation refund calculator.
  14. **Offline Tickets Vault** — Local ticket wallet accessible without internet.
  15. **PNR Status Tracker** — Real-time chart status, coach prediction, and delay info.
  16. **Live Train Running Status** — Interactive GPS stop progress indicator.
  17. **Profile Screen** — User stats, avatar, loyalty badge, account settings.
  18. **Master Passenger List** — CRUD passenger profiles for 1-tap fast Tatkal checkout.
  19. **Settings & Preferences** — Dark mode toggle, biometric login, notifications.
  20. **Notification Center** — Platform change, PNR confirmation, Tatkal alerts.

---

## 🛠️ How to Run

```bash
cd No_Backend_Frontend
flutter pub get
flutter run
```

To run on Chrome:
```bash
flutter run -d chrome
```

To run automated smoke tests:
```bash
flutter test
```
