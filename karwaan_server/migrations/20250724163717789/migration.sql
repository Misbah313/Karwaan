BEGIN;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20250724163717789', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250724163717789', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
