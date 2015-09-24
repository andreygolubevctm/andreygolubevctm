/**
 * LESS Tasks
 * Compiles LESS in bundles into CSS with minified versions for specified brand codes
 * e.g.: `gulp less:health` will compile health's LESS for all brand codes
 * e.g.: `gulp less:health:ctm` will compile health's LESS for the CTM brand code
 *
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
//"use strict";

var less = require("gulp-less"),
    concat = require("gulp-concat"),
    rename = require("gulp-rename"),
    insert = require("gulp-insert"),
    watchLess = require("gulp-watch-less"),
    gulpIf = require("gulp-if"),
    intercept = require("gulp-intercept"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    fs = require("fs"),
    path = require("path");

function LessTasks(gulp) {
    var bundles = gulp.bundles;

    var taskPrefix = "less:",
        lessTasks = [];

    var watchesStarted = [],
        dependenciesCache = {};

    var gulpAction = function(glob, targetDir, taskName, fileList, brandCode, brandFileNames, bundle, compileAs) {
        if(typeof compileAs !== "undefined" && compileAs.constructor === Array) {
            for(var i = 0; i < compileAs.length; i++) {
                gulpAction(glob, targetDir, taskName, fileList, brandCode, brandFileNames, bundle, compileAs[i]);
            }
        } else {
            if(typeof dependenciesCache[taskName] === "undefined") {
                dependenciesCache[taskName] = "\r\n" + bundles.getDependencyFiles(bundle, "less")
                    .filter(function(dep) {
                        return dep.match(/(bundles)(\\|\/)(shared)/);
                    }).map(function(dep) {
                        return "@import \"" + dep + "\";"
                    }).join("\r\n");
            }

            var lessDependencies = dependenciesCache[taskName];

            // Functionality for "extension bundles"
            // replaceImports builds a list of files to replace the paths of in the supplied build file
            var replaceImports = [],
                useParentBundleBuild = false;

            if(typeof bundles.collection[bundle] !== "undefined" && typeof bundles.collection[bundle].extends !== "undefined") {
                replaceImports = bundles.getBundleFiles(bundle, "less", null, false);

                // Update the glob to point to the parent bundle if no build file is present
                if(replaceImports.length && replaceImports.indexOf("build.less") === -1) {
                    glob = glob.replace("bundles\\" + bundle, "bundles\\" + bundles.collection[bundle].extends);
                    useParentBundleBuild = true;
                }
            }

            // Used when bundles specify a "compileAs" value and uses that as a bundle name
            if(typeof compileAs === "string")
                bundle = compileAs;

            var hasVariablesLess = (fileList.indexOf("variables.less") !== -1);

            var stream = gulp.src(glob)
                .pipe(plumber({
                    errorHandler: notify.onError("Error: <%= error.message %>")
                }))
                // Insert LESS dependencies
                .pipe(
                    gulpIf(
                        lessDependencies !== "",
                        insert.prepend(lessDependencies)
                    )
                )
                // Prepend brand specific variables if file exists
                .pipe(
                    gulpIf(
                        fileList.indexOf(brandFileNames.variables) !== -1,
                        insert.prepend("@import \"" + brandFileNames.variables + "\";\r\n")
                    )
                )
                // Prepend variables if file exists
                .pipe(gulpIf(hasVariablesLess, insert.prepend("@import \"variables.less\";\r\n")))
                // Prepend generic brand build file
                .pipe(insert.prepend("@import \"../../build/brand/" + brandCode + "/build.less\";\r\n"))
                // Append brand specific theme less if file exists
                .pipe(
                    gulpIf(
                        fileList.indexOf(brandFileNames.theme) !== -1,
                        insert.append("\r\n@import \"" + brandFileNames.theme + "\";")
                    )
                );

            var notInWatchesStarted = (watchesStarted.indexOf(taskName) === -1);

            // We need to conditionally call the watchLess method this way because it seems to run regardless with gulpIf()
            // Boo. :(
            if(notInWatchesStarted) {
                stream = stream.pipe(
                    watchLess(glob, { name: taskName }, function() {
                        gulpAction(glob, targetDir, taskName, fileList, brandCode, brandFileNames, bundle, compileAs);
                    })
                );

                watchesStarted.push(taskName);
            }

            return stream.pipe(
                    intercept(function(file) {
                        // Check if there are imports to replace (from a bundle extending another bundle)
                        if(replaceImports.length) {
                            var contents = file.contents.toString();

                            if(useParentBundleBuild) {
                                // If using the parent build, we should update the import paths to be relative
                                // to the parent bundle
                                for (var i = 0; i < replaceImports.length; i++) {
                                    contents = contents.replace("\"" + replaceImports[i], "\"../../" + bundle + "/less/" + replaceImports[i])
                                }
                            } else {
                                // Use import paths relative to the extended bundle
                                contents = contents.replace(/(\")([a-z])/g, "\"../../" + bundles.collection[bundle].extends + "/less/$2");

                                for (var i = 0; i < replaceImports.length; i++) {
                                    contents = contents.replace("\"../../" + bundles.collection[bundle].extends + "/less/" + replaceImports[i], "\"" + replaceImports[i])
                                }
                            }

                            file.contents = new Buffer(contents);
                        }

                        return file;
                    })
                )
                // Parse the LESS
                .pipe(less(glob, { name: taskName }))
                .pipe(rename(bundle + ".css"))
                .pipe(gulp.dest(targetDir))
                .pipe(notify({
                    title: taskName + " compiled",
                    message: bundle + " successfully compiled"
                }));
        }
    };

    for(var bundle in bundles.collection) {
        (function (bundle) {
            var brandCodes = bundles.getBundleBrandCodes(bundle);

            var bundleLessTasks = [];

            var fileList = bundles.getBundleFiles(bundle, "less", false),
                compileAs = bundles.collection[bundle].compileAs;

            for (var i = 0; i < brandCodes.length; i++) {
                var brandCode = brandCodes[i];

                (function(brandCode) {
                    var brandCodeTask = taskPrefix + bundle + ":" + brandCode,
                        brandCodeBundleSrcPath = path.join(gulp.pipelineConfig.bundles.dir, bundle, "less", "build.less");

                    var targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");

                    gulp.task(brandCodeTask, function () {
                        var brandFileNames = {
                                variables: "variables." + brandCode + ".less",
                                theme: "theme." + brandCode + ".less"
                            };

                        return gulpAction(brandCodeBundleSrcPath, targetDir, brandCodeTask, fileList, brandCode, brandFileNames, bundle, compileAs);
                    });

                    bundleLessTasks.push(brandCodeTask);
                })(brandCode);
            }

            var bundleTaskName = taskPrefix + bundle;
            gulp.task(bundleTaskName, bundleLessTasks);
            lessTasks.push(bundleTaskName);
        })(bundle);
    }

    gulp.task("less", lessTasks);
};

module.exports = LessTasks;