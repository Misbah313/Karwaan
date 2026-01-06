BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "over_all_analytics" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "totalBoard" bigint NOT NULL,
    "totalCard" bigint NOT NULL,
    "completedCards" bigint NOT NULL,
    "completionPercentage" double precision NOT NULL,
    "cardsPerWorkspace" json,
    "cardsPerStatus" json,
    "lastUpdate" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "over_all_analytics"
    ADD CONSTRAINT "over_all_analytics_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20251019221736308', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251019221736308', "timestamp" = now();

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
