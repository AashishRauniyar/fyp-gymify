# Business Rules
### User

- A user has user name, full name, email, password, phone number, password, profile image, address, fitness level, goal, current weight and height.
- A user has a subscription at a time
- A user have its attendance tracked
- A user views exercises and workout
- A user can make custom workout and add predefined exercise to it.
- A user pays for its subscription using Esewa
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