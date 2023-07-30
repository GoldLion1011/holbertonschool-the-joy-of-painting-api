-- Create the "Episodes" table
CREATE TABLE Episodes (
  episode_id INT PRIMARY KEY AUTO_INCREMENT,
  episode_title VARCHAR(255),
  original_broadcast_date DATE,
);

-- Create the "Subjects" table
CREATE TABLE Subjects (
  subject_id INT PRIMARY KEY AUTO_INCREMENT,
  subject_name VARCHAR(255),
);

-- Create the "ColorPalettes" table
CREATE TABLE ColorPalettes (
  color_id INT PRIMARY KEY AUTO_INCREMENT,
  color_name VARCHAR(255),
  hex_value VARCHAR(7), -- Use VARCHAR to store the hex value (e.g., '#FF0000')

-- Create the "EpisodeSubjects" junction table (Many-to-Many relationship)
CREATE TABLE EpisodeSubjects (
  episode_id INT,
  subject_id INT,
  PRIMARY KEY (episode_id, subject_id),
  FOREIGN KEY (episode_id) REFERENCES Episodes(episode_id) ON DELETE CASCADE,
  FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id) ON DELETE CASCADE
);

-- Create the "EpisodeColorPalettes" junction table (Many-to-Many relationship)
CREATE TABLE EpisodeColorPalettes (
  episode_id INT,
  color_id INT,
  PRIMARY KEY (episode_id, color_id),
  FOREIGN KEY (episode_id) REFERENCES Episodes(episode_id) ON DELETE CASCADE,
  FOREIGN KEY (color_id) REFERENCES ColorPalettes(color_id) ON DELETE CASCADE
);
