/*
  Warnings:

  - You are about to drop the column `plan_type` on the `memberships` table. All the data in the column will be lost.
  - You are about to drop the column `khalti_payload` on the `payments` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[transaction_id]` on the table `payments` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `plan_id` to the `memberships` table without a default value. This is not possible if the table is not empty.
  - Added the required column `transaction_id` to the `payments` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "payments_khalti_payload_key";

-- AlterTable
ALTER TABLE "memberships" DROP COLUMN "plan_type",
ADD COLUMN     "plan_id" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "payments" DROP COLUMN "khalti_payload",
ADD COLUMN     "transaction_id" VARCHAR(100) NOT NULL;

-- CreateTable
CREATE TABLE "membership_plan" (
    "plan_id" SERIAL NOT NULL,
    "plan_type" "plan_type" NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "membership_plan_pkey" PRIMARY KEY ("plan_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payments_transaction_id_key" ON "payments"("transaction_id");

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "membership_plan"("plan_id") ON DELETE CASCADE ON UPDATE NO ACTION;
