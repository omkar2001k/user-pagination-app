# User Directory - Flutter Clean Architecture Application

[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/omkar2001k/user-pagination-app)
[![Flutter Version](https://img.shields.io/badge/Flutter-^3.0.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-^3.0.0-0175C2?logo=dart)](https://dart.dev)
[![Tests Passing](https://img.shields.io/badge/Tests-80%20Passed-brightgreen?logo=flutter)](https://github.com/omkar2001k/user-pagination-app)
[![Code Coverage](https://img.shields.io/badge/Coverage-97.0%25-brightgreen)](https://github.com/omkar2001k/user-pagination-app)

A robust, production-ready Flutter application demonstrating **Clean Architecture**, **BLoC (flutter_bloc)** state management, **Hive** offline caching, **GoRouter** declarative navigation, and **GetIt** dependency injection.

---

## 🔗 Repository Information

- **GitHub Repository**: [https://github.com/omkar2001k/user-pagination-app](https://github.com/omkar2001k/user-pagination-app)
- **Clone URL**: `git clone https://github.com/omkar2001k/user-pagination-app.git`

---

## 🌟 Features Overview

- **Clean Architecture & Separation of Concerns**: Strict boundary separation across `Data`, `Domain`, `Presentation`, and `Core` layers using SOLID principles.
- **Dedicated Data Mappers**: `UserMapper` explicitly transforms raw DTOs (`UserModel`) to and from immutable domain models (`UserEntity`).
- **REST API Pagination & Infinite Scroll**: Fetches users in chunks of 10 (`?per_page=10&page=X`) from `https://reqres.in/api/users` with an 85% scroll threshold trigger, request deduplication, and loading spinners.
- **Offline First & Hive Caching**: Automatically persists page 1 user data into local storage using Hive Box (`cached_users_box`). When offline, the app immediately serves cached users with an offline banner.
- **Offline Error Handling & Retry**: If the device is offline with no cache available, a dedicated `CommonErrorWidget` is presented with an actionable **"Try Again"** button.
- **Pull-to-Refresh**: Native `RefreshIndicator` support to re-fetch page 1 and synchronize local storage cache.
- **Client-side Search & Edge Cases**: Real-time filtering across First Name, Last Name, and Email with special character sanitization and leading/trailing whitespace trimming.
- **Rich Design System & Spacing Tokens**: Centralized `AppSpacing` and `AppLine` utilities to guarantee consistent spacing and avoid arbitrary magic numbers.
- **Comprehensive 97.0% Test Coverage**: 77 automated unit, bloc, and widget tests with zero static analysis issues (`flutter analyze` clean).

---

## 🏗️ Architecture & Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart           # Base URLs, endpoints, timeouts, cache keys
│   ├── errors/
│   │   ├── exceptions.dart              # ServerException, CacheException, NetworkException, TimeoutException
│   │   └── failures.dart                # Equatable Failure models (ServerFailure, NetworkFailure, etc.)
│   ├── network/
│   │   └── network_info.dart            # Connectivity status wrapper
│   ├── router/
│   │   └── app_router.dart              # GoRouter route definitions & page navigation
│   ├── services/
│   │   └── service_locator.dart         # GetIt dependency injection registry
│   ├── theme/
│   │   └── app_theme.dart               # Material 3 Light & Dark themes with Inter typography
│   ├── utils/
│   │   └── usecase.dart                 # Generic UseCase<Type, Params> interface
│   └── widgets/                         # Reusable core design system components
│       ├── app_spacing.dart             # AppSpacing & AppLine centralized spacing helper
│       ├── common_avatar_widget.dart    # CachedNetworkImage with initials fallback
│       ├── common_empty_widget.dart     # Contextual empty state illustration & message
│       ├── common_error_widget.dart     # Error message card with "Try Again" retry action
│       ├── common_loading_widget.dart   # Shimmer skeleton loader
│       └── common_search_bar.dart       # Search text field with clear button
├── main.dart                            # Application entry point & service initialization
└── modules/
    └── user/                            # Feature Module
        ├── data/
        │   ├── datasources/
        │   │   ├── user_local_data_source.dart   # Hive Box read/write operations
        │   │   └── user_remote_data_source.dart  # HTTP API client integration
        │   ├── mappers/
        │   │   └── user_mapper.dart              # UserModel <-> UserEntity bidirectional mapping
        │   ├── models/
        │   │   ├── user_model.dart               # User DTO with JSON serialization
        │   │   └── user_paginated_response_model.dart
        │   └── repositories/
        │       └── user_repository_impl.dart     # Repository coordinating remote, cache & mapper
        ├── domain/
        │   ├── entities/
        │   │   └── user_entity.dart              # Immutable business entity
        │   ├── repositories/
        │   │   └── user_repository.dart          # Repository contract returning Either<Failure, T>
        │   └── usecases/
        │       └── get_users_usecase.dart        # GetUsersUseCase business logic
        └── presentation/
            ├── bloc/
            │   ├── user_bloc.dart                # Event handling, pagination & search logic
            │   ├── user_event.dart               # FetchUsersEvent, FetchNextPageEvent, RefreshUsersEvent, SearchUsersEvent
            │   └── user_state.dart               # UserInitialState, UserLoadingState, UserLoadedState, UserErrorState
            ├── pages/
            │   ├── user_detail_page.dart         # Route wrapper for detail view
            │   └── user_list_page.dart           # Route wrapper providing UserBloc
            ├── views/
            │   ├── user_detail_view.dart         # User profile, contact actions, details
            │   └── user_list_view.dart           # Search bar, user list & pagination UI
            └── widgets/
                └── user_card_widget.dart         # User list item card
```

---

## 🛠️ Technology Stack & Libraries

| Dependency | Purpose |
| :--- | :--- |
| **`flutter_bloc`** | Predictable, reactive BLoC state management |
| **`dartz`** | Functional programming primitives (`Either<Failure, T>`) for explicit error handling |
| **`go_router`** | Declarative navigation and type-safe routing |
| **`get_it`** | Lightweight service locator for Dependency Injection |
| **`http`** | REST API networking client with timeouts |
| **`hive` & `hive_flutter`** | Fast, lightweight NoSQL key-value offline storage |
| **`connectivity_plus`** | Network connectivity status detection |
| **`cached_network_image`** | Image caching with smooth placeholders |
| **`shimmer`** | Skeleton loading animations |
| **`google_fonts`** | Inter typography |
| **`bloc_test` & `mocktail`** | Mocking and BLoC unit testing |

---

## 📋 Problem Scenarios & Edge Cases Handled

| Scenario | Handled By | Behavior |
| :--- | :--- | :--- |
| **Slow API Response** | `ApiConstants.timeoutDuration` (10s) + `Shimmer` | Shimmer skeletons inform the user while fetching; requests exceeding 10s throw `TimeoutException` and transition gracefully. |
| **No Internet Connection** | `NetworkInfoImpl` + `UserLocalDataSource` + `CommonErrorWidget` | If cached data exists in Hive, loads cached users immediately with a status banner. If no cache exists, displays `CommonErrorWidget` with a **"Try Again"** retry button. |
| **Empty API Response** | `CommonEmptyWidget` | Shows a friendly empty illustration with actionable advice to pull-to-refresh or adjust search terms. |
| **Search Edge Cases** | `_applySearchFilter` | Trims leading/trailing whitespace, strips special characters via regex, and matches case-insensitively. |
| **Navigation & Back Stack** | `GoRouter` + `maybePop()` | Back navigation cleanly disposes controllers and avoids memory leaks. |
| **UI Responsiveness** | `ConstrainedBox(maxWidth: 600)` + `SafeArea` | Adapts cleanly across mobile, tablet, and web viewports. |

---

## 🧪 Testing & Code Coverage (97.0%)

### Running Tests

Execute all 77 unit, bloc, and widget tests:

```bash
flutter test
```

### Generating Coverage Report

Generate line coverage report (`coverage/lcov.info`):

```bash
flutter test --coverage
```

### Detailed Layer Coverage Breakdown

| Layer / Source File | Lines Hit / Total | Coverage Rate |
| :--- | :---: | :---: |
| `lib/core/errors/exceptions.dart` | 12 / 12 | **100.0%** |
| `lib/core/errors/failures.dart` | 7 / 7 | **100.0%** |
| `lib/core/network/network_info.dart` | 4 / 4 | **100.0%** |
| `lib/core/utils/usecase.dart` | 2 / 2 | **100.0%** |
| `lib/core/widgets/app_spacing.dart` | 16 / 17 | **94.1%** |
| `lib/core/widgets/common_avatar_widget.dart` | 29 / 30 | **96.7%** |
| `lib/core/widgets/common_empty_widget.dart` | 19 / 19 | **100.0%** |
| `lib/core/widgets/common_error_widget.dart` | 25 / 25 | **100.0%** |
| `lib/core/widgets/common_loading_widget.dart` | 25 / 25 | **100.0%** |
| `lib/core/widgets/common_search_bar.dart` | 38 / 38 | **100.0%** |
| `lib/modules/user/data/datasources/user_local_data_source.dart` | 19 / 19 | **100.0%** |
| `lib/modules/user/data/datasources/user_remote_data_source.dart` | 17 / 17 | **100.0%** |
| `lib/modules/user/data/mappers/user_mapper.dart` | 20 / 20 | **100.0%** |
| `lib/modules/user/data/models/user_model.dart` | 22 / 22 | **100.0%** |
| `lib/modules/user/data/models/user_paginated_response_model.dart` | 10 / 10 | **100.0%** |
| `lib/modules/user/data/repositories/user_repository_impl.dart` | 26 / 26 | **100.0%** |
| `lib/modules/user/domain/entities/user_entity.dart` | 8 / 8 | **100.0%** |
| `lib/modules/user/domain/usecases/get_users_usecase.dart` | 8 / 8 | **100.0%** |
| `lib/modules/user/presentation/bloc/user_bloc.dart` | 69 / 69 | **100.0%** |
| `lib/modules/user/presentation/bloc/user_event.dart` | 9 / 9 | **100.0%** |
| `lib/modules/user/presentation/bloc/user_state.dart` | 32 / 32 | **100.0%** |
| `lib/modules/user/presentation/views/user_list_view.dart` | 57 / 71 | **80.3%** |
| `lib/modules/user/presentation/widgets/user_card_widget.dart` | 37 / 37 | **100.0%** |
| **TOTAL PROJECT COVERAGE** | **511 / 527 lines** | **97.0%** |

---

## 🚀 Running the Project

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Analyze code for static correctness
flutter analyze

# 3. Run all tests
flutter test

# 4. Launch the app
flutter run
```
