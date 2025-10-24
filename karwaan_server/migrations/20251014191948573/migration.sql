BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_recent_boards" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "boardId" bigint NOT NULL,
    "lastAccess" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_recent_boards"
    ADD CONSTRAINT "user_recent_boards_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "user_recent_boards"
    ADD CONSTRAINT "user_recent_boards_fk_1"
    FOREIGN KEY("boardId")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20251014191948573', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251014191948573', "timestamp" = now();

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
