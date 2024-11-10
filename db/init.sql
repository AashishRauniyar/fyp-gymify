-- Drop existing tables if they exist
DROP TABLE IF EXISTS ChatMessages, ChatConversations, Attendance, DietLogs, Meals, DietPlans, CustomWorkoutExercises, CustomWorkouts, WorkoutExercises, Exercises, Workouts, Payments, Memberships, Gym, Users CASCADE;




-- Drop existing ENUM types if they exist
DO $$ 
BEGIN
    DROP TYPE IF EXISTS GENDER;
    DROP TYPE IF EXISTS ROLE;
    DROP TYPE IF EXISTS FITNESS_LEVEL;
    DROP TYPE IF EXISTS GOAL_TYPE;
    DROP TYPE IF EXISTS PLAN_TYPE;
    DROP TYPE IF EXISTS MEMBERSHIP_STATUS;
    DROP TYPE IF EXISTS PAYMENT_METHOD;
    DROP TYPE IF EXISTS PAYMENT_STATUS;
    DROP TYPE IF EXISTS DIFFICULTY_LEVEL;
    DROP TYPE IF EXISTS MEAL_TIME;
    DROP TYPE IF EXISTS ATTENDANCE_STATUS;
END $$;



-- Create ENUM types for gender, role, fitness level, and goal type
CREATE TYPE GENDER AS ENUM ('Male', 'Female', 'Other');
CREATE TYPE ROLE AS ENUM ('Member', 'Trainer', 'Admin');
CREATE TYPE FITNESS_LEVEL AS ENUM ('Beginner', 'Intermediate', 'Advanced', 'Athlete');
CREATE TYPE GOAL_TYPE AS ENUM ('Weight Loss', 'Muscle Gain', 'Endurance', 'Maintenance', 'Flexibility');

-- Create ENUM types for plans, payments, attendance, difficulty levels, and meal times
CREATE TYPE PLAN_TYPE AS ENUM ('Monthly', 'Yearly', 'Quaterly');
CREATE TYPE MEMBERSHIP_STATUS AS ENUM ('Active', 'Expired', 'Cancelled');
CREATE TYPE PAYMENT_METHOD AS ENUM ('Esewa', 'Khalti', 'CreditCard');
CREATE TYPE PAYMENT_STATUS AS ENUM ('Paid', 'Pending', 'Failed');
CREATE TYPE DIFFICULTY_LEVEL AS ENUM ('Easy', 'Intermediate', 'Hard');
CREATE TYPE MEAL_TIME AS ENUM ('Breakfast', 'Lunch', 'Dinner', 'Snack');
CREATE TYPE ATTENDANCE_STATUS AS ENUM ('Present', 'Absent');

-- Create Users Table
CREATE TABLE IF NOT EXISTS Users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    age INT,
    height DECIMAL NOT NULL,
    current_weight DECIMAL NOT NULL,
    gender GENDER NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    role ROLE NOT NULL,
    fitness_level FITNESS_LEVEL NOT NULL,
    goal_type GOAL_TYPE NOT NULL,
    card_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create Gym Table
CREATE TABLE IF NOT EXISTS Gym (
    gym_id SERIAL PRIMARY KEY,
    gym_name VARCHAR(100) UNIQUE NOT NULL,
    location VARCHAR(255) NOT NULL,
    contact_number VARCHAR(20) UNIQUE NOT NULL,
    admin_id INT REFERENCES Users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Memberships Table
CREATE TABLE IF NOT EXISTS Memberships (
    membership_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    plan_type PLAN_TYPE NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status MEMBERSHIP_STATUS NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Payments Table
CREATE TABLE IF NOT EXISTS Payments (
    payment_id SERIAL PRIMARY KEY,
    membership_id INT REFERENCES Memberships(membership_id) ON DELETE CASCADE,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    price DECIMAL(10, 2) NOT NULL,
    payment_method PAYMENT_METHOD NOT NULL,
    khalti_payload VARCHAR(100) UNIQUE NOT NULL,
    payment_date DATE NOT NULL,
    payment_status PAYMENT_STATUS NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Workouts Table
CREATE TABLE IF NOT EXISTS Workouts (
    workout_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    workout_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    target_muscle_group VARCHAR(50) NOT NULL,
    difficulty DIFFICULTY_LEVEL NOT NULL,
    trainer_id INT REFERENCES Users(user_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Exercises Table
CREATE TABLE IF NOT EXISTS Exercises (
    exercise_id SERIAL PRIMARY KEY,
    exercise_name VARCHAR(100) UNIQUE NOT NULL,
    calories_burned_per_minute DECIMAL(5, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create WorkoutExercises Table
CREATE TABLE IF NOT EXISTS WorkoutExercises (
    workout_exercise_id SERIAL PRIMARY KEY,
    workout_id INT REFERENCES Workouts(workout_id) ON DELETE CASCADE,
    exercise_id INT REFERENCES Exercises(exercise_id) ON DELETE CASCADE,
    sets INT NOT NULL,
    reps INT NOT NULL,
    duration DECIMAL(5, 2) NOT NULL
);

-- Create CustomWorkouts Table
CREATE TABLE IF NOT EXISTS CustomWorkouts (
    custom_workout_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    custom_workout_name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create CustomWorkoutExercises Table
CREATE TABLE IF NOT EXISTS CustomWorkoutExercises (
    custom_workout_exercise_id SERIAL PRIMARY KEY,
    custom_workout_id INT REFERENCES CustomWorkouts(custom_workout_id) ON DELETE CASCADE,
    exercise_id INT REFERENCES Exercises(exercise_id) ON DELETE CASCADE,
    sets INT NOT NULL,
    reps INT NOT NULL,
    duration DECIMAL(5, 2) NOT NULL
);

-- Create DietPlans Table
CREATE TABLE IF NOT EXISTS DietPlans (
    diet_plan_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    trainer_id INT REFERENCES Users(user_id) ON DELETE SET NULL,
    calorie_goal DECIMAL(6, 2),
    goal_type GOAL_TYPE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Meals Table
CREATE TABLE IF NOT EXISTS Meals (
    meal_id SERIAL PRIMARY KEY,
    diet_plan_id INT REFERENCES DietPlans(diet_plan_id) ON DELETE CASCADE,
    meal_name VARCHAR(100) UNIQUE NOT NULL,
    meal_time MEAL_TIME NOT NULL,
    calories DECIMAL(5, 2) NOT NULL,
    description TEXT,
    macronutrients VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create DietLogs Table
CREATE TABLE IF NOT EXISTS DietLogs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    diet_plan_id INT REFERENCES DietPlans(diet_plan_id),
    meal_id INT REFERENCES Meals(meal_id),
    consumed_calories DECIMAL(5, 2),
    custom_meal VARCHAR(100),
    notes TEXT,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Attendance Table
CREATE TABLE IF NOT EXISTS Attendance (
    attendance_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    gym_id INT,
    attendance_date DATE NOT NULL,
    status ATTENDANCE_STATUS NOT NULL
);

-- Create ChatConversations Table
CREATE TABLE IF NOT EXISTS ChatConversations (
    chat_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    trainer_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    last_message VARCHAR(255),
    last_message_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create ChatMessages Table
CREATE TABLE IF NOT EXISTS ChatMessages (
    message_id SERIAL PRIMARY KEY,
    chat_id INT REFERENCES ChatConversations(chat_id) ON DELETE CASCADE,
    sender_id INT,
    message_content JSON,  -- json to store messaged and image (image url if the user sends image) , workout id if the trainer sends workouts
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE
);
