// Data Preparation - Read and parse CSV files to get data as JavaScript objects/arrays
const mysql = require('mysql');
const fs = require('fs');
const parse = require('csv-parse');


// Set up the database connection
const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: 'JOP',
});

// Insert data into the database
const episodesData = readEpisodesCSV();
const subjectsData = readSubjectsCSV();
const colorPalettesData = readColorPalettesCSV();
const episodeSubjectsData = readEpisodeSubjectsCSV();
const episodeColorsData = readEpisodeColorsCSV();

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }

  // Insert data into the Episodes table
  for (const episode of episodesData) {
    const { episode_id, episode_title, air_date } = episode;
    const sql = `INSERT INTO Episodes (episode_id, episode_title, air_date) VALUES (?, ?, ?)`;
    connection.query(sql, [episode_id, episode_title, air_date], (error, results) => {
      if (error) {
        console.error('Error inserting data into Episodes table:', error);
      }
    });
  }

  // Insert data into the Subjects table
  for (const subject of subjectsData) {
    const { subject_id, subject_name } = subject;
    const sql = `INSERT INTO Subjects (subject_id, subject_name) VALUES (?, ?)`;
    connection.query(sql, [subject_id, subject_name], (error, results) => {
      if (error) {
        console.error('Error inserting data into Subjects table:', error);
      }
    });
  }

  // Insert data into the ColorPalettes table
  for (const colorPalette of colorPalettesData) {
    const { color_id, color_name, hex_value } = colorPalette;
    const sql = `INSERT INTO ColorPalettes (color_id, color_name, hex_value) VALUES (?, ?, ?)`;
    connection.query(sql, [color_id, color_name, hex_value], (error, results) => {
      if (error) {
        console.error('Error inserting data into ColorPalettes table:', error);
      }
    });
  }

  // Insert data into the EpisodeSubjects table
  for (const episodeSubject of episodeSubjectsData) {
    const { episode_id, subject_id } = episodeSubject;
    const sql = `INSERT INTO EpisodeSubjects (episode_id, subject_id) VALUES (?, ?)`;
    connection.query(sql, [episode_id, subject_id], (error, results) => {
      if (error) {
        console.error('Error inserting data into EpisodeSubjects table:', error);
      }
    });
  }

  // Insert data into the EpisodeColors table
  for (const episodeColor of episodeColorsData) {
    const { episode_id, color_id } = episodeColor;
    const sql = `INSERT INTO EpisodeColors (episode_id, color_id) VALUES (?, ?)`;
    connection.query(sql, [episode_id, color_id], (error, results) => {
      if (error) {
        console.error('Error inserting data into EpisodeColors table:', error);
      }
    });
  }


  connection.end((err) => {
    if (err) {
      console.error('Error closing the database connection:', err);
    }
  });
});


module.exports = main;