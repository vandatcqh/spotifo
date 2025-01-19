# spotifo

FINAL TERM PROJECT _ 22CNTN _ Mobile Device Application Development  

# Flutter Application with Firebase Integration

This repository contains a Flutter application built with a clean architecture pattern, leveraging Firebase for backend services. The app integrates multiple Firebase services, including **Firebase Authentication**, **Cloud Firestore**, **Cloud Functions**, and **Firebase Storage**, to provide a seamless user experience.

## Features

- **Authentication**: User sign-in and sign-up using Firebase Authentication (Email/Password, Google, etc.).
- **Cloud Functions**: Serverless functions for executing backend logic.
- **Firebase Storage**: Secure file storage and retrieval.

## Project Architecture

The application follows a **clean architecture** approach with the following layers:

1. **Presentation Layer**: Flutter UI components with state management using `Cubit` or `BLoC`.
2. **Domain Layer**: Business logic, use cases, and interfaces.
3. **Data Layer**: Repositories and data sources for Firebase integration.

## Dependencies

Here are the main dependencies used in the project:

- **flutter_bloc**: For state management.
- **firebase_auth**: Firebase Authentication.
- **cloud_firestore**: Firestore database integration.
- **firebase_storage**: Firebase Storage for file uploads.
- **firebase_core**: Core Firebase functionality.
