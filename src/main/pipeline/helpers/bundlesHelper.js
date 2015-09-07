var fs = require("fs"),
    path = require("path");

var fileHelper = require("./fileHelper");

var gulpConfig;

// Only used by getBundleDependenciesList()
var bundleDependenciesCache = {};

/**
 * Returns a list of dependencies used by a bundle
 * @param bundleName
 * @returns {Array}
 */
function getBundleDependenciesList(bundleName) {
    var originalBundleName = bundleName;

    // Use the cached value if we have one
    if(typeof bundleDependenciesCache[originalBundleName] !== "undefined")
        return bundleDependenciesCache[originalBundleName];

    if(bundleName.match(/shared\//))
        bundleName = bundleName.replace(/(shared\/)/, "");

    var sharedBundleJSONPath = path.join(gulpConfig.bundles.dir, "shared", bundleName, "bundle.json");

    if(fs.existsSync(sharedBundleJSONPath)) {
        var bundleJSON = JSON.parse(fs.readFileSync(sharedBundleJSONPath, "utf8"));

        if(typeof bundleJSON.dependencies !== "undefined") {
            var returnVal = (bundleJSON.dependencies instanceof Array) ? bundleJSON.dependencies : [bundleJSON.dependencies];
            bundleDependenciesCache[originalBundleName] = returnVal;
            return returnVal;
        }
    }

    return [];
}

function Bundles(config) {
    gulpConfig = config;
    this.collection = {};
    this.fileListCache = {};

    var instance = this;

    // Synchronously load in our bundles. This is necessary for gulp to initialise properly without race conditions.
    fs.readdirSync(gulpConfig.bundles.dir)
        .forEach(function(folder) {
            var bundleJSONPath = path.join(gulpConfig.bundles.dir, folder, gulpConfig.bundles.entryPoint);

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
 * Returns the dependencies list for a specified bundle as well as the dependencies for dependencies #recursion
 * @param bundle
 * @returns {*}
 */
Bundles.prototype.getDependencies = function(bundle) {
    var rootDependencies = [],
        returnDependencies = [];

    if(typeof this.collection[bundle] !== "undefined" && typeof this.collection[bundle].dependencies !== "undefined")
        rootDependencies = this.collection[bundle].dependencies;
    else
        rootDependencies = getBundleDependenciesList(bundle);

    for(var i = 0; i < rootDependencies.length; i++) {
        var dependency = rootDependencies[i],
            dependencies = this.getDependencies(dependency);

        returnDependencies = returnDependencies.concat(dependencies);
    }

    returnDependencies = returnDependencies.concat(rootDependencies);

    // Remove duplicate dependencies and return
    return returnDependencies.filter(function(elem, index, self) {
        return index == self.indexOf(elem);
    });
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
 * Gets a list of files for a specified bundle
 * @param bundle
 * @param fileType
 * @returns {*}
 */
Bundles.prototype.getBundleFiles = function(bundle, fileType, useFullPath) {
    useFullPath = typeof useFullPath !== "undefined" ? useFullPath : true;
    fileType = fileType || "js";

    var fileListCacheKey = bundle + ":" + fileType + ":" + useFullPath;

    try {
        if (typeof this.fileListCache[fileListCacheKey] !== "undefined") {
            return this.fileListCache[fileListCacheKey];
        } else {
            var filePath = path.join(gulpConfig.bundles.dir, bundle, fileType);
            this.fileListCache[fileListCacheKey] = fileHelper.getFilesFromFolderPath(filePath, useFullPath);
            return this.fileListCache[fileListCacheKey];
        }
    } catch(err) {
        return [];
    }
};

module.exports = Bundles;