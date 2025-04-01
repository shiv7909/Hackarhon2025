# Flutter Project

## Overview

This project is a cross-platform application built using the Flutter framework. It supports web, Android, and iOS platforms. The application leverages various packages to enhance its functionality and user interface.

## Tools Used

- **Framework:** Flutter (supports web, Android, and iOS applications)
- **IDE:** VSCodium

## Packages Used

- `cupertino_icons: ^1.0.6`
- `get: ^4.7.2`
- `flutter_svg: ^2.0.5`
- `animated_text_kit: ^4.2.2`
- `glassmorphism: ^3.0.0`
- `google_fonts: ^5.1.0`

## Prerequisites

- Flutter SDK
- An IDE (e.g., VSCodium)

## Setup Instructions

1. **Create a Flutter Project:**
   - Open your terminal or command prompt.
   - Run the command: `flutter create your_project_name`

2. **Add the Library:**
   - Copy the `lib` folder from this repository into your created project.

3. **Add Required Packages:**
   - Open `pubspec.yaml` in your project.
   - Add the required packages under dependencies:
     ```yaml
     dependencies:
       flutter:
           cupertino_icons: ^1.0.6
  get: ^4.7.2
  flutter_svg: ^2.0.5
  animated_text_kit: ^4.2.2
  glassmorphism: ^3.0.0
  google_fonts: ^5.1.0
  fl_chart: ^0.68.0
  auto_size_text: ^3.0.0
  connectivity_plus: ^3.0.3
  animate_do: ^4.2.0
  timeline_tile: ^2.0.0
  flutter_animate: ^4.2.0

  firebase_remote_config: ^4.0.1
  
  firebase_core: ^2.24.2
  cloud_firestore: ^4.5.2
  firebase_storage: ^11.2.5
  lottie: ^3.1.3
  get_storage: ^2.1.1
     ```
   - Specify the path to the assets folder:
     ```yaml
     flutter:
       assets:
         - assests/images/
         - assests/icons/
     ```

4. **Run the Application:**
   - Use the command: `flutter run -d chrome` to run the application in a web browser.



## Media

### Screenshots

### Video
