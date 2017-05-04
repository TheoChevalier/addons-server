/* Follow-on from migration 938 -
Drop the (now obsolete) bio and old translations. */

SET @CONSTRAINT_NAME := (SELECT CONSTRAINT_NAME FROM information_schema.key_column_usage WHERE TABLE_SCHEMA="olympia" AND TABLE_NAME="users" and COLUMN_NAME="bio" AND REFERENCED_TABLE_NAME = "translations");

SET @QUERY = CONCAT('ALTER TABLE users DROP FOREIGN KEY ', @constraint_name, ';');
PREPARE stmt FROM @QUERY;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

/* Clear out the translations. */
DELETE FROM `translations` WHERE `id` in (SELECT `bio` FROM `users`);

/* Drop the old columns. */
ALTER TABLE `users`
    DROP COLUMN `bio`,
    DROP COLUMN lang,
    DROP COLUMN region;