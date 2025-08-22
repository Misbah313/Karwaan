BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "comment" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment" (
    "id" bigserial PRIMARY KEY,
    "card" bigint NOT NULL,
    "author" bigint NOT NULL,
    "content" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_0"
    FOREIGN KEY("card")
    REFERENCES "board_card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_1"
    FOREIGN KEY("author")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20250822103848895', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250822103848895', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
