# Hafta 10: CI/CD ve DevOps

Bu haftada HabitMaster uygulamamız için CI/CD pipeline'ı kuracak ve DevOps pratiklerini uygulayacağız.

## 🎯 Hedefler

- CI/CD pipeline kurulumu
- GitHub Actions yapılandırması
- Automated testing
- Deployment automation

## 📝 Konu Başlıkları

1. CI/CD Pipeline
   - Continuous Integration
   - Continuous Delivery
   - Pipeline aşamaları
   - Workflow yapılandırması

2. GitHub Actions
   - Workflow dosyaları
   - Action'lar
   - Trigger'lar
   - Environment variables

3. Automated Testing
   - Test automation
   - Code coverage
   - Static analysis
   - Linting

## 💻 Adım Adım Uygulama Geliştirme

### 1. GitHub Actions Workflow

```yaml
name: Flutter CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Analyze project source
      run: flutter analyze
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
        file: coverage/lcov.info
    
    - name: Build APK
      run: flutter build apk
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

### 2. Static Analysis Yapılandırması

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_empty_else
    - avoid_print
    - avoid_unused_constructor_parameters
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - close_sinks
    - comment_references
    - constant_identifier_names
    - control_flow_in_finally
    - empty_catches
    - empty_constructor_bodies
    - empty_statements
    - hash_and_equals
    - implementation_imports
    - library_names
    - library_prefixes
    - non_constant_identifier_names
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - prefer_final_fields
    - prefer_final_locals
    - prefer_is_not_empty
    - slash_for_doc_comments
    - test_types_in_equals
    - throw_in_finally
    - type_init_formals
    - unnecessary_brace_in_string_interps
    - unnecessary_getters_setters
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_statements
    - unrelated_type_equality_checks
    - valid_regexps

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore
```

### 3. Deployment Script

```dart
// scripts/deploy.dart
import 'dart:io';

Future<void> main() async {
  print('Starting deployment process...');

  // Build APK
  print('Building APK...');
  var result = await Process.run('flutter', ['build', 'apk', '--release']);
  if (result.exitCode != 0) {
    print('Error building APK: ${result.stderr}');
    exit(1);
  }

  // Upload to Firebase App Distribution
  print('Uploading to Firebase App Distribution...');
  result = await Process.run('firebase', [
    'appdistribution:distribute',
    'build/app/outputs/flutter-apk/app-release.apk',
    '--app',
    Platform.environment['FIREBASE_APP_ID']!,
    '--groups',
    'testers',
    '--release-notes',
    'New version available for testing'
  ]);

  if (result.exitCode != 0) {
    print('Error uploading to Firebase: ${result.stderr}');
    exit(1);
  }

  print('Deployment completed successfully!');
}
```

## 📝 Ödevler

1. SonarQube entegrasyonu yapın
2. Fastlane ile deployment otomasyonu kurun
3. Slack/Discord bildirim entegrasyonu ekleyin

## 🔍 Sonraki Adımlar

Gelecek hafta:
- Performance optimizasyonu
- Memory management
- Profiling 