-- AlterTable
ALTER TABLE "users" ADD COLUMN     "otp" VARCHAR(6),
ADD COLUMN     "otp_expiry" TIMESTAMP(3);
