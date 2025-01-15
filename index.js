const express = require('express');
const path = require('path');
const { downloader } = require('./downloader');
const { cleanTmpFiles } = require('./cron');
const app = express();
const port = 3000;

app.use('/video/:key', (req, res) => {
    const filename = req.params.key;
    const filepath = path.join(__dirname, '/tmp/', filename);
    res.header('Content-Disposition', `attachment; filename="${filename}"`);
    res.sendFile(filepath);
    cleanTmpFiles();
});

app.get('/gen', async (req, res) => {
    console.log(req.query);

    let result = await downloader(req.query.l ?? 'null');
    res.send(result);
    cleanTmpFiles();
});

app.get('/', async (req, res) => {
    console.log(req.query);

    res.sendFile(path.join(__dirname, '/views/index.html'));
    cleanTmpFiles();
});

app.get('/clean', async (req, res) => {
    cleanTmpFiles();
});

app.listen(port, () => {
    console.log(`App listening on port ${port}`)
})