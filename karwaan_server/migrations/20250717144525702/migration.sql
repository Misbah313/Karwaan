BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "comment" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "checklist_item" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "check_list" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "card_label" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "attachment" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "card" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "listboard" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "attachment" (
    "id" bigserial PRIMARY KEY,
    "card" bigint NOT NULL,
    "uploadedBy" bigint NOT NULL,
    "fileName" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "board_list" (
    "id" bigserial PRIMARY KEY,
    "board" bigint NOT NULL,
    "title" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "createdBy" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text,
    "createdBy" bigint NOT NULL,
    "list" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "position" bigint,
    "isCompleted" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "card_label" (
    "id" bigserial PRIMARY KEY,
    "card" bigint NOT NULL,
    "label" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "check_list" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "card" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "createdBy" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "checklist_item" (
    "id" bigserial PRIMARY KEY,
    "checklist" bigint NOT NULL,
    "content" text NOT NULL,
    "isDone" boolean NOT NULL,
    "createdBy" bigint NOT NULL
);

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
-- ACTION DROP TABLE
--
DROP TABLE "lable" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "lable" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "color" text NOT NULL,
    "board" bigint NOT NULL,
    "createdBy" bigint NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "user" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "password" text NOT NULL,
    "profileImage" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "token" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "attachment"
    ADD CONSTRAINT "attachment_fk_0"
    FOREIGN KEY("card")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "attachment"
    ADD CONSTRAINT "attachment_fk_1"
    FOREIGN KEY("uploadedBy")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "board_list"
    ADD CONSTRAINT "board_list_fk_0"
    FOREIGN KEY("board")
    REFERENCES "board"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "board_list"
    ADD CONSTRAINT "board_list_fk_1"
    FOREIGN KEY("createdBy")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "card"
    ADD CONSTRAINT "card_fk_0"
    FOREIGN KEY("createdBy")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "card"
    ADD CONSTRAINT "card_fk_1"
    FOREIGN KEY("list")
    REFERENCES "board_list"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "card_label"
    ADD CONSTRAINT "card_label_fk_0"
    FOREIGN KEY("card")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "card_label"
    ADD CONSTRAINT "card_label_fk_1"
    FOREIGN KEY("label")
    REFERENCES "lable"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "check_list"
    ADD CONSTRAINT "check_list_fk_0"
    FOREIGN KEY("card")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "check_list"
    ADD CONSTRAINT "check_list_fk_1"
    FOREIGN KEY("createdBy")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "checklist_item"
    ADD CONSTRAINT "checklist_item_fk_0"
    FOREIGN KEY("checklist")
    REFERENCES "check_list"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "checklist_item"
    ADD CONSTRAINT "checklist_item_fk_1"
    FOREIGN KEY("createdBy")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_0"
    FOREIGN KEY("card")
    REFERENCES "card"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_1"
    FOREIGN KEY("author")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_token"
    ADD CONSTRAINT "user_token_fk_0"
    FOREIGN KEY("userId")
    REFERENCES "user"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR karwaan
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('karwaan', '20250717144525702', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250717144525702', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
