/*
  Warnings:

  - Added the required column `itemId` to the `Contract` table without a default value. This is not possible if the table is not empty.
  - Added the required column `contractId` to the `ItemLend` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Contract" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "itemId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "receiverId" TEXT NOT NULL,
    "itemReturned" BOOLEAN NOT NULL DEFAULT false,
    "dateLimit" DATETIME NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Contract_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "ItemLend" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Contract" ("createdAt", "dateLimit", "id", "itemReturned", "providerId", "receiverId", "updatedAt") SELECT "createdAt", "dateLimit", "id", "itemReturned", "providerId", "receiverId", "updatedAt" FROM "Contract";
DROP TABLE "Contract";
ALTER TABLE "new_Contract" RENAME TO "Contract";
CREATE UNIQUE INDEX "Contract_itemId_key" ON "Contract"("itemId");
CREATE TABLE "new_ItemLend" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "contractId" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_ItemLend" ("createdAt", "description", "id", "name") SELECT "createdAt", "description", "id", "name" FROM "ItemLend";
DROP TABLE "ItemLend";
ALTER TABLE "new_ItemLend" RENAME TO "ItemLend";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
