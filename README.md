# Gymify

## Project Overview

**Gymify** is a comprehensive platform designed to manage all aspects of a gym, including user management, workout tracking, diet planning, gym attendance, and communication between trainers and users. This project features an **admin panel built with React**, a **mobile app for users developed with Flutter**, and a **backend API built using Express.js** with a PostgreSQL database for data management.


- **Admin Panel**: A React-based web application for gym administrators and trainers
- **Mobile App**: A Flutter application for gym members
- **Backend API**: An Express.js server with PostgreSQL database

## Key Features

### User Management
- User registration and authentication
- Role-based access (Member, Trainer, Admin)
- Profile management with fitness metrics tracking
- Weight and progress tracking

### Workout Management
- Predefined workout plans created by trainers
- Custom workout creation for members
- Exercise library with descriptions and demonstration videos/images
- Workout logs to track performance and progress

### Diet Planning and Tracking
- Diet plans created by trainers with calorie goals
- Meal logging and tracking
- Nutritional information and macronutrient tracking
- Diet progress reports

### Attendance Tracking
- Check-in/check-out system
- Attendance history and streak tracking
- Attendance analytics

### Subscriptions and Payments
- Multiple membership plan options
- Payment processing with status tracking
- Subscription management and renewal notifications
- Revenue reporting and analytics

### Communication
- Chat system between members and trainers
- Notifications for workouts, diet plans, and gym updates
- Feedback system

### Analytics
- User growth and demographics
- Attendance patterns
- Revenue reporting
- Workout and diet adherence metrics

## Tech Stack

### Frontend
- **Admin Panel**: React, Tailwind CSS, Recharts for data visualization
- **Mobile App**: Flutter

### Backend
- **Server**: Express.js (Node.js)
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Tokens)
- **File Storage**: Cloudinary for image and video uploads

## Installation and Setup

### Prerequisites
- **Node.js** (v18+)
- **npm** or **yarn** package manager
- **PostgreSQL** database server
- **Flutter SDK** (for mobile app)
- **Docker** (optional, for containerized deployment)

### Backend Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/aashishrauniyar/fyp-gymify.git
   cd fyp-gymify
   ```

2. **Setup the backend**:
    ```bash
    cd be
    npm install
    ```

3. **Configure environment variables**:
   Create a `.env` file in the `be` directory with the following variables:
   ```
   DATABASE_URL="postgresql://username:password@localhost:5432/gymify"
   JWT_SECRET="your-jwt-secret-key"
   PORT=3000
   CLOUDINARY_CLOUD_NAME="your-cloud-name"
   CLOUDINARY_API_KEY="your-api-key"
   CLOUDINARY_API_SECRET="your-api-secret"
   ```

4. **Set up the database**:
   ```bash
   # Create database tables from schema
   npx prisma migrate deploy
   
   # Optional: Seed the database with initial data
   npm run seed
   ```

5. **Start the backend server**:
   ```bash
   npm start
   ```
   For development with auto-reload:
   ```bash
   npm run dev
   ```

### Frontend Admin Panel Setup

1. **Navigate to the frontend directory**:
   ```bash
   cd ../fe
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment variables**:
   Create a `.env` file in the `fe` directory:
   ```
   VITE_API_BASE_URL=http://localhost:3000/api
   ```

4. **Start the development server**:
   ```bash
   npm run dev
   ```

5. **Build for production**:
   ```bash
   npm run build
   ```

### Mobile App Setup

1. **Navigate to the Flutter app directory**:
   ```bash
   cd ../flutter/gymify
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**:
   Update the API base URL in `lib/config/api_config.dart`

4. **Run on a device or emulator**:
   ```bash
   flutter run
   ```

5. **Build APK for Android**:
   ```bash
   flutter build apk
   ```

### Docker Deployment

1. **Build and run the backend with Docker**:
   ```bash
   cd be
   docker build -t gymify-backend -f DockerFile .
   docker run -p 3000:3000 --env-file .env gymify-backend
   ```

2. **Build and run the frontend with Docker**:
   ```bash
   cd ../fe
   docker build -t gymify-frontend -f Dockerfile .
   docker run -p 80:80 gymify-frontend
   ```

## API Documentation

The backend provides a RESTful API with the following key endpoints:

### Authentication
- `POST /api/auth/register`: Register a new user
- `POST /api/auth/login`: Login and receive JWT token

### Users
- `GET /api/users/profile`: Get current user profile
- `PUT /api/users/profile`: Update user profile
- `PUT /api/users/weight`: Log new weight measurement

### Workouts
- `GET /api/workouts`: Get all available workouts
- `POST /api/workouts`: Create a new workout (Trainer/Admin)
- `GET /api/workouts/:id`: Get specific workout details
- `POST /api/workouts/:id/exercises`: Add exercise to a workout

### Exercises
- `GET /api/exercises`: Get all exercises
- `POST /api/exercises`: Create a new exercise (Trainer/Admin)
- `GET /api/exercises/:id`: Get specific exercise details

### Diet
- `GET /api/diet-plans`: Get user's diet plans
- `POST /api/diet-plans`: Create a new diet plan (Trainer/Admin)
- `POST /api/meals/log`: Log a consumed meal

### Attendance
- `POST /api/attendance/check-in`: Record gym attendance
- `GET /api/attendance/history`: Get attendance history

### Payments
- `GET /api/payments`: Get payment history
- `POST /api/payments`: Process a new payment

### Analytics
- `GET /api/admin/dashboard/stats`: Get overall statistics
- `GET /api/admin/dashboard/revenue`: Get revenue reports
- `GET /api/admin/dashboard/user-growth`: Get user growth analytics

## User Roles and Permissions

1. **Admin**
   - Access to all features
   - Manage users, trainers, memberships
   - View comprehensive analytics
   - Configure system settings

2. **Trainer**
   - Create and manage workout plans
   - Create and assign diet plans
   - Monitor member progress
   - Communicate with assigned members

3. **Member**
   - View assigned workout and diet plans
   - Track personal progress
   - Log workouts and meals
   - Communicate with trainers

# Business Rules

### **1. Users**

- A user has attributes: user_name, full_name, address, age, height, current_weight, gender, email, password, phone number, role, fitness level, goal type, card number, created_at, and updated_at.
- A user has one active membership at a time.
- A user has attendance records to track gym visits.
- A user has the ability to view exercises and predefined workout plans.
- A user has the capability to create custom workouts by adding predefined exercises to them.
- A user has diet plans and logs their diet intake.
- A user has the ability to make payments for memberships using methods such as Khalti.
- A user has the option to participate in chat conversations with trainers and receive notifications.
- **Uniqueness**: Each user has a unique email and phone number.
- **Optional or Mandatory**:
    - **Mandatory**: user_name, full_name, email, password, phone_number, address, fitness_level, goal_type, current_weight, height.
    - **Optional**: profile image, card_number.

---

### **2. Memberships**

- A membership has a plan_type, start_date, end_date, status, created_at, and updated_at.
- A membership is unique to each user and is associated with a specific gym.
- **Uniqueness**: Each membership is unique to a user_id.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, plan_type, start_date, end_date, status.

---

### **3. Payments**

- A payment has attributes: membership_id, user_id, amount_paid, payment_method, transaction_id, payment_date, and payment_status.
- A payment is linked to a specific user’s membership.
- A payment has status options such as paid, pending, or failed.
- **Uniqueness**: Each payment has a unique transaction_id.
- **Optional or Mandatory**:
    - **Mandatory**: membership_id, user_id, amount_paid, payment_method, payment_date, payment_status.

---

### **4. Workouts**

- A workout has attributes: workout_name, description, target muscle group, difficulty, created_at, and updated_at.
- A workout is created by a trainer and has multiple exercises.
- **Uniqueness**: Each workout has a unique workout_name per trainer.
- **Optional or Mandatory**:
    - **Mandatory**: workout_name, description, target muscle group, difficulty.

---

### **5. Exercises**

- An exercise has attributes: exercise_name, calories burned per minute, and created_at.
- An exercise is included in multiple workouts.
- **Uniqueness**: Each exercise has a unique exercise_name.
- **Optional or Mandatory**:
    - **Mandatory**: exercise_name, calories burned per minute.

---

### **6. WorkoutExercises**

- The WorkoutExercises table links workouts to exercises and has attributes: workout_id, exercise_id, sets, reps, and duration.
- **Uniqueness**: Each entry in the WorkoutExercises table has a unique combination of workout_id and exercise_id.
- **Optional or Mandatory**:
    - **Mandatory**: workout_id, exercise_id, sets, reps, duration.

---

### **7. CustomWorkouts**

- A custom workout has attributes: custom_workout_name, created_at.
- A custom workout is created by a user and has multiple predefined exercises.
- **Uniqueness**: Each custom workout is unique to a user.
- **Optional or Mandatory**:
    - **Mandatory**: custom_workout_name.

---

### **8. CustomWorkoutExercises**

- Links exercises to custom workouts with attributes: custom_workout_id, exercise_id, sets, reps, duration.
- **Uniqueness**: Each entry in CustomWorkoutExercises has a unique combination of custom_workout_id and exercise_id.
- **Optional or Mandatory**:
    - **Mandatory**: custom_workout_id, exercise_id, sets, reps, duration.

---

### **9. DietPlans**

- A diet plan has attributes: calorie_goal, goal_type, description, created_at, and updated_at.
- A diet plan is created by a trainer and includes multiple meals.
- **Uniqueness**: Each diet plan has a unique goal_type per user.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, trainer_id, calorie_goal, goal_type, description.

---

### **10. Meals**

- A meal has attributes: meal_name, meal_time, calories, description, macronutrients, and created_at.
- A meal is part of a diet plan and is assigned to a specific time of day (e.g., breakfast).
- **Uniqueness**: Each meal has a unique meal_name within a diet plan.
- **Optional or Mandatory**:
    - **Mandatory**: meal_name, meal_time, calories, description.

---

### **11. DietLogs**

- DietLogs track a user's diet intake with attributes: diet_plan_id, meal_id, consumed_calories, custom_meal, notes, log_date.
- **Uniqueness**: Each diet log entry has a unique combination of user_id and log_date.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, diet_plan_id, meal_id, consumed_calories, log_date.

---

### **12. WorkoutLogs**

- WorkoutLogs track a user's workouts with attributes: workout_date, start_time, end_time, total_duration, calories_burned, performance_notes.
- **Uniqueness**: Each workout log entry has a unique combination of user_id and workout_date.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, workout_id, workout_date, start_time, end_time, total_duration.

---

### **13. WorkoutExercisesLogs**

- Tracks each exercise completed in a workout session with attributes: workout_log_id, exercise_id, start_time, end_time, exercise_duration, rest_duration, and skipped.
- **Uniqueness**: Each entry has a unique combination of workout_log_id and exercise_id.
- **Optional or Mandatory**:
    - **Mandatory**: workout_log_id, exercise_id, start_time, end_time, exercise_duration.

---

### **14. Attendance**

- Tracks gym attendance with attributes: user_id, gym_id, attendance_date, and status.
- **Uniqueness**: Each attendance record is unique for a combination of user_id, gym_id, and attendance_date.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, gym_id, attendance_date, status.

---

### **15. Notifications**

- Users receive notifications with attributes: message, is_read, created_at.
- Notifications inform users of updates, reminders, or alerts.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, message, is_read.

---

### **16. ChatConversations**

- Chat conversations include user_id, trainer_id, last_message, and last_message_timestamp.
- **Uniqueness**: Each chat conversation has a unique combination of user_id and trainer_id.
- **Optional or Mandatory**:
    - **Mandatory**: user_id, trainer_id, last_message.

---

### **17. ChatMessages**

- ChatMessages include chat_id, sender_id, message_content, sent_at, and is_read.
- Each chat conversation has multiple messages.
- **Uniqueness**: Each chat message entry is unique to a chat_id.
- **Optional or Mandatory**:
    - **Mandatory**: chat_id, sender_id, message_content, sent_at.

// image
![ERD](./ERD.png)
