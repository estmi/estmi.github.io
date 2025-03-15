const path = require('path');
const fs = require('fs');
const glob = require('glob');

module.exports = function autoImageReferencesPlugin(context, options) {
  return {
    name: 'auto-image-references-plugin',

    // This hook runs when the docs are loaded
    async contentLoaded({ content, actions }) {
      const docsDir = path.join(context.siteDir, 'docs');
      const staticDir = path.join(context.siteDir, 'static');
      
      // Get all markdown files in the docs folder
      const mdFiles = glob.sync(path.join(docsDir, '**/*.md'));

      mdFiles.forEach((mdFile) => {
        const docDir = path.dirname(mdFile); // The directory of the markdown file
        const relativeDir = path.relative(docsDir, docDir); // Relative path from docsDir
        const staticFolder = path.join(staticDir, relativeDir);

        // If the static folder exists, look for images
        if (fs.existsSync(staticFolder)) {
          const imageReferences = [];
          const files = fs.readdirSync(staticFolder);

          files.forEach((file) => {
            const extname = path.extname(file).toLowerCase();
            // Only consider image files (jpg, png, etc.)
            if (['.jpg', '.jpeg', '.png', '.gif', '.svg'].includes(extname)) {
              const imageName = path.basename(file, extname);
              const imagePath = `/${path.relative(staticDir, path.join(staticFolder, file))}`;
              imageReferences.push(`[${imageName}]: ${imagePath}`);
            }
          });

          // If there are image references and the markdown file is not already updated, update it
          if (imageReferences.length > 0) {
            const mdContent = fs.readFileSync(mdFile, 'utf-8');

            // Check if the references already exist in the markdown file
            const existingReferences = mdContent.match(/\[.*\]: .*$/gm) || [];
            const missingReferences = imageReferences.filter(
              (ref) => !existingReferences.includes(ref)
            );

            if (missingReferences.length > 0) {
              // If there are any missing references, append them
              const updatedContent = `${mdContent}\n${missingReferences.join('\n')}`;
              fs.writeFileSync(mdFile, updatedContent);
              console.log(`Updated ${mdFile} with image references`);
            } else {
              console.log(`No updates needed for ${mdFile}`);
            }
          }
        }
      });
    },
  };
};
