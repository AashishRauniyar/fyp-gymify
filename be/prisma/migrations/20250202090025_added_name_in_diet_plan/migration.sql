/*
  Warnings:

  - A unique constraint covering the columns `[name]` on the table `dietplans` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `name` to the `dietplans` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "dietplans" ADD COLUMN     "name" VARCHAR(100) NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "dietplans_name_key" ON "dietplans"("name");
