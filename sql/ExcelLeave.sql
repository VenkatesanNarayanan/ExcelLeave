DROP TABLE IF EXISTS "OfficialHolidays";
 
CREATE TABLE "OfficialHolidays" (
	"HolidayDate" date  NOT NULL,
	"HolidayOccasion" varchar(150)  NOT NULL,
	"CreatedBy" varchar(20)  NOT NULL,
	"CreatedOn" date  NOT NULL,
	"UpdatedBy" varchar(20) NULL,
	"UpdatedOn" date  NULL
);

DROP TABLE IF EXISTS "Role" CASCADE;

CREATE TABLE "Role" (
	"RoleId" SERIAL PRIMARY KEY,
	"RoleName" varchar(20)  NOT NULL,
	"CreatedBy" varchar(20)  NOT NULL,
	"CreatedOn" date  NOT NULL,
	"UpdatedBy" varchar(20) NULL,
	"UpdatedOn" date NULL
);


DROP type IF EXISTS "EmployeeStatus" CASCADE;
CREATE TYPE "EmployeeStatus" AS ENUM ('Active','Inactive','Disabled');

DROP TABLE IF EXISTS "Employee" CASCADE;

CREATE TABLE "Employee" (
	"EmployeeId" SERIAL PRIMARY KEY,
	"FirstName" varchar(30)  NOT NULL,
	"LastName" varchar(30)  NOT NULL,
	"DateOfJoining" date  NOT NULL,
	"Email" varchar(100)  NOT NULL,
	"Password" varchar(100)  NOT NULL,
	"RoleId" int references "Role"("RoleId"),
	"Token" varchar(100)  NULL,
	"Status" "EmployeeStatus" default 'Inactive',
	"CreatedBy" varchar(20)  NOT NULL,
	"CreatedOn" date  NOT NULL,
	"UpdatedBy" varchar(20)  NULL,
	"UpdatedOn" date  NULL
);

DROP TABLE IF EXISTS "EmployeeManager";

CREATE TABLE "EmployeeManager" (
	"EmployeeId" int  references "Employee"("EmployeeId"),
	"ManagerEmployeeId" int  references "Employee"("EmployeeId"),
	"CreatedBy" varchar(20)  NOT NULL,
	"CreatedOn" date  NOT NULL,
	"UpdatedBy" varchar(20) NULL,
	"UpdatedOn" date NULL
);

DROP TABLE IF EXISTS "EmployeeLeave";

CREATE TABLE "EmployeeLeave" (
	"EmployeeId" int  references "Employee"("EmployeeId"),
	"AvailablePersonalLeaves" int  NOT NULL,
	"CreatedBy" varchar(20)  NOT NULL,
	"CreatedOn" date  NOT NULL,
	"UpdatedBy" varchar(20) NULL,
	"UpdatedOn" date NULL
);

DROP TABLE IF EXISTS "LeaveRequestBatch" CASCADE;

CREATE TABLE "LeaveRequestBatch" (
	"BatchId" varchar(20)  PRIMARY KEY,
	"FromDate" date  NOT NULL,
	"ToDate" date  NOT NULL,
	"Message" varchar(100)  NOT NULL,
	"CreatedBy" varchar(20)  NOT NULL,
	"CreatedOn" date  NOT NULL,
	"UpdatedBy" varchar(20) NULL,
	"UpdatedOn" date NULL
);

DROP type IF EXISTS "LeaveStatus" CASCADE;

CREATE TYPE "LeaveStatus" AS ENUM ('Pending','Denied','Approved','Cancelled');

DROP TABLE IF EXISTS "LeaveRequest";

CREATE TABLE "LeaveRequest" (
	"LeaveId"  SERIAL PRIMARY KEY,
	"EmployeeId" int  references "Employee"("EmployeeId"),
	"BatchId" varchar(20)  references "LeaveRequestBatch"("BatchId"),
	"LeaveDate" date  NOT NULL,
	"LeaveStatus" "LeaveStatus" default 'Pending',
	"CreatedBy" varchar(20)  NOT NULL,
	"CreatedOn" date  NOT NULL,
	"UpdatedBy" varchar(20) NULL,
	"UpdatedOn" date NULL
);

DROP TABLE IF EXISTS "SystemConfig";

CREATE Table "SystemConfig" (
	"ConfigKey" varchar(50),
	"ConfigValue" varchar(10)
);

INSERT INTO "Role" ("RoleName", "CreatedBy", "CreatedOn") VALUES 
('Adminstrator', 'System', now()::date),
('Employee', 'System', now()::date),
('Manager', 'System', now()::date),
('Director', 'System', now()::date),
('TeamLead', 'System', now()::date)
; 

INSERT INTO "SystemConfig" ("ConfigKey", "ConfigValue") VALUES 
('LeaveRequestPrior', 1),
('LeaveCancelPrior', 1),
('TotalPersonalLeaves', 1)
; 
