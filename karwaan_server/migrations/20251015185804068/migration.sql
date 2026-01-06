BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "board_analytics" (
    "id" bigserial PRIMARY KEY,
    "boardId" bigint NOT NULL,
    "totalCards" bigint NOT NULL,
    "completedCards" bigint NOT NULL,
    "completionPercentage" double precision NOT NULL,
    "cardPerList" json,
    "lastUpdate" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "board_analytics"
    ADD CONSTRAINT "board_analytics_fk_0"
    FOREIGN KEY("boardId")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20251015185804068', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251015185804068', "timestamp" = now();

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
