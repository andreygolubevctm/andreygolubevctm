var fs = require("fs"),
    path = require("path");

var fileHelper = require("./fileHelper");

function Bundles(config) {
    this.config = config;
    this.collection = {};
    this.fileListCache = {};

    var instance = this,
        config = this.config;

    // Synchronously load in our bundles. This is necessary for gulp to initialise properly without race conditions.
    fs.readdirSync(config.bundles.dir)
        .forEach(function(folder) {
            var bundleJSONPath = path.join(config.bundles.dir, folder, config.bundles.entryPoint);

            if(fs.existsSync(bundleJSONPath)) {
                var bundleJSON = fs.readFileSync(bundleJSONPath, "utf8");
                instance.addBundle(folder, bundleJSON);
            }
        });
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
Bundles.prototype.getJSDependencies = function(bundle) {
    return (typeof this.collection[bundle].jsDependencies !== "undefined") ? this.collection[bundle].jsDependencies : [];
};

/**
 * Returns a list of file paths from a bundle's dependencies
 * @param bundle
 * @param fileType
 * @returns {Array}
 */
Bundles.prototype.getJSDependencyFiles = function(bundle, fileType) {
    fileType = fileType || "js";

    var dependencies = this.getJSDependencies(bundle),
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
Bundles.prototype.getWatchableBundlesJSFilePaths = function(bundle, fileType) {
    fileType = fileType || "js";

    var dependencies = this.getJSDependencies(bundle);

    dependencies.push(bundle);

    return dependencies.map(function(dependency){
        return fileHelper.prefixFolderWithPath(dependency) + "/" + fileType + "/*." + fileType;
    });
};

/**
 * Gets a list of files for a specified bundle
 * @param bundle
 * @param fileType
 * @returns {*}
 */
Bundles.prototype.getBundleFiles = function(bundle, fileType, useFullPath) {
    useFullPath = typeof useFullPath !== "undefined" ? useFullPath : true;
    fileType = fileType || "js";

    var fileListCacheKey = bundle + ":" + fileType;

    if(typeof this.fileListCache[fileListCacheKey] !== "undefined") {
        return this.fileListCache[fileListCacheKey];
    } else {
        var filePath = path.join(this.config.bundles.dir, bundle, fileType);
        this.fileListCache[fileListCacheKey] = fileHelper.getFilesFromFolderPath(filePath, useFullPath);
        return this.fileListCache[fileListCacheKey];
    }
};

module.exports = Bundles;