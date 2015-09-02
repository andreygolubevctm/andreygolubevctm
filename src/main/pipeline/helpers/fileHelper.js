var fs = require("fs"),
    config = require("./../config");

var FileHelper = {
    /**
     * Synchronously returns a list of all file paths for a given folder path
     * @param path
     * @returns {*}
     */
    getFilesFromFolderPath: function(path, useFullPath) {
        useFullPath = typeof useFullPath !== "undefined" ? useFullPath : true;

        var fileList = fs.readdirSync(path);

        if(useFullPath) {
            fileList = fileList.map(function (file) {
                return path + "/" + file;
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
    prefixFolderWithPath: function(folder, path) {
        path = path || config.bundles.dir;
        return path + "/" + folder;
    }
};

module.exports = FileHelper;