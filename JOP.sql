-- Set up the database and tables for the JOP project
CREATE DATABASE IF NOT EXISTS JOP;

USE JOP;

-- Create the "Episodes" table
CREATE TABLE IF NOT EXISTS Episodes (
  episode_id VARCHAR(6), -- season and episode number
  episode_title VARCHAR(255),
  air_date DATE,
  subjects_list VARCHAR(255), -- Comma-separated list of subject names associated with the episode
);

-- Create the "Subjects" table
CREATE TABLE IF NOT EXISTS Subjects (
  subject_id INT PRIMARY KEY,
  subject_name VARCHAR(255),
);

-- Create the "ColorPalettes" table
CREATE TABLE IF NOT EXISTS ColorPalettes (
  color_id VARCHAR(7),
  color_name VARCHAR(255),
);

-- Create the "EpisodeSubjects" junction table (Many-to-Many relationship)
CREATE TABLE IF NOT EXISTS EpisodeSubjects (
  episode_id VARCHAR(6),
  subject_id INT,
  PRIMARY KEY (episode_id, subject_id),
  FOREIGN KEY (episode_id) REFERENCES Episodes(episode_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id) ON DELETE CASCADE
);

-- Create the "EpisodeColors" junction table (Many-to-Many relationship)
CREATE TABLE IF NOT EXISTS EpisodeColors (
  episode_id VARCHAR(6),
  color_id INT,
  PRIMARY KEY (episode_id, color_id),
  FOREIGN KEY (episode_id) REFERENCES Episodes(episode_id) ON DELETE CASCADE,
  FOREIGN KEY (color_id) REFERENCES ColorPalettes(color_id) ON DELETE CASCADE
);

LOAD DATA LOCAL INFILE 'The Joy Of Painting - Episode Dates.csv'
INTO TABLE Episodes
FIELDS TERMINATED BY ','
ENCLOSED BY '"';

LOAD DATA LOCAL INFILE 'The Joy Of Painting - Subject Matter.csv'
INTO TABLE Subjects
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'The Joy Of Painting - Colors Used.csv'
INTO TABLE ColorPalettes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


UPDATE Episodes
SET
    episode_title = SUBSTRING_INDEX(SUBSTRING_INDEX(csv_row, ',', 1), '"', -1), -- Extract "Winter Moon"
    air_date = SUBSTRING_INDEX(SUBSTRING_INDEX(csv_row, ',', -1), '"', 1) -- Extract "February 12, 1983"
    subjects_list = REPLACE(SUBSTRING_INDEX(csv_row, ',', -2), '"', '') -- Extract "subject1, subject2" and remove double quotes
WHERE
    csv_row LIKE '"%"';
    
UPDATE Subjects SET episode_id = REPLACE(episode, 'S', '');

UPDATE ColorPalettes SET color_id = REPLACE(color_hex, '#', '');
UPDATE ColorPalettes SET color_name = REPLACE(REPLACE(colors, '\r', ''), '\n', '');