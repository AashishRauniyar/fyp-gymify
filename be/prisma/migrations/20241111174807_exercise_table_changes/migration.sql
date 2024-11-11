/*
  Warnings:

  - Added the required column `description` to the `exercises` table without a default value. This is not possible if the table is not empty.
  - Added the required column `target_muscle_group` to the `exercises` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "exercises" ADD COLUMN     "description" TEXT NOT NULL,
ADD COLUMN     "image_url" VARCHAR(255),
ADD COLUMN     "target_muscle_group" TEXT NOT NULL,
ADD COLUMN     "video_url" VARCHAR(255);
