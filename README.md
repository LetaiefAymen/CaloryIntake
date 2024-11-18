
# CaloryIntake

CaloryIntake is an case study iOS application designed to help users monitor and manage their daily calorie intake, this case study is made to showcase some of my skills and architectural patterns.

## Table of Contents

1. [Project Overview](#project-overview)
5. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Setup Instructions](#setup-instructions)
5. [Architecture](#architecture)
6. [API Integration](#api-integration)
7. [Challenges and Solutions](#challenges-and-solutions)
8. [Testing](#testing)
9. [Future Enhancements](#future-enhancements)
10. [Setup Instructions](#setup-instructions)

## Project Overview

CaloryIntake empowers users to log their meals and snacks, providing insights into their calorie consumption patterns.
The app aims to assist users in achieving their dietary goals by offering a user-friendly interface for tracking caloric intake.

![Recording_iPhone_16_Pro_6 3_2024-11-18_10 54 05](https://github.com/user-attachments/assets/b0316e54-0a24-4a16-83b4-760c3133143d)

### Use cases
#### Use Case 1: Monitor Daily Nutritional Intake
Description:
The user monitors their daily intake of calories, proteins, and fats in an easy-to-understand summary view.

#### Use Case 2: Log a Meal
Description:
The user logs a meal, specifying the meal type (e.g., breakfast, lunch, dinner, snack) and selecting food items. After logging, the meal details contribute to the daily nutritional summary.
Outcome: The user sees the meal added to their list of logged meals, and the daily totals are updated accordingly.

## Features

- **Meal Logging:** Users can add, edit, and delete meal entries with associated calorie information.
- **Daily Summary:** Provides a summary of total calories consumed each day.
- **Data Persistence:** Utilizes CoreData to store user entries persistently.

## Tech Stack

- **Language:** Swift
- **Frameworks:** SwiftUI
- **Networking:** URLSession
- **Storage:** CoreData, InMemory
- **Design Patterns:** MVVM (Model-View-ViewModel), Observer, Singleton, Composite

## Architecture

The app is divided on 2 modules:
- **CaloryIntakeCore module**: this module contains the Networking and Storage layers, I have kept it seperate as it does not include any UI and therefore can be tested on macOS which is much faster when applying TDD.
- **CaloryIntake module**: this module contains the rest of the layers, it's using SwiftUI as the UI layer with the MVVM UI design pattern.

## API Integration

The application integrates with an external API to fetch nutritional information for various food items.

- **API Endpoint:** [https://jsonblob.com/api/jsonBlob/1305245062454435840](https://jsonblob.com/api/jsonBlob/1305245062454435840)
- **Usage:** In the meal logging use case, the app queries the API to retrieve the list of food and their nutritional values, those data will be used once the user logs their meal to calculate their consumption for the day.
- **Networking:** URLSession is used for making asynchronous HTTP requests to the API.

## Challenges and Solutions

- **Data Persistence:** Implemented InMemory persistance and CoreData persistance to ensure user data is saved and retrievable across app launches.
- **User Interface Design:** Leveraged SwiftUI's declarative syntax for creating an intuitive and responsive UI.
- **API Integration:** Managed asynchronous data fetching and parsing using URLSession for seamless integration with external APIs.

## Testing

- **Unit Testing:** Developed unit tests for core functionalities to ensure data integrity and correct logic. The code coverage for the CaloryIntakeCore module right now is around **75%**
<img width="646" alt="Screenshot 2024-11-18 at 10 08 59" src="https://github.com/user-attachments/assets/02d0f496-f578-406e-a696-e76b22c52df3">

- **UI Testing:** Still didn't find time to include UI Testing at the moment.

## Future Enhancements

- **Daily Nutritional Analysis:** Provide daily analysis of nutrition intakes (proteins, fats, carbohydrates).
- **Goal Setting:** Allow users to set daily calorie goals and track progress.

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/LetaiefAymen/CaloryIntake.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd CaloryIntake
   ```
3. **Open the project in Xcode:**
   ```bash
   open CaloryIntake.xcodeproj
   ```
4. **Build and run the project:**
   - Select the desired simulator or connected device.
   - Press the 'Run' button or use the shortcut `Cmd + R`.
