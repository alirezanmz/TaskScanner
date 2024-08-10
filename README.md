# TaskScanner App

TaskScanner is an iOS application that allows users to view and manage tasks retrieved from a remote API. The app supports offline data persistence using Core Data, QR code scanning to quickly search tasks, and a pull-to-refresh feature for easy data updates.

## Features

- **QR Code Scanning**: Users can scan QR codes to quickly search for tasks. The scanned QR code text is automatically set as the search query.
- **Offline Data Persistence**: Tasks are stored locally using Core Data, ensuring users can view and search tasks even without an internet connection.
- **Pull-to-Refresh**: Users can refresh their task list by pulling down on the table view, ensuring they always have the latest data.

## Architecture

The TaskScanner app is built using the **Model-View-ViewModel (MVVM)** architecture. This design pattern helps separate concerns and makes the codebase more modular, testable, and maintainable.

- **Model**: Represents the data layer of the app. In this app, the `Assignment` struct and Core Data entities represent the model.
- **View**: The user interface components, such as `TaskViewController`, display data and capture user interactions.
- **ViewModel**: The `TaskViewModel` handles the business logic and data manipulation, interacts with the Model, and updates the View with the necessary data.

## Usage

### QR Code Scanning

- Tap the QR code icon in the navigation bar to open the QR scanner.
- Align the QR code within the camera view. Once a QR code is detected, it will automatically set the search query and filter the task list.

### Pull-to-Refresh

- Pull down on the task list to refresh the data.
- The app will fetch the latest tasks from the server, or load them from Core Data if offline.

### Offline Usage

- The app automatically saves fetched tasks to Core Data, allowing offline access to tasks.
- When offline, the app loads tasks from Core Data, ensuring seamless access.

## Core Data

The app uses Core Data to store tasks locally. This ensures that tasks are available offline and that the app can operate smoothly without requiring a constant internet connection.

## Acknowledgements

- [AVFoundation](https://developer.apple.com/documentation/avfoundation) for the QR code scanning functionality.
- [Core Data](https://developer.apple.com/documentation/coredata) for offline data persistence.

---

### Additional Notes

- **Testing**: Ensure you have the correct API endpoints and access permissions before running the app.
