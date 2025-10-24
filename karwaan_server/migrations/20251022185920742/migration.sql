BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "workspace" ADD COLUMN "backgroundColor" text;
ALTER TABLE "workspace" ADD COLUMN "isPrivate" boolean;

--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20251022185920742', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251022185920742', "timestamp" = now();

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
