-- Drop unsupported columns
ALTER TABLE "workoutexerciseslogs" DROP COLUMN IF EXISTS "exercise_duration";
ALTER TABLE "workoutexerciseslogs" DROP COLUMN IF EXISTS "rest_duration";

ALTER TABLE "workoutlogs" DROP COLUMN IF EXISTS "total_duration";

-- Add new columns with the correct type
ALTER TABLE "workoutexerciseslogs" 
ADD COLUMN "exercise_duration" DECIMAL(5,2),
ADD COLUMN "rest_duration" DECIMAL(5,2);

ALTER TABLE "workoutlogs" 
ADD COLUMN "total_duration" DECIMAL(5,2);
