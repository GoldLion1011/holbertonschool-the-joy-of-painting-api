-- Set up the database and tables for the JOP project
CREATE DATABASE IF NOT EXISTS JOP;

USE JOP;

-- Create the "Episodes" table
CREATE TABLE Episodes (
  episode_id VARCHAR(6), -- season and episode number
  episode_title VARCHAR(255),
  air_date DATE,
);

-- Create the "Subjects" table
CREATE TABLE Subjects (
  subject_id INT PRIMARY KEY AUTO_INCREMENT,
  subject_name VARCHAR(255),
);

-- Create the "ColorPalettes" table
CREATE TABLE ColorPalettes (
  color_id INT PRIMARY KEY AUTO_INCREMENT, -- needs to be joined hex_value
  color_name VARCHAR(255),
  hex_value VARCHAR(7),

-- Create the "EpisodeSubjects" junction table (Many-to-Many relationship)
CREATE TABLE EpisodeSubjects (
  episode_id INT,
  subject_id INT,
  PRIMARY KEY (episode_id, subject_id),
  FOREIGN KEY (episode_id) REFERENCES Episodes(episode_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id) ON DELETE CASCADE
);

-- Create the "EpisodeColors" junction table (Many-to-Many relationship)
CREATE TABLE EpisodeColors (
  episode_id INT,
  color_id INT,
  PRIMARY KEY (episode_id, color_id),
  FOREIGN KEY (episode_id) REFERENCES Episodes(episode_id) ON DELETE CASCADE,
  FOREIGN KEY (color_id) REFERENCES ColorPalettes(color_id) ON DELETE CASCADE
);
