/*
  Warnings:

  - Added the required column `description` to the `membership_plan` table without a default value. This is not possible if the table is not empty.
  - Added the required column `duration` to the `membership_plan` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "membership_plan" ADD COLUMN     "description" VARCHAR(255) NOT NULL,
ADD COLUMN     "duration" INTEGER NOT NULL;
