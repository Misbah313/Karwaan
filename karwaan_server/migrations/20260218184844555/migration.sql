BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "board_analytics" ADD COLUMN "boardName" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "boardmemberdetails" ADD COLUMN "avatarUrl" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "pinned_boards" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "boardId" bigint NOT NULL,
    "pinnedAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20260218184844555', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260218184844555', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
