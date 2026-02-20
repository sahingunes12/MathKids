#!/bin/bash
# Flutter'ı bilgisayar genelinde kullanılabilir yapar (PATH).
# Kullanım:
#   1. Flutter'ı indir: https://docs.flutter.dev/get-started/install/macos
#      (flutter_macos_arm64_xxx-stable.zip - Apple Silicon için)
#   2. Zip'i aç, örn. ~/development/flutter konumuna taşı
#   3. Bu scripti düzenle: FLUTTER_ROOT aşağıda gerçek yolu göstermeli
#   4. Çalıştır: bash scripts/setup_flutter_path.sh

set -e

# Flutter'ı açtığın klasörün tam yolu (sonunda /flutter olmalı)
FLUTTER_ROOT="${FLUTTER_ROOT:-$HOME/development/flutter}"

if [[ ! -d "$FLUTTER_ROOT/bin" ]]; then
  echo "Hata: $FLUTTER_ROOT/bin bulunamadı. FLUTTER_ROOT'u doğru klasöre ayarla."
  echo "Örnek: export FLUTTER_ROOT=$HOME/development/flutter"
  exit 1
fi

SHELL_RC="$HOME/.zshrc"
if [[ -n "$BASH_VERSION" ]] && [[ -f "$HOME/.bash_profile" ]]; then
  SHELL_RC="$HOME/.bash_profile"
fi

# PATH'e ekle (tekrarsız)
if grep -q "flutter/bin" "$SHELL_RC" 2>/dev/null; then
  echo "Flutter PATH zaten $SHELL_RC içinde."
else
  echo "" >> "$SHELL_RC"
  echo "# Flutter (MathKids)" >> "$SHELL_RC"
  echo "export PATH=\"\$PATH:$FLUTTER_ROOT/bin\"" >> "$SHELL_RC"
  echo "Flutter PATH eklendi: $SHELL_RC"
fi

echo ""
echo "Şimdi şunu çalıştır: source $SHELL_RC"
echo "Sonra: flutter doctor"
