-- AlterEnum
ALTER TYPE "membership_status" ADD VALUE 'Pending';

-- AlterTable
ALTER TABLE "memberships" ALTER COLUMN "start_date" DROP NOT NULL,
ALTER COLUMN "end_date" DROP NOT NULL;
