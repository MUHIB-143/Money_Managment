# 💰 StudentMoneyManager

A beautiful, privacy-focused personal finance management app designed specifically for university students. Track income, manage expenses, set savings goals, and monitor tuition payments - all with your data stored locally on your device.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

</div>

---

## ✨ Features

### 💵 Income Tracking
- **Multiple Income Sources**: Track part-time jobs, freelance work, scholarships, and allowances
- **Smart Source Selection**: Autocomplete with 20+ predefined sources (Part-time Job, Food Delivery, Tutoring, Freelance Work, etc.)
- **Custom Sources**: Type your own income source or select from dropdown
- **Hourly Rate Calculator**: Automatically calculate earnings based on hourly rate and hours worked
- **Period Filtering**: View income by today, week, month, or all time
- **Visual Analytics**: See your income trends with interactive charts

### 🛒 Expense Management
- **8 Pre-defined Categories**: Food, Transport, Entertainment, Books, Health, Shopping, Bills, and Other
- **Smart Categorization**: Beautiful chip-based category selection
- **Interactive Pie Charts**: Visualize spending by category
- **Category Breakdown**: Detailed view of spending distribution
- **Swipe to Delete**: Quick and intuitive transaction removal

### 🎯 Savings Goals
- **Goal Setting**: Create unlimited savings goals with target amounts
- **Progress Tracking**: Visual progress bars showing completion percentage
- **Smart Suggestions**: Automatic weekly/monthly savings recommendations
- **Deadline Management**: Set target dates with overdue detection
- **Completion Tracking**: Separate active and completed goals

### 🎓 Tuition Fee Management
- **Semester Tracking**: Manage tuition fees by semester
- **Payment History**: Record all tuition payments
- **Progress Visualization**: See how much you've paid and what's remaining
- **Overdue Alerts**: Visual indicators for overdue payments
- **Payment Plans**: Track multiple installments

### 📊 Dashboard & Analytics
- **Balance Overview**: See your current financial balance at a glance
- **Quick Stats**: Monthly income and expense summaries
- **Expense Charts**: Interactive pie charts for category breakdown
- **Recent Transactions**: Quick access to latest income and expenses
- **Glassmorphic Design**: Modern, premium UI with blur effects

### ⚙️ Customization & Settings
- **Theme Options**: Light, Dark, or System-adaptive themes
- **9 Currencies**: Support for USD, EUR, GBP, JPY, CNY, INR, AUD, CAD, BDT
- **Date Formats**: Choose from multiple date format preferences
- **Font Scaling**: Adjust text size for better readability
- **Reset Option**: Restore default settings anytime

---

## 🏗️ Architecture

### Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Local Database**: Hive (NoSQL)
- **Charts**: FL Chart
- **Fonts**: Google Fonts (Poppins & Roboto)
- **Design**: Material 3 with custom glassmorphism

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── income_model.dart
│   ├── expense_model.dart
│   ├── savings_goal_model.dart
│   ├── tuition_fee_model.dart
│   ├── budget_model.dart
│   └── reminder_model.dart
├── screens/                  # UI screens
│   ├── dashboard_screen.dart
│   ├── income_screen.dart
│   ├── expense_screen.dart
│   ├── savings_screen.dart
│   ├── tuition_screen.dart
│   └── settings_screen.dart
├── providers/                # State management
│   ├── income_provider.dart
│   ├── expense_provider.dart
│   ├── savings_provider.dart
│   ├── tuition_provider.dart
│   └── settings_provider.dart
├── services/                 # Business logic
│   ├── database_service.dart
│   └── settings_service.dart
├── widgets/                  # Reusable widgets
│   └── glassmorphism.dart
├── theme/                    # Theming
│   ├── app_colors.dart
│   └── app_theme.dart
└── utils/                    # Utilities
    ├── constants.dart
    ├── helpers.dart
    └── validators.dart
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.0 or higher
- **Dart SDK**: 2.17 or higher
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/student-money-manager.git
   cd student-money-manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive type adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📱 Usage

### Adding Income
1. Tap the **Income** tab in bottom navigation
2. Press the **+ Add Income** button
3. Select a category (e.g., Part-time, Freelance, Scholarship)
4. Enter amount or use hourly calculator
5. Set the date and optional description
6. Tap **Add Income**

### Recording Expenses
1. Navigate to the **Expenses** tab
2. Tap **+ Add Expense**
3. Select a category using chips
4. Enter the amount and date
5. Add optional description
6. Save your expense

### Creating Savings Goals
1. Go to the **Savings** tab
2. Tap **+ Add Goal**
3. Name your goal (e.g., "New Laptop")
4. Set target amount and current savings
5. Optionally set a deadline
6. The app will suggest weekly savings needed

### Managing Tuition
1. Open the **Tuition** tab
2. Add a new tuition fee with semester and amount
3. Record payments as you make them
4. Track progress with visual indicators

### Customizing Settings
1. Tap the settings icon on the dashboard
2. Choose your preferred theme
3. Select your currency
4. Adjust date format and font size
5. Changes save automatically

---

## 🎨 Design Philosophy

### Color Palette
- **Primary Blue** (#4A90E2): Trust and reliability
- **Accent Yellow** (#FFC107): Energy and optimism
- **Neon Teal** (#00D9FF): Modern premium feel
- **Success Green** (#4CAF50): Positive financial growth
- **Error Red** (#D32F2F): Overspending alerts

### Typography
- **Headers**: Poppins (Bold, Semi-bold)
- **Body**: Roboto (Regular)
- **Numbers**: Roboto Mono for clarity

### Design Principles
1. **Glassmorphism**: Modern blur effects for depth
2. **Consistency**: Uniform spacing and rounded corners
3. **Accessibility**: High contrast, scalable fonts
4. **Responsiveness**: Adaptive layouts for all screen sizes

---

## 📊 Data & Privacy

### Local-First Approach
- **No Cloud Storage**: All data stored locally using Hive
- **No Authentication**: No accounts or personal data collection
- **No Internet Required**: Works completely offline
- **Full Control**: Your data never leaves your device

### Data Storage
- Income, Expenses, Savings, and Tuition stored in encrypted Hive boxes
- Settings stored in SharedPreferences
- No third-party analytics or tracking

---

## 🛣️ Roadmap

### Upcoming Features
- [ ] **Local Notifications**: Reminders for payments and goals
- [ ] **Data Export**: CSV and PDF export functionality
- [ ] **Budget Management**: Set and track category budgets
- [ ] **Recurring Transactions**: Automatic income/expense entries
- [ ] **Cloud Backup**: Optional encrypted cloud backup
- [ ] **Bill Reminders**: Never miss a payment deadline
- [ ] **Widgets**: Home screen widgets for quick stats
- [ ] **Multi-language Support**: Internationalization
- [ ] **Onboarding**: First-time user tutorial

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Dart/Flutter style guide
- Add tests for new features
- Update documentation
- Keep commit messages clear and descriptive

---

## 🐛 Known Issues

- RadioListTile deprecation warnings (Flutter 3.32+) - informational only
- withOpacity deprecation (Flutter 3.33+) - will migrate to withValues

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**MARUFUL HAQUE MUHIB**  
Full Stack Developer

- GitHub: [@MUHIB-143](https://github.com/MUHIB-143)
- Facebook: [its.muhib.7](https://facebook.com/its.muhib.7)

---

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **FL Chart** for beautiful chart implementations
- **Google Fonts** for typography
- **Hive** for fast local storage
- The Flutter community for inspiration and support

---

## 📸 Screenshots

> *Coming soon!*

---

<div align="center">

### ⭐ Star this repo if you find it useful!

Made with ❤️ and Flutter

</div>
