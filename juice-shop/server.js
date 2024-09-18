const express = require('express');
const app = express();
const port = 3000;

// Serve static files from the "views" directory
app.use(express.static('views'));

// Route to the homepage
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/views/index.html');
});

// Start the server
app.listen(port, () => {
  console.log(`Dummy Juice Shop app listening at http://localhost:${port}`);
});
