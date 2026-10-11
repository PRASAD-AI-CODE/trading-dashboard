# Trading Journal 📊

A modern web application for recording, organizing, and analyzing trading activity. Trading Journal provides a dashboard for tracking profit and loss, reviewing trade history, exploring analytics, and maintaining a trading journal.

## 🚀 Live Demo

**[Open Trading Journal](https://trading-dashboard-six-pi.vercel.app)**

## ✨ Features

- **Dashboard:** View key trading performance metrics.
- **Trade Management:** Record and manage trade details.
- **Profit & Loss Tracking:** Review trading results.
- **Trading Calendar:** Organize trades by date.
- **Analytics:** Explore performance data and trends.
- **Trading Journal:** Maintain notes and reflections.
- **Psychology Tracking:** Record observations about trading behavior.
- **Strategy Management:** Organize trading strategies.
- **Authentication:** User sign-in and account management.
- **Responsive Interface:** A modern dark-themed dashboard.

## 🛠️ Tech Stack

- React.js
- Vite
- Supabase
- JavaScript
- CSS
- Git and GitHub
- Vercel

## 💻 Run Locally

### Prerequisites

- Node.js and npm
- A Supabase project with the required database and authentication configuration

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/PRASAD-AI-CODE/trading-dashboard.git
   ```

2. Enter the project directory:

   ```bash
   cd trading-dashboard
   ```

3. Install dependencies:

   ```bash
   npm install
   ```

4. Create a `.env.local` file in the project root and add the environment variables expected by the application:

   ```env
   VITE_SUPABASE_URL=your_supabase_project_url
   VITE_SUPABASE_ANON_KEY=your_supabase_publishable_or_anon_key
   ```

   Use the exact variable names expected by the source code. Never commit `.env.local` or private service-role keys.

5. Start the development server:

   ```bash
   npm run dev
   ```

6. To create a production build:

   ```bash
   npm run build
   ```

## 🌐 Deployment

The application is deployed using Vercel. Configure the required environment variables in the Vercel project settings before deploying.

## 🔒 Security

- Keep local environment files private.
- Never expose Supabase service-role or other secret keys.
- Configure authentication redirect URLs for your deployed domain.

## 👨‍💻 Author

**Prasad Bobade**

GitHub: [PRASAD-AI-CODE](https://github.com/PRASAD-AI-CODE)

## 📄 Note

This project is intended for trade recordkeeping, journaling, and performance analysis. It does not guarantee trading results or provide financial advice.
