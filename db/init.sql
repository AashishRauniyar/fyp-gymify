-- Create Users Table
CREATE TABLE IF NOT EXISTS Users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    address VARCHAR(255) NOT NULL,
    fitness_level FITNESS_LEVEL NOT NULL,    -- ENUM
    goal GOAL_TYPE NOT NULL,                 -- ENUM
    current_weight DECIMAL NOT NULL,
    height DECIMAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ENUM types for fitness level and goal type
CREATE TYPE FITNESS_LEVEL AS ENUM ('Beginner', 'Intermediate', 'Advanced');
CREATE TYPE GOAL_TYPE AS ENUM ('Weight Loss', 'Muscle Gain', 'Endurance', 'Maintenance');

-- Create Admins Table (Gym Owner)
CREATE TABLE IF NOT EXISTS Admins (
    admin_id SERIAL PRIMARY KEY,
    admin_name VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create gym Table (Single Gym Entry)
CREATE TABLE IF NOT EXISTS gym (
    gym_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    capacity INT,
    admin_id INT REFERENCES Admins(admin_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Trainers Table
CREATE TABLE IF NOT EXISTS Trainers (
    trainer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    status TRAINER_STATUS,           -- ENUM
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ENUM for trainer status
CREATE TYPE TRAINER_STATUS AS ENUM ('Active', 'Inactive');

-- Create Subscriptions Table (Referencing the Single Gym)
CREATE TABLE IF NOT EXISTS Subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    gym_id INT REFERENCES gym(gym_id) ON DELETE CASCADE,  -- Keeps gym_id reference
    plan PLAN_TYPE,              -- ENUM
    start_date DATE,
    end_date DATE,
    price DECIMAL(10, 2),
    payment_status PAYMENT_STATUS,     -- ENUM
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ENUM types for plan and payment status
CREATE TYPE PLAN_TYPE AS ENUM ('Monthly', 'Yearly', 'Weekly');
CREATE TYPE PAYMENT_STATUS AS ENUM ('Paid', 'Pending', 'Failed');

-- Create Payments Table
CREATE TABLE IF NOT EXISTS Payments (
    payment_id SERIAL PRIMARY KEY,
    subscription_id INT REFERENCES Subscriptions(subscription_id) ON DELETE CASCADE,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    amount_paid DECIMAL(10, 2),
    payment_date DATE,
    payment_status PAYMENT_STATUS      -- ENUM
);

-- Create Attendance Table (Still Referencing the Gym)
CREATE TABLE IF NOT EXISTS Attendance (
    attendance_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    gym_id INT REFERENCES gym(gym_id) ON DELETE CASCADE,  -- Keeps gym_id reference
    card_number VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attendance_date DATE,
    status ATTENDANCE_STATUS              -- ENUM
);

-- Create ENUM for attendance status
CREATE TYPE ATTENDANCE_STATUS AS ENUM ('Present', 'Absent');

-- Create Workouts Table
CREATE TABLE IF NOT EXISTS Workouts (
    workout_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    target_muscle_group VARCHAR(50),
    duration INT,
    difficulty DIFFICULTY_LEVEL,          -- ENUM
    trainer_id INT REFERENCES Trainers(trainer_id) ON DELETE CASCADE
);

-- Create ENUM for workout difficulty level
CREATE TYPE DIFFICULTY_LEVEL AS ENUM ('Easy', 'Intermediate', 'Hard');

-- Create Custom_Workouts Table
CREATE TABLE IF NOT EXISTS Custom_Workouts (
    custom_workout_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Create Exercises Table
CREATE TABLE IF NOT EXISTS Exercises (
    exercise_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    target_muscle_group VARCHAR(50),
    calories_burned_per_minute DECIMAL(5, 2)
);

-- Create Exercise_Workout Table
CREATE TABLE IF NOT EXISTS Exercise_Workout (
    workout_id INT REFERENCES Workouts(workout_id) ON DELETE CASCADE,
    exercise_id INT REFERENCES Exercises(exercise_id) ON DELETE CASCADE,
    sets INT,
    reps INT,
    "order" INT,
    duration DECIMAL(5, 2),
    PRIMARY KEY (workout_id, exercise_id)
);

-- Create Diet_Plans Table
CREATE TABLE IF NOT EXISTS Diet_Plans (
    diet_plan_id SERIAL PRIMARY KEY,
    trainer_id INT REFERENCES Trainers(trainer_id) ON DELETE CASCADE,
    name VARCHAR(100),
    description TEXT,
    goal GOAL_TYPE                       -- ENUM
);

-- Create Meals Table
CREATE TABLE IF NOT EXISTS Meals (
    meal_id SERIAL PRIMARY KEY,
    diet_plan_id INT REFERENCES Diet_Plans(diet_plan_id) ON DELETE CASCADE,
    meal_name VARCHAR(100),
    calories DECIMAL(5, 2),
    description TEXT,
    time_of_day MEAL_TIME                 -- ENUM
);

-- Create ENUM for meal time
CREATE TYPE MEAL_TIME AS ENUM ('Breakfast', 'Lunch', 'Dinner', 'Snack');

-- Create User_Diet_Tracking Table
CREATE TABLE IF NOT EXISTS User_Diet_Tracking (
    user_diet_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    current_weight DECIMAL(5, 2),
    height DECIMAL(5, 2),
    BMI DECIMAL(5, 2),
    calorie_goal DECIMAL(6, 2),
    weight_goal DECIMAL(5, 2),
    goal_type GOAL_TYPE                   -- ENUM
);

-- Create Diet_Logs Table
CREATE TABLE IF NOT EXISTS Diet_Logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    logged_weight DECIMAL(5, 2),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Chat_Conversations Table
CREATE TABLE IF NOT EXISTS Chat_Conversations (
    chat_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    trainer_id INT REFERENCES Trainers(trainer_id) ON DELETE CASCADE,
    last_message TEXT,
    last_message_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Chat_Messages Table
CREATE TABLE IF NOT EXISTS Chat_Messages (
    message_id SERIAL PRIMARY KEY,
    chat_id INT REFERENCES Chat_Conversations(chat_id) ON DELETE CASCADE,
    sender_id INT,                 -- Either the user_id or trainer_id, to be handled by the application logic
    message_content TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);

-- Create User_Streaks Table
CREATE TABLE IF NOT EXISTS User_Streaks (
    streak_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    current_streak INT,
    best_streak INT,
    last_attendance_date DATE
);

-- Create Streak_Rewards Table
CREATE TABLE IF NOT EXISTS Streak_Rewards (
    reward_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    reward_type VARCHAR(100),
    achieved_streak INT,
    claimed BOOLEAN DEFAULT FALSE
);
