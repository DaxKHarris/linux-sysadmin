# Secure Stream Gateway

This project is a secure, self-hosted reverse proxy and authentication gateway that controls access to my Jellyfin media server. It’s designed to keep the server completely offline and unreachable unless explicitly activated by a verified user through a temporary session and Wake-on-LAN trigger.

---

## 🔐 What It Does

- **Magic Link Authentication**: Users authenticate by clicking a one-time-use email link—no passwords, no UI.
- **Session Control**: After a successful login, a secure cookie is issued and verified for all future requests.
- **Wake-on-LAN Triggering**: Once authenticated, a `/server/wake` endpoint allows the backend Jellyfin server to be powered on remotely.
- **Reverse Proxy Enforcement**: All `/jellyfin` traffic is routed through an auth-guarded reverse proxy.
- **HTTPS Only**: NGINX ensures that all external access is encrypted with TLS via Let's Encrypt.

---

## ⚙️ How It Works

The entire flow is coordinated through a Raspberry Pi, which acts as the always-on public-facing gateway. Here’s the full sequence:

1. A user POSTs their email to `/auth/send`.
2. A signed token is generated and stored in Redis.
3. A “magic link” is emailed to the user, including the token as a query parameter.
4. When the user clicks the link, `/auth/verify` checks the token, deletes it, and sets a session cookie.
5. The user can then send a POST request to `/server/wake`, which:
   - Validates the session cookie.
   - Sends a Wake-on-LAN packet to the media server.
6. All requests to `/jellyfin` routes are proxied only if the session is valid.

---

## 🧱 Components

- **Node.js (Express)**: Core server logic and route handling
- **Redis**: Session and token storage
- **Nodemailer**: Magic link delivery via email
- **WOL**: Wake-on-LAN packet handling
- **NGINX**: SSL termination and reverse proxy with route restrictions

---

## 📦 File Overview

- `index.js`: App entrypoint with route setup and proxy middleware
- `authRoutes.js`: Handles `/auth/send` and `/auth/verify`
- `serverRoutes.js`: Wakes the backend server via WoL if session is valid
- `sessionRoutes.js`: Validates session cookies
- `tokenHandler.js`: Generates and verifies time-limited tokens
- `sessionManager.js`: Manages session creation and validation
- `emailSender.js`: Sends login links via SMTP
- `wakeServer.js`: Sends the magic WoL packet
- `nginx.conf`: SSL and routing layer

---

## 🤖 Use of AI

A substantial portion of this project was built with the help of AI (ChatGPT), including:

- Architecture and session design suggestions
- Middleware setup and error handling
- Debugging token validation logic
- Writing this very documentation

I’m deliberately acknowledging this because it reflects the truth—and because most of my other projects were written with far less assistance. The contrast will help showcase my independent skills elsewhere, while this one demonstrates how I integrate modern tools effectively.

---

## 🧪 Future Improvements

- Add rate limiting and brute-force protections
- Store login history and audit logs
- Optional MFA support
- Simple front-end or status dashboard
- Environment validation and startup checks

---

## 🔐 Notes

- Email magic link tokens expire after 10 minutes.
- Sessions last 7 days by default (adjustable in `constants.js`).
- WoL MAC and broadcast values are environment-specific.


