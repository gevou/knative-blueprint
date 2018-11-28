const express = require('express');
const app = express();

app.get('/', function (req, res) {
  console.log('Hello world received a request.');

  const target = process.env.TARGET || 'Universe v2';
  res.send('Hello ' + target + '!');
});

const port = process.env.PORT || 8080;
app.listen(port, function () {
  console.log('Hello world listening on port', port);
});