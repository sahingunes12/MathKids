# MathKids

Flutter ile geliştirilmiş matematik öğrenme uygulaması (RechenWelt – 1. sınıf).

## Flutter kurulumu (bilgisayar geneli)

**Homebrew ile (tercih):** Ağ erişimi varken terminalde:
```bash
brew install --cask flutter
```
Kurulumdan sonra yeni bir terminal açıp `flutter doctor` çalıştırın.

**Manuel kurulum:**
1. [macOS için Flutter SDK](https://docs.flutter.dev/get-started/install/macos) sayfasından **Apple Silicon** için zip’i indirip açın.
2. Klasörü örn. `~/development/flutter` içine taşıyın.
3. Projedeki PATH script’ini kullanın:
   ```bash
   export FLUTTER_ROOT=$HOME/development/flutter   # kendi yolunuz
   bash scripts/setup_flutter_path.sh
   source ~/.zshrc
   flutter doctor
   ```

## iOS build: "No such module 'Flutter'" hatası

Bu hata genelde Xcode veya pod’lar güncel değilken çıkar. Sırayla:

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
```

- **Xcode’da mutlaka** `ios/Runner.xcworkspace` dosyasını açın (`.xcodeproj` değil).
- Derlemeyi mümkünse terminalden deneyin: `flutter run` veya `flutter build ios`.

Hâlâ “No such module 'Flutter'” alırsanız: Xcode’da **Product → Clean Build Folder** (Shift+Cmd+K), sonra tekrar `flutter run`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
