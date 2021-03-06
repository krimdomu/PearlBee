GRANT ALL PRIVILEGES ON PearlBee.* TO 'username'@'localhost' IDENTIFIED BY 'password';

DROP DATABASE IF EXISTS PearlBee;
CREATE DATABASE IF NOT EXISTS PearlBee;

USE PearlBee;

CREATE TABLE IF NOT EXISTS user (
	id 				INT NOT NULL AUTO_INCREMENT,
	first_name 		VARCHAR(255) UNICODE NOT NULL,
	last_name 		VARCHAR(255) UNICODE NOT NULL,
	username		VARCHAR(200) NOT NULL,
	password		VARCHAR(100) NOT NULL,
	register_date 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	email			VARCHAR(255) NOT NULL,
	company 		VARCHAR(255),
	telephone 		VARCHAR(12),
	role 			ENUM('author', 'admin') NOT NULL DEFAULT 'author',
	activation_key  VARCHAR(100),
	status 			ENUM('deactivated', 'activated', 'suspended') NOT NULL DEFAULT 'deactivated',
	salt			CHAR(24) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY (username),
	UNIQUE KEY (email)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'User table.';


CREATE TABLE IF NOT EXISTS category (
	id  	INT NOT NULL AUTO_INCREMENT,
	name 	VARCHAR(100) UNICODE NOT NULL,
	slug 	VARCHAR(100) UNICODE NOT NULL,
	user_id INT NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY (name),
	FOREIGN KEY (user_id) REFERENCES user(id)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'Category table.';


CREATE TABLE IF NOT EXISTS post (
	id  			INT NOT NULL AUTO_INCREMENT,
	title 			VARCHAR(255) UNICODE NOT NULL,
	slug 			VARCHAR(255) UNICODE NOT NULL,
	description 	VARCHAR(255) UNICODE,
	cover 			VARCHAR(300) NOT NULL,
	content 		TEXT UNICODE NOT NULL,
	created_date 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status 			ENUM('published', 'trash', 'draft') DEFAULT 'draft',
	user_id 		INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (user_id) REFERENCES user(id)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'Post table.';


CREATE TABLE IF NOT EXISTS post_category (
	category_id INT NOT NULL,
	post_id 	INT NOT NULL,
	PRIMARY KEY (category_id, post_id),
	FOREIGN KEY (category_id) REFERENCES category(id),
	FOREIGN KEY (post_id) REFERENCES post(id)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'Post category table.';


CREATE TABLE IF NOT EXISTS tag (
	id  	INT NOT NULL AUTO_INCREMENT,
	name 	VARCHAR(100) UNICODE,
	slug 	varchar(100) UNICODE,
	PRIMARY KEY (id)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'Tag table.';


CREATE TABLE IF NOT EXISTS post_tag (
	tag_id  	INT NOT NULL,
	post_id 	INT NOT NULL,
	PRIMARY KEY (tag_id, post_id),
	FOREIGN KEY (tag_id) REFERENCES tag(id),
	FOREIGN KEY (post_id) REFERENCES post(id)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'Post tag table.';


CREATE TABLE IF NOT EXISTS comment (
	id  			INT NOT NULL AUTO_INCREMENT,
	content 		TEXT UNICODE,
	fullname 		VARCHAR(100) UNICODE,
	email 			VARCHAR(200),
	website 		VARCHAR(255),
	avatar 			VARCHAR(255),
	comment_date 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	status 			ENUM('approved', 'spam', 'pending', 'trash') DEFAULT 'pending',
	post_id 		INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (post_id) REFERENCES post(id)
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'Comment table.';


CREATE TABLE IF NOT EXISTS settings (
	timezone 		VARCHAR(255) NOT NULL,
	social_media 	BOOLEAN NOT NULL DEFAULT '1',
	blog_path		VARCHAR(255) NOT NULL DEFAULT '/',
	theme_folder 	VARCHAR(255) NOT NULL,
	blog_name 		VARCHAR(255) NOT NULL
)   ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci COMMENT 'Settings table.';

-- default admin login user : admin
-- default admin login pass : password

INSERT INTO user (first_name, last_name, username, password, email, status, role, salt) 
	VALUES ("Default", "Admin", "admin", "ddd8f33fbc8fd3ff70ea1d3768e7c5c151292d3a8c0972", 
			"you@domain.com", "activated", "admin", "IQbmVFR+SEgTju9y+UzhwA==");
	
INSERT INTO category (name, slug, user_id) values ("Uncategorized", "uncategorized", 1);

INSERT INTO settings ( timezone, social_media, theme_folder, blog_path, blog_name ) values ( 'Europe/Bucharest', 1, '/', 'Olson', 'PearlBee');
