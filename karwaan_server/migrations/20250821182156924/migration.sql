BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "comment" DROP CONSTRAINT "comment_fk_1";
ALTER TABLE "comment" DROP COLUMN "author";
ALTER TABLE "comment" ADD COLUMN "author" text;

--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20250821182156924', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250821182156924', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
