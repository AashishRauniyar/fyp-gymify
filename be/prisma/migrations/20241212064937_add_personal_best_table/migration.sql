-- CreateEnum
CREATE TYPE "supported_exercises" AS ENUM ('Squat', 'Bench Press', 'Deadlift');

-- CreateTable
CREATE TABLE "personal_bests" (
    "personal_best_id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "exercise" "supported_exercises" NOT NULL,
    "weight" DECIMAL(6,2) NOT NULL,
    "reps" INTEGER NOT NULL,
    "achieved_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "personal_bests_pkey" PRIMARY KEY ("personal_best_id")
);

-- AddForeignKey
ALTER TABLE "personal_bests" ADD CONSTRAINT "personal_bests_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
