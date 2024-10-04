# Gymify

## Project Overview

**Gymify** is a comprehensive platform designed to manage all aspects of a gym, including user management, workout tracking, diet planning, gym attendance, and communication between trainers and users. This project features an **admin panel built with React**, a **mobile app for users developed with Flutter**, and a **backend API built using Express.js** with a PostgreSQL database for data management.

### Key Features

- **User Management**: Users can create profiles, track their fitness goals, and manage their subscriptions to gyms. Trainers and gym owners have separate management interfaces to monitor and assist users.
- **Workout Management**: Trainers can create and assign predefined workouts, while users can create their own custom workout plans. Workouts are linked to exercises, which include details like calories burned and target muscle groups.
- **Diet Planning and Tracking**: Trainers can create diet plans for users, which include multiple meals with calorie and nutrition information. Users can track their diets, weight, BMI, and set calorie goals based on their fitness objectives (weight loss, muscle gain, maintenance).
- **Attendance Tracking**: Gym attendance is tracked using RFID cards, allowing users to log their gym visits. The system keeps a record of streaks (consecutive days of attendance), and users can earn rewards for maintaining their attendance streaks.
- **Subscriptions and Payments**: Users can subscribe to gyms with different plans (monthly, yearly, etc.), and payments are processed with a status tracking system. Subscription details, start/end dates, and payment statuses are managed efficiently.
- **Chat System**: Integrated chat feature that allows users to communicate directly with trainers for guidance and feedback.
- **Admin Panel**: Gym owners and admins can monitor gym activity, user subscriptions, payments, and more through a React-based admin dashboard.
- **Mobile App**: Users access the system via a Flutter-based mobile application, allowing them to view workout plans, diet progress, track attendance, and chat with trainers on the go.

## Tech Stack

### Frontend

- **Admin Panel**: Built with **React**, the admin panel offers a responsive interface for gym owners and trainers to manage users, subscriptions, and gym operations.
- **User Mobile App**: Developed using **Flutter**, providing users with a smooth and intuitive interface for tracking their progress, accessing workout plans, and managing gym attendance.

### Backend

- **Express.js**: The backend is powered by **Express.js**, which serves as the API layer for handling user data, workout plans, diet tracking, chat, and attendance. The API is designed with RESTful principles to ensure scalability and ease of use.
- **PostgreSQL**: A **PostgreSQL** database is used to manage user data, workouts, subscriptions, payments, and gym information. The schema is designed with normalization principles to ensure efficient querying and data consistency.

## Features Breakdown

### Admin Panel (React)

- Manage gym operations, including user subscriptions, payments, and workouts.
- View and track user attendance, streaks, and performance.
- Access analytics related to gym activities, user progress, and overall performance.

### Mobile App (Flutter)

- Users can sign up, create profiles, and view their workout and diet plans.
- Access a detailed view of their progress, including current weight, BMI, and attendance streaks.
- Chat directly with trainers for personalized guidance.
- Receive notifications and updates about workouts, diet plans, and gym attendance.

### Backend API (Express.js)

- Secure API endpoints for user authentication, gym management, workout and diet tracking.
- Real-time chat system for trainers and users.
- Subscription and payment handling with status tracking.

## Installation and Setup

### Prerequisites

- **Node.js** for backend (Express.js)
- **Flutter SDK** for mobile app development
- **React** for admin panel
- **PostgreSQL** for database management

### Steps to Run the Project

1. **Clone the repository**:
    
    ```bash
    bash
    Copy code
    git clone https://github.com/AashishRauniyar/fyp-gymify
    
    ```
    
2. **Backend Setup**:
    - Navigate to the backend directory:
        
        ```bash
        bash
        Copy code
        cd be
        
        ```
        
    - Install the dependencies:
        
        ```bash
        bash
        Copy code
        npm install
        
        ```
        
    - Set up the PostgreSQL database and environment variables:
        
        ```bash
        bash
        Copy code
        cp .env.example .env
        
        ```
        
    - Run the backend server:
        
        ```bash
        bash
        Copy code
        npm run dev
        
        ```
        
3. **Front end Admin Panel Setup**:
    - Navigate to the admin panel directory:
        
        ```bash
        bash
        Copy code
        cd fe
        
        ```
        
    - Install the dependencies:
        
        ```bash
        bash
        Copy code
        npm install
        
        ```
        
    - Run the admin panel in development mode:
        
        ```bash
        bash
        Copy code
        npm run dev
        
        ```
        
4. **Mobile App Setup**:
    - Navigate to the Flutter app directory:
        
        ```bash
        bash
        Copy code
        cd mobile
        
        ```
        
    - Install the dependencies:
        
        ```bash
        bash
        Copy code
        flutter pub get
        
        ```
        
    - Run the Flutter app on a device or emulator:
        
        ```bash
        bash
        Copy code
        flutter run
        
        ```
        

## More Features

- **Push Notifications**: Integrate Firebase for push notifications to alert users about workout plans, diet reminders, and gym updates.

# Business Rules
### User

- A user has user name, full name, email, password, phone number, password, profile image, address, fitness level, goal, current weight and height.
- A user has a subscription at a time
- A user have its attendance tracked
- A user views exercises and workout
- A user can make custom workout and add predefined exercise to it.
- A user pays for its subscription using khalti
- **Uniqueness**: Each user must have a unique **email** and **phone number**.
- **Optional or Mandatory**:
    - **Mandatory**: user name, full name, email, phone number, password, address, fitness level, goal, current weight, height
    - **Optional**: profile image

### Admin (Gym Owner)

- Admin has name, email, phone number and password
- A admin manages a gym
- A admin manages multiple trainers
- A admin manages multiple users
- **Uniqueness**: Each admin must have a unique **email** and **phone number**.
- **Optional or Mandatory**:
    - **Mandatory**: admin name, email, phone number, password

### Trainer

- A trainer has name, email, phone number, password and status
- A trainer creates multiple workout and diet plans for users.
- **Uniqueness**: Each trainer must have a unique **email** and **phone number**.
- **Optional or Mandatory**:
    - **Mandatory**: name, email, phone number, password, status

### Gym

- A gym has name, location, capacity
- A gym is managed by admin (gym owner)
- **Uniqueness**: gym must have a unique **name**.
- **Optional or Mandatory**:
    - **Mandatory**: name, location, capacity, admin_id
- A gym has multiple trainers and users.

### Subscription

- A subscription has plan, start date, end date, price and payment status.
- **Uniqueness**: Each subscription is unique to a  **user_id**
- **Optional or Mandatory**:
    - **Mandatory**: user_id, gym_id, plan, start_date, end_date, price, payment_status

### Payment

- A user can pay using Esewa
- A user has payment linked to subscription
- Payment status can be paid, pending and failed

### Attendance

- A attendance has user id, gym id, car number, attendance date and status
- attendance status can be present and absent
- **Uniqueness**: Each attendance record is unique to a combination of **user_id**, **gym_id**, and **attendance_date**.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, gym_id, card_number, attendance_date, status

### Workout

- A workout has name, description, target muscle group, duration and difficulty
- A workout is created by multiple trainers
- A workout has multiple exercises
- **Uniqueness**: Each workout must have a unique **name** per trainer.

### Exercise

- An exercise has name, description, target muscle group, calories burned per minute
- An exercise can be part of multiple workouts
- **Uniqueness**: Each exercise must have a unique **name**.
- **Optional or Mandatory**:
    - **Mandatory**: name, description, target muscle group, calories burned per minute

### Exercise_workout

- Exercise_Workout (Relationship between exercises and workouts)
- This table has workout_id, exercise_id, sets, reps, order and duration
- **Uniqueness**: Each entry in the Exercise_Workout table must be unique for a combination of **workout_id** and **exercise_id**.
- **Optional or Mandatory**:
    - **Mandatory**: workout_id, exercise_id, sets, reps, order, duration

### Diet plan

- A diet plan has name, description, goal and trainer id
- A diet plan is created by trainer
- A diet plan consists of multiple meals
- **Uniqueness**: Each diet plan must have a unique **name**.
- **Optional or Mandatory**:
    - **Mandatory**: trainer_id, name, description, goal

### Meal

- A meal have meal_name, description, calories and time_of_day
- A meal is a part of diet plan and linked to a specific time of day (breakfast, lunch and dinner)
- **Uniqueness**: Each meal must have a unique **meal_name** within a diet plan.
- **Optional or Mandatory**:
    - **Mandatory**: meal_name, calories, description, time_of_day

### User diet tracking

- User diet tracking has user id, current weight, height, calorie_goal, weight_goal and goal_type
- Each user have one or more diet tracking records
- **Uniqueness**: Each diet tracking record is unique to the **user_id**.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, current_weight, height, BMI, calorie_goal, weight_goal, goal_type

### Chat conversations

- Chat conversations have user id, trainer id, last message and last message timestamp
- A chat feature is available between a trainer and a user
- A user can have multiple chat conversations with different trainers

### Chat messages

- This table has chat id, sender id, message content, sent at and is_read
- A chat conversation can have multiple messages
- **Uniqueness**: Each chat message must be linked to a **chat_id**.
- **Optional or Mandatory**:
    - **Mandatory**: chat_id, sender_id, message_content, sent_at, is_read

### User Streaks

- A user streaks has user id, current streak, best streak and last attendance date
- Each user can have multiple streak records related to gym attendance.
- **Uniqueness**: Each streak record is unique to the **user_id**.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, current_streak, best_streak, last_attendance_date

### Streak Rewards

- A streak rewards have user_id, reward_type, acheived streak and claimed
- Streak will be reset to 0 if a users last attendance is absent
- Each user can receive multiple rewards based on their streaks.
- **Uniqueness**: Each reward is unique to the **user_id** and **reward_type**.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, reward_type, achieved_streak, claimed

// image
![ERD](./ERD.png)
