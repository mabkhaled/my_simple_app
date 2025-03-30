# NextData Mobile Application

![NextData Logo](assets/images/nextdata-logo.svg)

A modern Flutter application for [describe your app's purpose briefly].

## 📱 Supported Devices
- Tested on Redmi/Android devices (Xiaomi Redmi Note series recommended)
- Minimum: Android 8.0 (API 26)
- Recommended: Android 11+ for best performance

## 🚀 Getting Started

### Prerequisites
1. **Flutter SDK** (v3.19.0 or later)
   ```bash
   flutter --version
   ```
2. **Android Studio** (with Android SDK)

### Redmi Device Setup:

Enable Developer Options:
- Go to `Settings > About phone` and tap "MIUI Version" 7 times
- Enable:
  - USB Debugging
  - Install via USB
  - USB Debugging (Security Settings)

### Installation Steps

#### Clone the Repository
```bash
git clone https://github.com/mabkhaled/my_simple_app
cd my_simple_app
```

#### Install Dependencies
```bash
flutter pub get
```

#### Run the App
```bash
flutter run
```

## 🔧 Redmi-Specific Configuration

If you encounter issues on Redmi devices:

### Disable MIUI Optimizations:
- Go to `Settings > Additional settings > Developer options`
- Disable `MIUI Optimization`

### Enable USB Debugging Security:
- In `Developer options`, enable `USB Debugging (Security settings)`

### For Installation Errors:
```bash
flutter clean
flutter pub cache repair
```

## 🛠 Build Variants

| Command | Description |
|---------|-------------|
| `flutter run --release` | Production mode |
| `flutter run --debug` | Debug mode (default) |
| `flutter build apk --split-per-abi` | Build APK for specific CPU |

## 📊 App Architecture
```
lib/
├── main.dart          # App entry point
├── screens/           # All application screens
├── widgets/           # Reusable components
└── services/          # Business logic
```

## ⚠ Troubleshooting

### Common Redmi Issues
#### App Not Installing:
- Disable "Turn on MIUI optimization" in Developer options
- Allow app installation from unknown sources

#### USB Debugging Not Working:
- Use original USB cable
- Try different USB ports

#### Performance Issues:
```bash
flutter run --profile
```

## 🤝 Contributing

1. Fork the project
2. Create your feature branch:
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit your changes:
   ```bash
   git commit -m 'Add some amazing feature'
   ```
4. Push to the branch:
   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open a Pull Request
