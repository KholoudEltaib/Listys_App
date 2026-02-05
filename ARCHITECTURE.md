# Clean Architecture Implementation

This project has been restructured to follow Clean Architecture principles with BLoC/Cubit for state management.

## Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── di/                        # Dependency Injection
│   │   ├── injection.dart         # DI configuration
│   │   └── injection.config.dart  # Generated DI code
│   ├── error/                     # Error handling
│   │   ├── exceptions.dart        # Custom exceptions
│   │   └── failures.dart          # Failure classes
│   ├── theme/                     # App theming
│   │   └── app_color.dart         # Color definitions
│   └── usecases/                  # Base use case classes
│       └── usecase.dart           # Use case interfaces
├── features/                      # Feature-based modules
│   └── auth/                      # Authentication feature
│       ├── data/                  # Data layer
│       │   ├── datasources/       # Data sources
│       │   │   ├── auth_local_datasource.dart
│       │   │   └── auth_remote_datasource.dart
│       │   ├── models/            # Data models
│       │   │   ├── auth_result_model.dart
│       │   │   └── user_model.dart
│       │   └── repositories/      # Repository implementations
│       │       └── auth_repository_impl.dart
│       ├── domain/                # Domain layer
│       │   ├── entities/          # Business entities
│       │   │   ├── auth_result.dart
│       │   │   └── user.dart
│       │   ├── repositories/      # Repository interfaces
│       │   │   └── auth_repository.dart
│       │   └── usecases/          # Use cases
│       │       ├── check_auth_status.dart
│       │       ├── login_with_email.dart
│       │       ├── login_with_facebook.dart
│       │       ├── login_with_instagram.dart
│       │       ├── logout.dart
│       │       └── register.dart
│       └── presentation/          # Presentation layer
│           └── bloc/              # BLoC/Cubit
│               ├── auth_bloc.dart
│               ├── auth_event.dart
│               └── auth_state.dart
├── screens/                       # UI screens
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── main_screen.dart
│   └── register_screen.dart
└── main.dart                      # App entry point
```

## Key Features

### 1. Clean Architecture Layers

- **Domain Layer**: Contains business logic, entities, and use cases
- **Data Layer**: Handles data sources, models, and repository implementations
- **Presentation Layer**: Manages UI state with BLoC/Cubit

### 2. Dependency Injection

- Uses `get_it` and `injectable` for dependency injection
- Automatic code generation for DI configuration
- Easy testing with mock dependencies

### 3. State Management

- BLoC pattern for predictable state management
- Separation of business logic from UI
- Reactive programming with streams

### 4. Error Handling

- Custom exception and failure classes
- Proper error propagation through layers
- User-friendly error messages

### 5. Internationalization

- Support for Arabic and English languages
- Maintained throughout the refactoring
- Easy to add new languages

## Usage

### Running the App

```bash
flutter pub get
flutter packages pub run build_runner build
flutter run
```

### Adding New Features

1. Create feature folder under `lib/features/`
2. Implement domain layer (entities, repositories, use cases)
3. Implement data layer (models, data sources, repository implementations)
4. Implement presentation layer (BLoC/Cubit, screens)
5. Register dependencies in `injection.dart`
6. Run build runner to generate DI code

### Testing

The Clean Architecture structure makes testing easier:
- Unit tests for use cases
- Integration tests for repositories
- Widget tests for UI components
- Mock dependencies for isolated testing

## Benefits

1. **Maintainability**: Clear separation of concerns
2. **Testability**: Easy to mock dependencies
3. **Scalability**: Easy to add new features
4. **Reusability**: Business logic is independent of UI
5. **Flexibility**: Easy to change data sources or UI frameworks
