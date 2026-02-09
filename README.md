# Mintra - Finance Tracker

Mintra is a powerful and elegant expense tracker app built with Flutter. It helps you manage your money wisely with real-time tracking, intuitive charts, and budget management.

## 🚀 Features

- **Dynamic Currencies**: Multi-currency support including **Nigerian Naira (₦)**, USD, EUR, GBP, and more.
- **Visual Analytics**:
  - **Spending by Category**: Donut chart with emoji-coded categories.
  - **Monthly Trend**: Bar chart comparing income vs. expenses.
- **Smart Tracking**:
  - Filter transactions by Day, Week, or Month.
  - Search transactions and filter by category.
- **Budget Management**: Set and track budget limits for different categories.
- **Seamless UI**: Modern Material 3 design with a clean, green-themed aesthetic.
- **Persistence**: All data and preferences are saved locally using SharedPreferences.

## 🛠️ Tech Stack

- **Flutter**: UI Framework
- **Riverpod**: State Management
- **fl_chart**: Data Visualization
- **Shared Preferences**: Local Storage
- **Intl**: Formatting and Internationalization

## 📦 Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Android Studio / VS Code with Flutter extension

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/killingspree001/mintra.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

- `lib/models/`: Data models (Transaction, Category, Budget, Currency).
- `lib/providers/`: State management logic using Riverpod.
- `lib/widgets/`: Reusable UI components.
- `lib/screens/`: Main app screens (Dashboard).

## 🚀 CI/CD

This project uses **GitHub Actions** for automated builds:
- **Web Build**: Automatically compiles for web on every push.
- **APK Build**: Automatically generates a release APK on every push.
  *Download the latest builds from the **Actions** tab.*

## 📄 License

This project is open-source. Feel free to use and modify it!
