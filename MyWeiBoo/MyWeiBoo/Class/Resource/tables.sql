--新浪微博--
CREATE TABLE IF NOT EXISTS"T_status" (
"statusId" INTEGER NOT NULL,
"status" TEXT,
"userId" INTEGER,
"createTime" TEXT DEFAULT (datetime('now','localtime')),
PRIMARY KEY("statusId")
);