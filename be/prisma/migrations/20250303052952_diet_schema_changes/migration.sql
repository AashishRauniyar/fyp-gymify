/*
  Warnings:

  - You are about to drop the column `image` on the `meals` table. All the data in the column will be lost.
  - The `macronutrients` column on the `meals` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the `dietlogs` table. If the table is not empty, all the data it contains will be lost.
  - Made the column `user_id` on table `dietplans` required. This step will fail if there are existing NULL values in that column.
  - Made the column `created_at` on table `dietplans` required. This step will fail if there are existing NULL values in that column.
  - Made the column `updated_at` on table `dietplans` required. This step will fail if there are existing NULL values in that column.
  - Made the column `diet_plan_id` on table `meals` required. This step will fail if there are existing NULL values in that column.
  - Made the column `created_at` on table `meals` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "dietlogs" DROP CONSTRAINT "dietlogs_diet_plan_id_fkey";

-- DropForeignKey
ALTER TABLE "dietlogs" DROP CONSTRAINT "dietlogs_meal_id_fkey";

-- DropForeignKey
ALTER TABLE "dietlogs" DROP CONSTRAINT "dietlogs_user_id_fkey";

-- DropForeignKey
ALTER TABLE "dietplans" DROP CONSTRAINT "dietplans_user_id_fkey";

-- DropForeignKey
ALTER TABLE "meals" DROP CONSTRAINT "meals_diet_plan_id_fkey";

-- DropIndex
DROP INDEX "meals_meal_name_key";

-- AlterTable
ALTER TABLE "dietplans" ALTER COLUMN "user_id" SET NOT NULL,
ALTER COLUMN "created_at" SET NOT NULL,
ALTER COLUMN "updated_at" SET NOT NULL,
ALTER COLUMN "updated_at" DROP DEFAULT,
ALTER COLUMN "updated_at" SET DATA TYPE TIMESTAMP(3);

-- AlterTable
ALTER TABLE "meals" DROP COLUMN "image",
ALTER COLUMN "diet_plan_id" SET NOT NULL,
DROP COLUMN "macronutrients",
ADD COLUMN     "macronutrients" JSONB,
ALTER COLUMN "created_at" SET NOT NULL;

-- DropTable
DROP TABLE "dietlogs";

-- CreateTable
CREATE TABLE "meallogs" (
    "meal_log_id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "meal_id" INTEGER NOT NULL,
    "quantity" DECIMAL(5,2) NOT NULL,
    "log_time" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "meallogs_pkey" PRIMARY KEY ("meal_log_id")
);

-- AddForeignKey
ALTER TABLE "dietplans" ADD CONSTRAINT "dietplans_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meals" ADD CONSTRAINT "meals_diet_plan_id_fkey" FOREIGN KEY ("diet_plan_id") REFERENCES "dietplans"("diet_plan_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meallogs" ADD CONSTRAINT "meallogs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "meallogs" ADD CONSTRAINT "meallogs_meal_id_fkey" FOREIGN KEY ("meal_id") REFERENCES "meals"("meal_id") ON DELETE CASCADE ON UPDATE CASCADE;
