-- AlterTable
ALTER TABLE "workouts" ADD COLUMN     "fitness_level" "fitness_level" NOT NULL DEFAULT 'Beginner',
ADD COLUMN     "goal_type" "goal_type" NOT NULL DEFAULT 'Weight Loss';
