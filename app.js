// Let's make this an API server that can filter the episodes based on the following criteria:
// - month: the month of the air date (1-12)
// - subject: the subject of the episode (e.g. "Mathematics")
// - colors: the colors of the episode (e.g. "Red,Blue")
// - matchType: whether to match all criteria or any criteria (e.g. "all" or "any")

require('dotenv').config();


const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 3000;

const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: 'JOP',
});

app.get('/episodes', (req, res) => {
  // Retrieve filtering criteria from req.query (query parameters)
  const { month, subject, colors, matchType } = req.query;

  // Build the SQL query based on the filtering criteria
  let sql = 'SELECT * FROM Episodes';
  const whereClauses = [];

  if (month) {
    whereClauses.push(`MONTH(air_date) = ${connection.escape(month)}`);
  }

  if (subject) {
    whereClauses.push(`episode_id IN (SELECT episode_id FROM EpisodeSubjects WHERE subject_id = ${connection.escape(subject)})`);
  }

  if (colors) {
    const colorList = colors.split(',');
    const colorIds = colorList.map(color => connection.escape(color));
    whereClauses.push(`episode_id IN (SELECT episode_id FROM EpisodeColors WHERE color_id IN (${colorIds.join(',')}))`);
  }

  if (whereClauses.length > 0) {
    sql += ' WHERE ' + (matchType === 'all' ? whereClauses.join(' AND ') : whereClauses.join(' OR '));
  }

  // Execute the SQL query
  connection.query(sql, (err, results) => {
    if (err) {
      console.error('Error executing the SQL query:', err);
      res.status(500).json({ error: 'Internal Server Error' });
      return;
    }

    // Send the JSON response with the list of filtered episodes
    res.json(results);
  });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
