/*
  Warnings:

  - You are about to drop the column `exercise` on the `personal_bests` table. All the data in the column will be lost.
  - Added the required column `supported_exercise_id` to the `personal_bests` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "personal_bests" DROP COLUMN "exercise",
ADD COLUMN     "supported_exercise_id" INTEGER NOT NULL;

-- DropEnum
DROP TYPE "supported_exercises";

-- CreateTable
CREATE TABLE "supported_exercises" (
    "supported_exercise_id" SERIAL NOT NULL,
    "exercise_name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "supported_exercises_pkey" PRIMARY KEY ("supported_exercise_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "supported_exercises_exercise_name_key" ON "supported_exercises"("exercise_name");

-- AddForeignKey
ALTER TABLE "personal_bests" ADD CONSTRAINT "personal_bests_supported_exercise_id_fkey" FOREIGN KEY ("supported_exercise_id") REFERENCES "supported_exercises"("supported_exercise_id") ON DELETE CASCADE ON UPDATE CASCADE;
