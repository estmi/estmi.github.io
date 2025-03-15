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

          // First, look for images directly in the static folder
          const files = fs.readdirSync(staticFolder);

          files.forEach((file) => {
            const extname = path.extname(file).toLowerCase();
            if (['.jpg', '.jpeg', '.png', '.gif', '.svg'].includes(extname)) {
              const imageName = path.basename(file, extname);
              const imagePath = `/${path.relative(staticDir, path.join(staticFolder, file))}`;
              imageReferences.push({ imageName, imagePath });
            }
          });

          // Now, check for a subfolder with the same name as the markdown file (without .md)
          const fileNameWithoutExtension = path.basename(mdFile, '.md');
          const subFolder = path.join(staticFolder, fileNameWithoutExtension);

          if (fs.existsSync(subFolder) && fs.statSync(subFolder).isDirectory()) {
            const subFiles = fs.readdirSync(subFolder);

            subFiles.forEach((file) => {
              const extname = path.extname(file).toLowerCase();
              if (['.jpg', '.jpeg', '.png', '.gif', '.svg'].includes(extname)) {
                const imageName = path.basename(file, extname);
                const imagePath = `/${path.relative(staticDir, path.join(subFolder, file))}`;
                imageReferences.push({ imageName, imagePath });
              }
            });
          }

          // Read the markdown file and check for any image usage
          const mdContent = fs.readFileSync(mdFile, 'utf-8');

          // Use a regular expression to find all image usages (without the path)
          const usedImages = [];
          const imageMatches = mdContent.match(/!\[([^\]]*)\]/g) || [];

          imageMatches.forEach((match) => {
            // Extract the image name from the markdown image syntax
            const matchParts = match.match(/!\[([^\]]*)\]/);
            if (matchParts && matchParts[1]) {
              usedImages.push(matchParts[1].trim());
            }
          });

          // Filter image references to only include those that are used in the markdown
          const usedImageReferences = imageReferences.filter((ref) => usedImages.includes(ref.imageName));

          // If there are used image references, check if they already exist in the markdown file
          if (usedImageReferences.length > 0) {
            // Find any existing references in the markdown file (references are at the bottom)
            const existingReferences = mdContent.match(/\[.*\]: .*$/gm) || [];

            // Filter out any references that are already in the markdown file
            const missingReferences = usedImageReferences.filter(
              (ref) => !existingReferences.some((existingRef) => existingRef.includes(ref.imageName))
            );

            // If there are missing references, update the markdown file
            if (missingReferences.length > 0) {
              // Prepare the references to be added at the end
              let updatedContent = `${mdContent}`;

              // Check if the last line is already a reference (so we won't add an extra blank line)
              const lastLine = updatedContent.split('\n').filter(line => line.trim()).pop();
              const isLastLineReference = lastLine && lastLine.match(/\[.*\]: .*$/);

              // Append the missing references without adding an extra blank line
              if (isLastLineReference) {
                updatedContent = `${updatedContent}${missingReferences.map((ref) => `[${ref.imageName}]: ${ref.imagePath}`).join('\n')}`;
              } else {
                updatedContent = `${updatedContent}\n\n${missingReferences.map((ref) => `[${ref.imageName}]: ${ref.imagePath}`).join('\n')}`;
              }

              // Ensure the file ends with a newline
              if (!updatedContent.endsWith('\n')) {
                updatedContent += '\n';
              }

              // Write the updated content back to the file
              fs.writeFileSync(mdFile, updatedContent);
              console.log(`Updated ${mdFile} with new image references`);
            } else {
              // console.log(`No new image references needed for ${mdFile}`);
            }
          }
        }
      });
    },
  };
};
