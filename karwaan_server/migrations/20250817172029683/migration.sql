BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "lable" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lable" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "color" text NOT NULL,
    "board" bigint NOT NULL,
    "createdBy" bigint NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "lable"
    ADD CONSTRAINT "lable_fk_0"
    FOREIGN KEY("board")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "lable"
    ADD CONSTRAINT "lable_fk_1"
    FOREIGN KEY("createdBy")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20250817172029683', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250817172029683', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
