-- CreateTable
CREATE TABLE "workoutexerciseslogs" (
    "log_id" SERIAL NOT NULL,
    "workout_log_id" INTEGER,
    "exercise_id" INTEGER,
    "start_time" TIME(6),
    "end_time" TIME(6),
    "exercise_duration" interval,
    "rest_duration" interval,
    "skipped" BOOLEAN DEFAULT false,

    CONSTRAINT "workoutexerciseslogs_pkey" PRIMARY KEY ("log_id")
);

-- CreateTable
CREATE TABLE "workoutlogs" (
    "log_id" SERIAL NOT NULL,
    "user_id" INTEGER,
    "workout_id" INTEGER,
    "workout_date" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "start_time" TIME(6),
    "end_time" TIME(6),
    "total_duration" interval,
    "calories_burned" DECIMAL(10,2),
    "performance_notes" TEXT,

    CONSTRAINT "workoutlogs_pkey" PRIMARY KEY ("log_id")
);

-- AddForeignKey
ALTER TABLE "workoutexerciseslogs" ADD CONSTRAINT "workoutexerciseslogs_exercise_id_fkey" FOREIGN KEY ("exercise_id") REFERENCES "exercises"("exercise_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "workoutexerciseslogs" ADD CONSTRAINT "workoutexerciseslogs_workout_log_id_fkey" FOREIGN KEY ("workout_log_id") REFERENCES "workoutlogs"("log_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "workoutlogs" ADD CONSTRAINT "workoutlogs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "workoutlogs" ADD CONSTRAINT "workoutlogs_workout_id_fkey" FOREIGN KEY ("workout_id") REFERENCES "workouts"("workout_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
