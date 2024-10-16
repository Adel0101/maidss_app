# task_manager_maidss

A simple task manager app.

## Getting Started

# Task Manager App

## Introduction

Welcome to our **Task Manager App**! This application is designed to help you manage your tasks efficiently, whether you're online or offline. We built this app using Flutter, focusing on clean architecture, robust state management, and a seamless user experience.

In this README, we'll cover:

- The architecture we chose and why
- How we used the Provider package
- Our attention to UI and UX details
- Code structure and documentation practices
- Handling API limitations with local database implementation
- Synchronization between online and offline modes
- Our dedication to best practices throughout the project

Let's dive in!

---

## Architecture Choice: MVVM Pattern

### What We Chose

We opted for the **Model-View-ViewModel (MVVM)** architecture.

### Why MVVM?

- **Separation of Concerns**: MVVM separates the UI (View) from the business logic (ViewModel) and data (Model). This makes the codebase more maintainable and scalable.
- **Testability**: With business logic in the ViewModel, we can write unit tests without UI dependencies.
- **Data Binding**: MVVM facilitates efficient data binding between the View and ViewModel, leading to responsive interfaces.

---

## State Management with Provider

### How We Used Provider

- **ChangeNotifier**: Our `TaskViewModel` extends `ChangeNotifier`, allowing the UI to listen for changes.
- **Providers in Widget Tree**: We used `ChangeNotifierProvider` at the top level, making `TaskViewModel` accessible throughout the app.
- **Consumer Widgets**: In the UI, we used `Consumer` widgets to rebuild only parts of the interface that depend on the changing data.

### Why Provider?

- **Simplicity**: Provider is straightforward and integrates well with Flutter's architecture.
- **Performance**: By rebuilding only necessary widgets, we enhance performance.
- **Community Support**: Provider is widely adopted and well-supported in the Flutter community.

---

## Attention to UI and UX Details

### Importance of UI/UX

We believe that a great app is not just about functionality but also about how users interact with it. Good UI/UX design leads to:

- **Better User Engagement**: Users are more likely to use and recommend the app.
- **Accessibility**: An intuitive interface makes the app usable for a broader audience.
- **Professionalism**: Attention to detail reflects the quality and reliability of the app.

### Our Approach

- **Consistent Design Language**: We followed Material Design guidelines for a familiar look and feel.
- **Responsive Layouts**: Ensured the app works well on various screen sizes and orientations.
- **Intuitive Interactions**: Used clear icons and gestures that users expect.
- **Feedback Mechanisms**: Implemented `SnackBar` notifications to inform users of important events.

---

## Code Structure and Documentation

### Organized Codebase

Our project is structured to promote clarity and maintainability:

- **models/**: Contains data models like `Task` and `Todo`.
- **viewmodels/**: Includes `TaskViewModel` for state management.
- **services/**:
    - **api/**: Houses API service classes such as `TaskApiService`.
    - **db/**: Contains database service classes like `DbService`.
- **views/**: Contains all the UI components and screens.
- **widgets/**: Reusable widgets used across the app.
- **utils/**: Utility classes and constants.

### Function Documentation

In the API service file, we documented each function using Dart's documentation comments (`///`).

**Example:**

```dart
/// Fetches a list of tasks from the API.
///
/// [limit]: The number of tasks to fetch.
/// [skip]: The number of tasks to skip (used for pagination).
///
/// Returns a [Tasks] object containing a list of [Todo] items.
Future<Tasks> fetchTasks({int limit = 10, int skip = 0}) async {
  // Function implementation...
}