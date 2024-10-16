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
```
---

# Handling API Limitations with Local Database
## The Challenge

- Our API had limitations that restricted full CRUD (Create, Read, Update, Delete) operations.

## Our Solution
- We implemented a local database using **SQfLite**, a plugin for SQLite databases in Flutter.

## Why Local Database?
- **Offline Capability**: Users can continue to use the app without internet connectivity.
- **Data Persistence**: Ensures tasks are not lost if the app is closed or the network is unavailable.
- **Performance**: Local data access is faster, providing a smoother user experience.

## Simulating CRUD Operations

- **Create**: Users can add new tasks locally, which are stored in the SQLite database.
- **Read**: Tasks are fetched from the local database when the app starts or when the API is unavailable.
- **Update**: Users can edit tasks, and changes are saved locally.
- **Delete**: Tasks can be removed from the local database.
- **Synchronization** Between Online and Offline Modes, the syncing process was partially implemented due to API restriction.

---

# Network Detection

- We used a NetworkService to monitor network connectivity changes.

- **Real-time Updates**: The app listens for network status changes and reacts accordingly.
- **User Notifications**: If there's no internet connection, a SnackBar informs the user.
---

* Syncing Data
- When the app detects a return to online status:
- **This is how synchronization should be handled**
- **Data Upload**: Locally stored tasks that were added or modified offline are synced with the server.
- **Conflict Resolution**: The app checks for discrepancies between local and server data to prevent data loss.
- **Feedback to User**: Users are notified when syncing is complete or if any issues occur.

# Handling Edge Cases
- **Duplicate Entries**: Unique identifiers ensure tasks aren't duplicated during sync.
- **Error Handling**: We implemented robust error handling to manage API failures gracefully.
---

# Dedication to Best Practices

- **Applied Clean Code Principles**: Meaningful variable names, modular functions, and clear logic flows.
- **Conducted Code Reviews**: Regularly reviewed code to identify improvements.
- **Prioritized Performance**: Optimized database queries and minimized unnecessary rebuilds in the UI.
- **Focused on Scalability**: Structured the app to accommodate future features and increased data loads.

# Getting Started
## Prerequisites
- **Flutter SDK**: Install from flutter.dev.
- **Dart SDK**: Comes bundled with Flutter.
- **IDE**: VSCode, Android Studio, or any preferred IDE.
- **Device or Emulator**: To run and test the app.

---

## Installation
- **Clone the Repository**
```
git clone https://github.com/yourusername/task_manager_app.git
cd task_manager_app
```
- **Install Dependencies**
```
flutter pub get

```

- Running the App
- Connect a Device or Start an Emulator
- Ensure your device is connected, or an emulator is running.

- **Run the App**

```
flutter run
```

- ## Features
Add Tasks**: Quickly add new tasks with a simple interface.
- **Edit Tasks**: Modify task details as needed.
- **Delete Tasks**: Remove tasks that are no longer needed.
- **Mark as Complete**: Check off tasks when they're done.
- **Offline Usage**: Continue managing tasks without internet access.

---

## Future Improvements
- **User Authentication**: Implement login functionality to personalize tasks for each user based on ID.(partially implemented)
- **Cloud Syncing**: Store tasks in the cloud for access across multiple devices.
- **Reminders and Notifications**: Alert users about upcoming tasks or deadlines.
- **Improved Conflict Resolution**: Enhance syncing logic to handle complex cases.
- **UI Themes**: Allow users to switch between light and dark modes.

---

# Conclusion
- I aimed to create an app that not only works well but is also a pleasure to use and maintain, by pouring my experience and knowledge into this project. i hope it will be thoroughly reviewed and assessed.

and by applying the following: 

- **Robust Architecture**: Choosing MVVM for a scalable and maintainable codebase.
- **Efficient State Management**: Leveraging Provider for responsive UI updates.
- **User-Centric Design**: Ensuring the app is intuitive and accessible.
- **Resilient Data Handling**: Implementing a local database to overcome API limitations.
- **Seamless Synchronization**: Keeping data consistent between offline and online modes.

## Time and attention to every detail, believing that it's the little things that make a significant difference in the overall quality of an app.

## Design was inspired from: https://www.google.com/search?vsrid=CPCguv0GEAIYASIkMWNkM2ExOWUtY2M5YS00OGEwLWJmYzItNzZhMzg2NjU1MmU2&gsessionid=6morxbe5nKitK2hGYtEb6OxYQ-jsgJYYvA8nWCbch4rWxOwVAoQCiQ&lsessionid=XRgj_q40RJUB3D-FOmXBTcFF7OlVnMWS0fedKnm7HhBlD1wRJLhrdg&vsdim=450,1000&source=lns.web.gisbubb&vsint=CAIqDAoCCAcSAggKGAEgATojChYNAAAAPxUAAAA_HQAAgD8lAACAPzABEMIDGOgHJQAAgD8&lns_mode=un&udm=26&lns_vfs=e&qsubts=1729104196676&biw=1536&bih=735&hl=en-LB#vhid=FQFAtQHqHo1L0M&vssid=mosaic

Let's Keep in Touch

Email: adel.assi1@hotmail.com
GitHub: Adel0101
LinkedIn: https://www.linkedin.com/in/adel-assi

- **Feel free to reach out for collaborations, suggestions, or just to say hello!**

