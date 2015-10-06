var fs = require("fs-extra"),
    path = require("path"),
    mkdirp = require("mkdirp"),
    config = require("./../config");

var FileHelper = {
    /**
     * Writes file contents to the specified folder
     * @param folderPath
     * @param fileContents
     */
    writeFileToFolder: function (folder, fileName, content) {
        fs.outputFile(path.join(folder, fileName), content, function(err){
            if(err) return console.error(err);
        });
    },

    appendToFile: function(folder, fileName, content) {
        mkdirp(folder, function(err) {
            if (err) console.error(err);

            fs.appendFile(path.join(folder, fileName), content + "\r\n", function (err) {
                if (err) return console.error(err);
            });
        });
    },

    readFile: function(filePath){
        return fs.readFileSync(filePath, "utf8");
    },

    /**
     * Synchronously returns a list of all file paths for a given folder path
     * @param path
     * @returns {*}
     */
    getFilesFromFolderPath: function(filePath, useFullPath) {
        useFullPath = typeof useFullPath !== "undefined" ? useFullPath : true;

        var fileList = fs.readdirSync(filePath);

        if(useFullPath) {
            fileList = fileList.map(function (file) {
                return path.normalize(filePath + "/" + file);
            });
        }

        return fileList;
    },

    /**
     * Returns a complete path for a specified folder
     * @param folder
     * @param path
     * @returns {string}
     */
    prefixFolderWithPath: function(folder, folderPath) {
        folderPath = folderPath || config.bundles.dir;
        return path.normalize(folderPath + "/" + folder);
    }
};

module.exports = FileHelper;