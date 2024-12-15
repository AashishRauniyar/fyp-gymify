/*
  Warnings:

  - You are about to drop the column `end_time` on the `workoutexerciseslogs` table. All the data in the column will be lost.
  - You are about to drop the column `start_time` on the `workoutexerciseslogs` table. All the data in the column will be lost.
  - You are about to drop the column `end_time` on the `workoutlogs` table. All the data in the column will be lost.
  - You are about to drop the column `start_time` on the `workoutlogs` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "workoutexerciseslogs" DROP COLUMN "end_time",
DROP COLUMN "start_time";

-- AlterTable
ALTER TABLE "workoutlogs" DROP COLUMN "end_time",
DROP COLUMN "start_time";
