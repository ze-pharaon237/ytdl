const express = require('express');
const path = require('path');
const { downloader } = require('../utils/downloader');
const { cleanTmpFiles } = require('../utils/cron');

const app = express();
app.use(express.static(path.join(__dirname, '..', '..', 'public')));

app.use('/video/:key', (req, res) => {
    const filename = req.params.key;
    const filepath = path.join(__dirname, '/tmp/', filename);
    res.header('Content-Disposition', `attachment; filename="${filename}"`);
    res.sendFile(filepath);
    cleanTmpFiles();
});

app.get('/api/gen', async (req, res) => {
    console.log(req.query);

    let result = await downloader(req.query.l ?? 'null');
    res.send(result);
    cleanTmpFiles();
});

app.get('/', async (req, res) => {
    console.log(req.query);

    res.sendFile(path.join(__dirname, '../../','/public/index.html'));
    cleanTmpFiles();
});

app.get('/test', async  (req, res) => {
  res.send('OK');
})

app.get('/api/clean', async (req, res) => {
    cleanTmpFiles();
    res.send('OK');
});

module.exports = app;