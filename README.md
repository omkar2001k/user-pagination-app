# User Directory - Flutter Clean Architecture App

[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/omkar2001k/user-pagination-app)
[![Flutter Version](https://img.shields.io/badge/Flutter-^3.0.0-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-^3.0.0-0175C2?logo=dart)](https://dart.dev)
[![Tests Passing](https://img.shields.io/badge/Tests-71%20Passed-brightgreen?logo=flutter)](https://github.com/omkar2001k/user-pagination-app)

A production-grade, highly responsive Flutter application implementing **Clean Architecture**, **BLoC State Management**, **Hive Offline Caching**, **GoRouter Navigation**, and **GetIt Dependency Injection** to display paginated user directory information from ReqRes API.

---

## 🔗 Repository Links

- **GitHub Repository**: [https://github.com/omkar2001k/user-pagination-app](https://github.com/omkar2001k/user-pagination-app)
- **Clone URL**: `git clone https://github.com/omkar2001k/user-pagination-app.git`

---

## 🌟 Key Features

- **Clean Architecture & Layered Modular Structure**: Strict separation of concerns following SOLID principles across `Data`, `Domain`, `Presentation`, and `Core` layers.
- **User List & Detail View**: Displays a list of users with high-resolution avatars, full names, and email addresses, with seamless transition to user detail page using `GoRouter`.
- **API Pagination & Infinite Scroll**: Fetches users in pages of 10 items (`?per_page=10&page=X`) from `reqres.in` API with debounced scroll triggers near the list end.
- **Pull-to-Refresh**: Gesture-driven refresh capability allowing users to fetch updated page 1 data anytime.
- **Client-side Search & Edge-Case Handling**: Instant real-time filtering by user's full name or email address, with handling for leading/trailing whitespace, case insensitivity, empty results, and special characters.
- **Offline First & Hive Caching**: Automatically caches page 1 user data into local storage using Hive Box. If internet is lost or remote API calls fail, the app falls back to cached data accompanied by a friendly offline indicator.
- **Network & Error Recovery**: Integrated timeout management (10-second default limit) with user-friendly retry buttons (`CommonErrorWidget`) and offline warning banners.
- **Standardized Component Library**: Shared UI components (`CommonSearchBar`, `CommonAvatarWidget`, `CommonLoadingWidget`, `CommonErrorWidget`, `CommonEmptyWidget`) placed under `lib/core/widgets/`.
- **Complete Test Coverage**: Comprehensive suite of 71 unit and widget tests covering Data Sources, Repositories, Use Cases, BLoC, and Page/View Widgets using `mocktail` and `bloc_test`.

---

## 🏗️ Architecture & Folder Structure

The application strictly follows Clean Architecture guidelines:

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── services/
│   │   └── service_locator.dart (GetIt DI)
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   └── usecase.dart
│   └── widgets/                     # Common Reusable Widgets
│       ├── common_avatar_widget.dart
│       ├── common_empty_widget.dart
│       ├── common_error_widget.dart
│       ├── common_loading_widget.dart
│       └── common_search_bar.dart
├── main.dart
└── modules/
    └── user/                        # Feature Module
        ├── data/
        │   ├── datasources/
        │   │   ├── user_local_data_source.dart
        │   │   └── user_remote_data_source.dart
        │   ├── models/
        │   │   ├── user_model.dart
        │   │   └── user_paginated_response_model.dart
        │   └── repositories/
        │       └── user_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user_entity.dart
        │   ├── repositories/
        │   │   └── user_repository.dart
        │   └── usecases/
        │       └── get_users_usecase.dart
        └── presentation/
            ├── bloc/
            │   ├── user_bloc.dart
            │   ├── user_event.dart
            │   └── user_state.dart
            ├── pages/
            │   ├── user_detail_page.dart
            │   └── user_list_page.dart
            ├── views/
            │   ├── user_detail_view.dart
            │   └── user_list_view.dart
            └── widgets/
                └── user_card_widget.dart
```

---

## 🛠️ Technology Stack & Libraries

| Dependency / Package | Version | Purpose |
| -------------------- | ------- | ------- |
| **`flutter_bloc`** | ^8.1.3 | Predictable BLoC state management |
| **`go_router`** | ^14.0.0 | Declarative routing & deep linking |
| **`get_it`** | ^7.7.0 | Service locator for Dependency Injection |
| **`http`** | ^1.2.1 | REST API communication |
| **`hive` & `hive_flutter`** | ^2.2.3 | Fast offline key-value local storage |
| **`connectivity_plus`** | ^6.0.3 | Real-time network connectivity status monitoring |
| **`dartz`** | ^0.10.1 | Functional programming structures (`Either<Failure, Success>`) |
| **`cached_network_image`** | ^3.3.1 | Efficient image caching and visual placeholders |
| **`shimmer`** | ^3.0.0 | Skeleton loading animations for smooth UX |
| **`bloc_test` & `mocktail`** | ^9.1.7 / ^1.0.4 | Unit and widget test mocks & verification |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.0.0`
- Dart SDK `^3.0.0`

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/omkar2001k/user-pagination-app.git
   cd user-pagination-app
   ```

2. **Fetch packages**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

To execute all unit and widget tests across data, domain, and presentation layers:

```bash
flutter test
```

To generate coverage reports:
```bash
flutter test --coverage
```

---

## 📱 App Highlights & Behavior

- **Initial Load**: Displays a shimmer skeleton loading grid, then populates the user list.
- **Infinite Pagination**: Scroll near the bottom to trigger background page fetches (`page 2`, `page 3`...).
- **Search Filtering**: Live query updates with graceful handling of non-matching queries ("No users found").
- **Offline Caching Strategy**: Automatically caches page 1 data into Hive. When offline, loads cached users and displays an offline indicator bar.

---

## 📋 Assignment Requirements & Problem Scenarios Matrix

| Requirement / Problem Scenario | Implementation Details | Status |
| ------------------------------ | ---------------------- | ------ |
| **State Management** | Implemented using `flutter_bloc` (`UserBloc`, `UserEvent`, `UserState`) | ✅ Completed |
| **Clean Architecture** | Separated into `Data`, `Domain`, `Presentation`, and `Core` layers | ✅ Completed |
| **Networking & API** | Uses `http` package fetching from `https://reqres.in/api/users` | ✅ Completed |
| **Pagination** | Query parameters `?per_page=10&page=X` with debounced infinite scroll | ✅ Completed |
| **Navigation** | `GoRouter` declarative navigation between list and detail views | ✅ Completed |
| **Offline Data Caching** | Local caching using `Hive` with automatic offline fallback | ✅ Completed |
| **Pull-to-Refresh** | Native `RefreshIndicator` gesture re-fetching page 1 data | ✅ Completed |
| **Dependency Injection** | `get_it` service locator (`service_locator.dart`) | ✅ Completed |
| **Slow API Response** | 10-second timeout mechanism with shimmer loading feedback | ✅ Handling Done |
| **No Internet Connection** | Displays offline notification bar, cached data fallback & retry button | ✅ Handling Done |
| **Empty API Response** | `CommonEmptyWidget` with friendly empty state illustration | ✅ Handling Done |
| **Search Edge Cases** | Trims whitespace, ignores special chars, case-insensitive real-time filtering | ✅ Handling Done |
| **UI Responsiveness** | Adaptive layout supporting light/dark theme and variable screen sizes | ✅ Handling Done |
| **Unit & Widget Testing** | 71 automated tests written with `mocktail` & `bloc_test` | ✅ Completed |


