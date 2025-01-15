const fs = require('fs');
const fsPromises = require('fs/promises');
const ytdl = require('@distube/ytdl-core');

async function fileExist(path) {
  try {
    fsPromises.access(path);
    return true;
  } catch (error) {
    console.log(error.message);
    return false;
  }
}

async function downloader(videoLink) {
  try {
    const info = await ytdl.getInfo(videoLink);
    
    if (await fileExist('./tmp/' + info.videoDetails.videoId + '.mp4')) {
      return {
        link: '/video/' + info.videoDetails.videoId + '.mp4',
        name: info.videoDetails.title,
        format: 'backup'
      };
    }

    const select = info.formats.filter(s => s.hasAudio && s.hasVideo);
    
    if (select.length > 0) {
      const dl = select[0]; // Vous pouvez choisir le format approprié ici
      const filename = info.videoDetails.videoId + '.mp4';
      console.log('download video: ' + info.videoDetails.title);

      ytdl(videoLink, { format: dl })
        .pipe(
          fs.createWriteStream('./tmp/' + filename)
        );
      return {
        link: '/video/' + filename,
        name: info.videoDetails.title,
        format: dl.qualityLabel
      };
    } else {
      // throw new Error('No video found with audio and video');
      return 'No video found with audio and video';
    }
  } catch (error) {
    console.log(error);
    return error.message;
  }
}

module.exports = { downloader };
