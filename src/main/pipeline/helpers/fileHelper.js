var fs = require("fs"),
    config = require("./../config");

var FileHelper = {
    /**
     * Returns a list of all file paths for a given folder path
     * @param path
     * @returns {*}
     */
    getFilesFromFolderPath: function(path) {
        var fileList = fs.readdirSync(path);

        fileList = fileList.map(function(file){
            return path + "/" + file;
        });

        return fileList;
    },

    /**
     * Returns a complete path for a specified folder
     * @param folder
     * @param path
     * @returns {string}
     */
    prefixFolderWithPath: function(folder, path) {
        path = path || config.bundles.dir;
        return path + "/" + folder;
    }
};

module.exports = FileHelper;