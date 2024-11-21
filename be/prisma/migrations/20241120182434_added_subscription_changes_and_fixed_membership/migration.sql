-- CreateTable
CREATE TABLE "subscription_changes" (
    "change_id" SERIAL NOT NULL,
    "membership_id" INTEGER NOT NULL,
    "previous_plan" INTEGER NOT NULL,
    "new_plan" INTEGER NOT NULL,
    "change_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "action" TEXT NOT NULL,

    CONSTRAINT "subscription_changes_pkey" PRIMARY KEY ("change_id")
);

-- AddForeignKey
ALTER TABLE "subscription_changes" ADD CONSTRAINT "subscription_changes_membership_id_fkey" FOREIGN KEY ("membership_id") REFERENCES "memberships"("membership_id") ON DELETE CASCADE ON UPDATE CASCADE;
