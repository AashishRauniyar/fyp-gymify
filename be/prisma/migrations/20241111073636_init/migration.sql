-- CreateEnum
CREATE TYPE "difficulty_level" AS ENUM ('Easy', 'Intermediate', 'Hard');

-- CreateEnum
CREATE TYPE "fitness_level" AS ENUM ('Beginner', 'Intermediate', 'Advanced', 'Athlete');

-- CreateEnum
CREATE TYPE "gender" AS ENUM ('Male', 'Female', 'Other');

-- CreateEnum
CREATE TYPE "goal_type" AS ENUM ('Weight Loss', 'Muscle Gain', 'Endurance', 'Maintenance', 'Flexibility');

-- CreateEnum
CREATE TYPE "meal_time" AS ENUM ('Breakfast', 'Lunch', 'Dinner', 'Snack');

-- CreateEnum
CREATE TYPE "membership_status" AS ENUM ('Active', 'Expired', 'Cancelled');

-- CreateEnum
CREATE TYPE "payment_method" AS ENUM ('Khalti', 'Cash');

-- CreateEnum
CREATE TYPE "payment_status" AS ENUM ('Paid', 'Pending', 'Failed');

-- CreateEnum
CREATE TYPE "plan_type" AS ENUM ('Monthly', 'Yearly', 'Quaterly');

-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('Member', 'Trainer', 'Admin');

-- CreateEnum
CREATE TYPE "role" AS ENUM ('Member', 'Trainer', 'Admin');

-- CreateTable
CREATE TABLE "attendance" (
    "attendance_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "gym_id" INTEGER,
    "attendance_date" DATE NOT NULL,

    CONSTRAINT "attendance_pkey" PRIMARY KEY ("attendance_id")
);

-- CreateTable
CREATE TABLE "chatconversations" (
    "chat_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "trainer_id" INTEGER,
    "last_message" VARCHAR(255),
    "last_message_timestamp" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "chatconversations_pkey" PRIMARY KEY ("chat_id")
);

-- CreateTable
CREATE TABLE "chatmessages" (
    "message_id" SERIAL NOT NULL,
    "chat_id" INTEGER,
    "sender_id" INTEGER,
    "message_content" JSON,
    "sent_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "is_read" BOOLEAN DEFAULT false,

    CONSTRAINT "chatmessages_pkey" PRIMARY KEY ("message_id")
);

-- CreateTable
CREATE TABLE "customworkoutexercises" (
    "custom_workout_exercise_id" SERIAL NOT NULL,
    "custom_workout_id" INTEGER,
    "exercise_id" INTEGER,
    "sets" INTEGER NOT NULL,
    "reps" INTEGER NOT NULL,
    "duration" DECIMAL(5,2) NOT NULL,

    CONSTRAINT "customworkoutexercises_pkey" PRIMARY KEY ("custom_workout_exercise_id")
);

-- CreateTable
CREATE TABLE "customworkouts" (
    "custom_workout_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "custom_workout_name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "customworkouts_pkey" PRIMARY KEY ("custom_workout_id")
);

-- CreateTable
CREATE TABLE "dietlogs" (
    "log_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "diet_plan_id" INTEGER,
    "meal_id" INTEGER,
    "consumed_calories" DECIMAL(5,2),
    "custom_meal" VARCHAR(100),
    "notes" TEXT,
    "log_date" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dietlogs_pkey" PRIMARY KEY ("log_id")
);

-- CreateTable
CREATE TABLE "dietplans" (
    "diet_plan_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "trainer_id" INTEGER,
    "calorie_goal" DECIMAL(6,2),
    "goal_type" "goal_type" NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dietplans_pkey" PRIMARY KEY ("diet_plan_id")
);

-- CreateTable
CREATE TABLE "exercises" (
    "exercise_id" SERIAL NOT NULL,
    "exercise_name" VARCHAR(100) NOT NULL,
    "calories_burned_per_minute" DECIMAL(5,2) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exercises_pkey" PRIMARY KEY ("exercise_id")
);

-- CreateTable
CREATE TABLE "gym" (
    "gym_id" SERIAL NOT NULL,
    "gym_name" VARCHAR(100) NOT NULL,
    "location" VARCHAR(255) NOT NULL,
    "contact_number" VARCHAR(20) NOT NULL,
    "admin_id" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gym_pkey" PRIMARY KEY ("gym_id")
);

-- CreateTable
CREATE TABLE "meals" (
    "meal_id" SERIAL NOT NULL,
    "diet_plan_id" INTEGER,
    "meal_name" VARCHAR(100) NOT NULL,
    "meal_time" "meal_time" NOT NULL,
    "calories" DECIMAL(5,2) NOT NULL,
    "description" TEXT,
    "macronutrients" VARCHAR(100),
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "meals_pkey" PRIMARY KEY ("meal_id")
);

-- CreateTable
CREATE TABLE "memberships" (
    "membership_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "plan_type" "plan_type" NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "status" "membership_status" NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "memberships_pkey" PRIMARY KEY ("membership_id")
);

-- CreateTable
CREATE TABLE "payments" (
    "payment_id" SERIAL NOT NULL,
    "membership_id" INTEGER,
    "user_id" INTEGER,
    "price" DECIMAL(10,2) NOT NULL,
    "payment_method" "payment_method" NOT NULL,
    "khalti_payload" VARCHAR(100) NOT NULL,
    "payment_date" DATE NOT NULL,
    "payment_status" "payment_status" NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("payment_id")
);

-- CreateTable
CREATE TABLE "users" (
    "user_id" SERIAL NOT NULL,
    "user_name" VARCHAR(100) NOT NULL,
    "full_name" VARCHAR(100) NOT NULL,
    "address" VARCHAR(255),
    "age" INTEGER,
    "height" DECIMAL NOT NULL,
    "current_weight" DECIMAL NOT NULL,
    "gender" "gender" NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "phone_number" VARCHAR(20) NOT NULL,
    "role" "role" NOT NULL,
    "fitness_level" "fitness_level" NOT NULL,
    "goal_type" "goal_type" NOT NULL,
    "card_number" VARCHAR(50),
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "workoutexercises" (
    "workout_exercise_id" SERIAL NOT NULL,
    "workout_id" INTEGER,
    "exercise_id" INTEGER,
    "sets" INTEGER NOT NULL,
    "reps" INTEGER NOT NULL,
    "duration" DECIMAL(5,2) NOT NULL,

    CONSTRAINT "workoutexercises_pkey" PRIMARY KEY ("workout_exercise_id")
);

-- CreateTable
CREATE TABLE "workouts" (
    "workout_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "workout_name" VARCHAR(100) NOT NULL,
    "description" TEXT NOT NULL,
    "target_muscle_group" VARCHAR(50) NOT NULL,
    "difficulty" "difficulty_level" NOT NULL,
    "trainer_id" INTEGER,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workouts_pkey" PRIMARY KEY ("workout_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "customworkouts_custom_workout_name_key" ON "customworkouts"("custom_workout_name");

-- CreateIndex
CREATE UNIQUE INDEX "exercises_exercise_name_key" ON "exercises"("exercise_name");

-- CreateIndex
CREATE UNIQUE INDEX "gym_gym_name_key" ON "gym"("gym_name");

-- CreateIndex
CREATE UNIQUE INDEX "gym_contact_number_key" ON "gym"("contact_number");

-- CreateIndex
CREATE UNIQUE INDEX "meals_meal_name_key" ON "meals"("meal_name");

-- CreateIndex
CREATE UNIQUE INDEX "payments_khalti_payload_key" ON "payments"("khalti_payload");

-- CreateIndex
CREATE UNIQUE INDEX "users_user_name_key" ON "users"("user_name");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_number_key" ON "users"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "workouts_workout_name_key" ON "workouts"("workout_name");

-- AddForeignKey
ALTER TABLE "attendance" ADD CONSTRAINT "attendance_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "chatconversations" ADD CONSTRAINT "chatconversations_trainer_id_fkey" FOREIGN KEY ("trainer_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "chatconversations" ADD CONSTRAINT "chatconversations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "chatmessages" ADD CONSTRAINT "chatmessages_chat_id_fkey" FOREIGN KEY ("chat_id") REFERENCES "chatconversations"("chat_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "customworkoutexercises" ADD CONSTRAINT "customworkoutexercises_custom_workout_id_fkey" FOREIGN KEY ("custom_workout_id") REFERENCES "customworkouts"("custom_workout_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "customworkoutexercises" ADD CONSTRAINT "customworkoutexercises_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("exercise_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "customworkouts" ADD CONSTRAINT "customworkouts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "dietlogs" ADD CONSTRAINT "dietlogs_diet_plan_id_fkey" FOREIGN KEY ("diet_plan_id") REFERENCES "dietplans"("diet_plan_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "dietlogs" ADD CONSTRAINT "dietlogs_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "meals"("meal_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "dietlogs" ADD CONSTRAINT "dietlogs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "dietplans" ADD CONSTRAINT "dietplans_trainer_id_fkey" FOREIGN KEY ("trainer_id") REFERENCES "users"("user_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "dietplans" ADD CONSTRAINT "dietplans_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "gym" ADD CONSTRAINT "gym_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "users"("user_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "meals" ADD CONSTRAINT "meals_diet_plan_id_fkey" FOREIGN KEY ("diet_plan_id") REFERENCES "dietplans"("diet_plan_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_membership_id_fkey" FOREIGN KEY ("membership_id") REFERENCES "memberships"("membership_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "workoutexercises" ADD CONSTRAINT "workoutexercises_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("exercise_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "workoutexercises" ADD CONSTRAINT "workoutexercises_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "workouts"("workout_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "workouts" ADD CONSTRAINT "workouts_trainer_id_fkey" FOREIGN KEY ("trainer_id") REFERENCES "users"("user_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "workouts" ADD CONSTRAINT "workouts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;
