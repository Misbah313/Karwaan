BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "boardmemberdetails" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "userName" text NOT NULL,
    "email" text,
    "role" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "user" DROP COLUMN "profileImage";
--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspacememberdetails" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "userName" text NOT NULL,
    "email" text,
    "avatarUrl" text,
    "role" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "boardmemberdetails"
    ADD CONSTRAINT "boardmemberdetails_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "workspacememberdetails"
    ADD CONSTRAINT "workspacememberdetails_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20250722204942644', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250722204942644', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
