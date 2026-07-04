BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "board_card" ADD COLUMN "assignedUsers" json;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "board_card_assignment" (
    "id" bigserial PRIMARY KEY,
    "card" bigint NOT NULL,
    "user" bigint NOT NULL,
    "assignedBy" bigint NOT NULL,
    "assignedAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "board_card_assignment"
    ADD CONSTRAINT "board_card_assignment_fk_0"
    FOREIGN KEY("card")
    REFERENCES "board_card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "board_card_assignment"
    ADD CONSTRAINT "board_card_assignment_fk_1"
    FOREIGN KEY("user")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "board_card_assignment"
    ADD CONSTRAINT "board_card_assignment_fk_2"
    FOREIGN KEY("assignedBy")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20260322151148515', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260322151148515', "timestamp" = now();

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
