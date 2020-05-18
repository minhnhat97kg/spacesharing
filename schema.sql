BEGIN;
--
-- Create model Permission
--
CREATE TABLE "auth_permission" ("id" serial NOT NULL PRIMARY KEY, "name" varchar(50) NOT NULL, "content_type_id" integer NOT NULL, "codename" varchar(100) NOT NULL);
--
-- Create model Group
--
CREATE TABLE "auth_group" ("id" serial NOT NULL PRIMARY KEY, "name" varchar(80) NOT NULL UNIQUE);
CREATE TABLE "auth_group_permissions" ("id" serial NOT NULL PRIMARY KEY, "group_id" integer NOT NULL, "permission_id" integer NOT NULL);
--
-- Create model User
--
CREATE TABLE "auth_user" ("id" serial NOT NULL PRIMARY KEY, "password" varchar(128) NOT NULL, "last_login" timestamp with time zone NOT NULL, "is_superuser" boolean NOT NULL, "username" varchar(30) NOT NULL UNIQUE, "first_name" varchar(30) NOT NULL, "last_name" varchar(30) NOT NULL, "email" varchar(75) NOT NULL, "is_staff" boolean NOT NULL, "is_active" boolean NOT NULL, "date_joined" timestamp with time zone NOT NULL);
CREATE TABLE "auth_user_groups" ("id" serial NOT NULL PRIMARY KEY, "user_id" integer NOT NULL, "group_id" integer NOT NULL);
CREATE TABLE "auth_user_user_permissions" ("id" serial NOT NULL PRIMARY KEY, "user_id" integer NOT NULL, "permission_id" integer NOT NULL);
ALTER TABLE "auth_permission" ADD CONSTRAINT "auth_permission_content_type_id_codename_01ab375a_uniq" UNIQUE ("content_type_id", "codename");
ALTER TABLE "auth_permission" ADD CONSTRAINT "auth_permission_content_type_id_2f476e4b_fk_django_co" FOREIGN KEY ("content_type_id") REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");
CREATE INDEX "auth_group_name_a6ea08ec_like" ON "auth_group" ("name" varchar_pattern_ops);
ALTER TABLE "auth_group_permissions" ADD CONSTRAINT "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" UNIQUE ("group_id", "permission_id");
ALTER TABLE "auth_group_permissions" ADD CONSTRAINT "auth_group_permissions_group_id_b120cbf9_fk_auth_group_id" FOREIGN KEY ("group_id") REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "auth_group_permissions" ADD CONSTRAINT "auth_group_permissio_permission_id_84c5c92e_fk_auth_perm" FOREIGN KEY ("permission_id") REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" ("group_id");
CREATE INDEX "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" ("permission_id");
CREATE INDEX "auth_user_username_6821ab7c_like" ON "auth_user" ("username" varchar_pattern_ops);
ALTER TABLE "auth_user_groups" ADD CONSTRAINT "auth_user_groups_user_id_group_id_94350c0c_uniq" UNIQUE ("user_id", "group_id");
ALTER TABLE "auth_user_groups" ADD CONSTRAINT "auth_user_groups_user_id_6a12ed8b_fk_auth_user_id" FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "auth_user_groups" ADD CONSTRAINT "auth_user_groups_group_id_97559544_fk_auth_group_id" FOREIGN KEY ("group_id") REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" ("user_id");
CREATE INDEX "auth_user_groups_group_id_97559544" ON "auth_user_groups" ("group_id");
ALTER TABLE "auth_user_user_permissions" ADD CONSTRAINT "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" UNIQUE ("user_id", "permission_id");
ALTER TABLE "auth_user_user_permissions" ADD CONSTRAINT "auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id" FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "auth_user_user_permissions" ADD CONSTRAINT "auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm" FOREIGN KEY ("permission_id") REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" ("user_id");
CREATE INDEX "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" ("permission_id");
COMMIT;
BEGIN;
--
-- Create model Group
--
CREATE TABLE "events_group" ("id" serial NOT NULL PRIMARY KEY, "name" varchar(100) NOT NULL, "description" text NOT NULL, "admin_user_id" integer NULL);
--
-- Create model UserGroup
--
CREATE TABLE "events_usergroup" ("id" serial NOT NULL PRIMARY KEY, "date" date NOT NULL, "group_id" integer NOT NULL, "user_id" integer NOT NULL);
--
-- Create model File
--
CREATE TABLE "events_file" ("id" serial NOT NULL PRIMARY KEY, "file" varchar(100) NOT NULL, "time" timestamp with time zone NOT NULL, "group_id" integer NOT NULL, "uploader_id" integer NOT NULL);
--
-- Create model Event
--
CREATE TABLE "events_event" ("id" serial NOT NULL PRIMARY KEY, "title" varchar(100) NOT NULL, "description" text NOT NULL, "start_time" timestamp with time zone NOT NULL, "end_time" timestamp with time zone NOT NULL, "group_id" integer NOT NULL, "usergroup_id" integer NOT NULL);
ALTER TABLE "events_group" ADD CONSTRAINT "events_group_admin_user_id_88e0c1a0_fk_auth_user_id" FOREIGN KEY ("admin_user_id") REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "events_group_admin_user_id_88e0c1a0" ON "events_group" ("admin_user_id");
ALTER TABLE "events_usergroup" ADD CONSTRAINT "events_usergroup_user_id_group_id_e4ebb481_uniq" UNIQUE ("user_id", "group_id");
ALTER TABLE "events_usergroup" ADD CONSTRAINT "events_usergroup_group_id_d05a5278_fk_events_group_id" FOREIGN KEY ("group_id") REFERENCES "events_group" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "events_usergroup" ADD CONSTRAINT "events_usergroup_user_id_eedb4417_fk_auth_user_id" FOREIGN KEY ("user_id") REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "events_usergroup_group_id_d05a5278" ON "events_usergroup" ("group_id");
CREATE INDEX "events_usergroup_user_id_eedb4417" ON "events_usergroup" ("user_id");
ALTER TABLE "events_file" ADD CONSTRAINT "events_file_group_id_331257e8_fk_events_group_id" FOREIGN KEY ("group_id") REFERENCES "events_group" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "events_file" ADD CONSTRAINT "events_file_uploader_id_8657a718_fk_events_usergroup_id" FOREIGN KEY ("uploader_id") REFERENCES "events_usergroup" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "events_file_group_id_331257e8" ON "events_file" ("group_id");
CREATE INDEX "events_file_uploader_id_8657a718" ON "events_file" ("uploader_id");
ALTER TABLE "events_event" ADD CONSTRAINT "events_event_group_id_762bc284_fk_events_group_id" FOREIGN KEY ("group_id") REFERENCES "events_group" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "events_event" ADD CONSTRAINT "events_event_usergroup_id_37da2d13_fk_events_usergroup_id" FOREIGN KEY ("usergroup_id") REFERENCES "events_usergroup" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "events_event_group_id_762bc284" ON "events_event" ("group_id");
CREATE INDEX "events_event_usergroup_id_37da2d13" ON "events_event" ("usergroup_id");
COMMIT;
