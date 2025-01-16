const fs = require('fs');
const path = require('path');

async function cleanTmpFiles() {

  // Chemin vers le répertoire tmp
  const dirPath = path.join(__dirname, '../../', 'tmp');

  // Période de validité en millisecondes (15 minutes = 15 * 60 * 1000 ms)
  const maxAge = 1 * 60 * 1000;

  // Parcourir le répertoire tmp
  fs.readdir(dirPath, (err, files) => {
    if (err) {
      return console.error('Erreur lors de la lecture du répertoire:', err);
    }

    // Parcourir chaque fichier dans le répertoire
    files.forEach(file => {
      // Récupérer le nom du fichier sans extension
      const filename = path.basename(file, path.extname(file));

      // Vérifier si le nom est un timestamp en millisecondes
      if (!isNaN(filename)) {
        const fileTimestamp = parseInt(filename, 10);
        const currentTime = Date.now();

        // Si le fichier est plus ancien que 15 minutes, le supprimer
        if (currentTime - fileTimestamp > maxAge) {
          const filePath = path.join(dirPath, file);
          fs.unlink(filePath, (err) => {
            if (err) {
              console.error('Erreur lors de la suppression du fichier:', err);
            } else {
              console.log('Fichier supprimé:', filePath);
            }
          });
        }
      }
    });
  });

}

module.exports = { cleanTmpFiles };