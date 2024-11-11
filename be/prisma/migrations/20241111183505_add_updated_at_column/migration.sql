/*
  Warnings:

  - Added the required column `updated_at` to the `exercises` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "exercises" 
ADD COLUMN "updated_at" TIMESTAMP DEFAULT now();