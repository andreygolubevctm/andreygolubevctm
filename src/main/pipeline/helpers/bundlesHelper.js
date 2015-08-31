var fileHelper = require("./fileHelper");

function Bundles(config) {
    this.config = config;
    this.collection = {};
}

/**
 * Adds a bundle with to the collection with the bundle.json information included
 * @param bundleName
 * @param bundleInfo
 */
Bundles.prototype.addBundle = function(bundleName, bundleInfo) {
    if(typeof bundleInfo === "string") {
        bundleInfo = JSON.parse(bundleInfo);
    }

    this.collection[bundleName] = bundleInfo;
};

/**
 * Returns all bundles which are used by a specified brand code
 * @param bundleName
 * @returns {*}
 */
Bundles.prototype.getBundleBrandCodes = function(bundleName) {
    return this.collection[bundleName].brandCodes;
};

/**
 * Returns all brand codes used across all bundles
 * @returns {Array}
 */
Bundles.prototype.getBrandCodes = function() {
    var brandCodes = [];

    for(var bundle in this.collection) {
        var bundleBrandCodes = this.collection[bundle].brandCodes;

        for(var i = 0; i < bundleBrandCodes.length; i++) {
            var brandCode = bundleBrandCodes[i];

            if(brandCodes.indexOf(brandCode) === -1) {
                brandCodes.push(brandCode);
            }
        }
    }
    
    return brandCodes;
};

/**
 * Returns the bundles for a specified brand code
 * @param brandCode
 * @returns {Array}
 */
Bundles.prototype.getBrandCodeBundles = function(brandCode) {
    var bundles = [];

    for(var bundle in this.collection) {
        var bundleBrandCodes = this.collection[bundle].brandCodes;

        if(bundleBrandCodes.indexOf(brandCode) !== -1) {
            bundles.push(bundle);
        }
    }

    return bundles;
};

/**
 * Returns the dependencies list for a specified bundle
 * @param bundle
 * @returns {*}
 */
Bundles.prototype.getDependencies = function(bundle) {
    return (typeof this.collection[bundle].dependencies !== "undefined") ? this.collection[bundle].dependencies : [];
};

/**
 * Returns a list of file paths from a bundle's dependencies
 * @param bundle
 * @param fileType
 * @returns {Array}
 */
Bundles.prototype.getDependencyFiles = function(bundle, fileType) {
    fileType = fileType || "js";

    var dependencies = this.getDependencies(bundle),
        dependenciesFiles = [];

    if(dependencies.length) {
        for(var i = 0; i < dependencies.length; i++) {
            var dependency = dependencies[i],
                dependencyFiles = this.getBundleFiles(dependency, fileType);
            dependenciesFiles = dependenciesFiles.concat(dependencyFiles);
        }
    }

    return dependenciesFiles;
};

/**
 * Returns a list of file paths a bundle should be able to watch for changes against
 * @param bundle
 * @param fileType
 * @returns {*|Array}
 */
Bundles.prototype.getWatchableBundlesFilePaths = function(bundle, fileType) {
    fileType = fileType || "js";

    var dependencies = this.getDependencies(bundle);

    dependencies.push(bundle);

    return dependencies.map(function(dependency){
        return fileHelper.prefixFolderWithPath(dependency) + "/" + fileType + "/*." + fileType;
    });
};

/**
 *
 * @param bundle
 * @param fileType
 * @returns {*}
 */
Bundles.prototype.getBundleFiles = function(bundle, fileType) {
    fileType = fileType || "js";

    var path = [
            this.config.bundles.dir,
            bundle,
            fileType
        ].join("/");

    return fileHelper.getFilesFromFolderPath(path);
};

module.exports = Bundles;