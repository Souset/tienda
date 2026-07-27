```markdown
# tienda Development Patterns

> Auto-generated skill from repository analysis

## Overview

This skill teaches the core development patterns, coding conventions, and key workflows used in the `tienda` repository. The codebase is primarily written in Swift, but the project structure and workflows suggest a modular, layered architecture with strong separation of concerns, frequent integration of Firestore, and a focus on maintainability and scalability. The repository supports workflows for adding new features, updating Firestore rules, managing shared models, branding, admin panel enhancements, backend integrations, and authentication flows.

---

## Coding Conventions

### File Naming

- **Style:** `snake_case`
- **Example:**  
  ```
  feature_repository_impl.dart
  admin_screen.dart
  brand_wordmark.dart
  ```

### Import Style

- **Relative imports** are used.
- **Example:**
  ```swift
  import '../repositories/feature_repository.dart'
  ```

### Export Style

- **Named exports** are preferred.
- **Example:**
  ```swift
  export 'feature_repository.dart' show FeatureRepository
  ```

---

## Workflows

### Add New Feature Module

**Trigger:** When implementing a new feature or section in the app (e.g., Agenda, News, Films, Library, Community, etc).  
**Command:** `/new-feature-module`

1. Create the repository implementation:
   ```
   data/repositories/feature_repository_impl.dart
   ```
2. Define the repository interface:
   ```
   domain/repositories/feature_repository.dart
   ```
3. Add providers for state management:
   ```
   presentation/providers/feature_providers.dart
   ```
4. Create the main screen (and detail screens if needed):
   ```
   presentation/screens/feature_screen.dart
   ```
5. Add any necessary widgets:
   ```
   presentation/widgets/
   ```
6. Wire up routes:
   ```
   core/router/app_router.dart
   ```
7. Add tests:
   ```
   test/features/feature/feature_screen_test.dart
   ```

**Example:**
```swift
// data/repositories/news_repository_impl.dart
class NewsRepositoryImpl implements NewsRepository {
  // Implementation
}
```

---

### Add or Update Firestore Rules and Indexes

**Trigger:** When enforcing new Firestore security policies or supporting new queries.  
**Command:** `/update-firestore-rules`

1. Edit security rules:
   ```
   firebase/firestore.rules
   ```
2. Edit composite indexes:
   ```
   firebase/firestore.indexes.json
   ```
3. Add or update rule tests:
   ```
   firebase/rules-tests/*.mjs
   ```
4. Update deployment scripts as needed:
   ```
   server/api/instalar_indices.php
   ```
5. Run rule tests to verify changes.

---

### Add or Update Shared Models

**Trigger:** When defining or changing a Firestore collection's data structure.  
**Command:** `/new-shared-model`

1. Create or update the model:
   ```
   lib/shared/models/model.dart
   ```
2. Generate supporting files:
   ```
   model.freezed.dart
   model.g.dart
   ```
3. Update the barrel file:
   ```
   lib/shared/models/models.dart
   ```
4. Add or update serialization/deserialization tests:
   ```
   test/shared/models/model_test.dart
   ```

**Example:**
```dart
// lib/shared/models/user.dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

---

### Brand Asset Update

**Trigger:** When updating branding or visual identity assets.  
**Command:** `/update-brand-assets`

1. Edit or add SVG/PNG assets:
   ```
   assets_brand/*.svg
   assets_brand/*.png
   ```
2. Update app asset references:
   ```
   app/assets/brand/*.png
   ```
3. Update rendering widgets or theme as needed:
   ```
   shared/widgets/brand_wordmark.dart
   core/theme/app_theme.dart
   ```
4. Verify visually and run tests.

---

### Add or Update Admin or Panel Functionality

**Trigger:** When extending or improving admin capabilities.  
**Command:** `/update-admin-panel`

1. Edit or add admin repository:
   ```
   features/admin/data/admin_repository.dart
   ```
2. Edit or add admin screens:
   ```
   features/admin/presentation/screens/admin_screen.dart
   ```
3. Edit or add admin tabs:
   ```
   features/admin/presentation/tabs/*.dart
   ```
4. Edit or add admin providers:
   ```
   features/admin/presentation/providers/admin_providers.dart
   ```
5. Edit or add domain logic:
   ```
   features/admin/domain/*.dart
   ```
6. Wire up new admin routes or tabs.

---

### Add or Update Server API or Cron

**Trigger:** When adding server-side automation or integrations.  
**Command:** `/new-server-api`

1. Create or edit API endpoints:
   ```
   server/api/*.php
   ```
2. Create or edit cron jobs:
   ```
   server/cron/*.php
   ```
3. Edit shared logic/config:
   ```
   server/lib/common.php
   server/lib/config.sample.php
   ```
4. Update `.htaccess` or security as needed.

---

### Add or Update Auth Flow

**Trigger:** When adding or fixing authentication features.  
**Command:** `/update-auth-flow`

1. Edit auth repository implementation:
   ```
   features/auth/data/repositories/auth_repository_impl.dart
   ```
2. Edit auth repository interface:
   ```
   features/auth/domain/repositories/auth_repository.dart
   ```
3. Edit auth screens:
   ```
   features/auth/presentation/screens/*.dart
   ```
4. Edit auth providers:
   ```
   features/auth/presentation/providers/auth_providers.dart
   ```
5. Edit profile screens for verification:
   ```
   features/profile/presentation/screens/profile_screen.dart
   ```
6. Edit or add email logic:
   ```
   server/api/enviar_correo.php
   ```

---

## Testing Patterns

- **Framework:** Unknown (test files use `.test.ts` pattern, but main code is Swift/Dart).
- **Test File Pattern:**  
  ```
  *.test.ts
  ```
- **Location:**  
  ```
  test/features/feature/feature_screen_test.dart
  test/shared/models/model_test.dart
  ```
- **Typical Content:**  
  - Round-trip serialization tests for models
  - Widget/screen rendering tests
  - Rule tests for Firestore security

**Example:**
```dart
// test/shared/models/user_test.dart
void main() {
  test('User serializes correctly', () {
    final user = User(id: '1', email: 'test@example.com');
    final json = user.toJson();
    expect(User.fromJson(json), equals(user));
  });
}
```

---

## Commands

| Command                | Purpose                                                      |
|------------------------|--------------------------------------------------------------|
| /new-feature-module    | Scaffold a new feature or domain module                      |
| /update-firestore-rules| Add or update Firestore security rules and indexes           |
| /new-shared-model      | Add or update a shared data model                            |
| /update-brand-assets   | Update or regenerate brand assets                            |
| /update-admin-panel    | Add or update admin panel functionality                      |
| /new-server-api        | Add or update server API endpoints or cron jobs              |
| /update-auth-flow      | Implement or improve authentication flows                    |
```
