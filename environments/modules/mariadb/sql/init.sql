CREATE TABLE uuevents (
  identifier varchar(255) PRIMARY KEY NOT NULL,
  issuedTime timestamp,
  producer varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  producerReferenceId varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  event_type varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
);

CREATE TABLE CAMEL_MESSAGEPROCESSED (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  processorName VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  messageId VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  createdAt TIMESTAMP,
  UNIQUE KEY `ix_key` (`processorName`, `messageId`)
);

CREATE TABLE MEMBERSHIPEVENTS (
  id         BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date       TIMESTAMP,
  pnr        VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  mtype      VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  courseCode VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  reportCode VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  semester   VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  origin     VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  origin2    VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
);

CREATE TABLE MEMBERSHIPS (
  id         BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  pnr        VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  courseCode VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  reportCode VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  semester   VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  origin     VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  origin2    VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
);
