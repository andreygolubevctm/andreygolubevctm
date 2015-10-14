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
    sourcemaps = require("gulp-sourcemaps"),
    plumber = require("gulp-plumber"),
    fs = require("graceful-fs-extra"),
    runSequence = require('run-sequence'),
    path = require("path");

var EventEmitter = require("events").EventEmitter,
    eventEmitter = new EventEmitter();

function LessTasks(gulp) {
    var bundles = gulp.bundles;

    var taskPrefix = "less:",
        lessTasks = [];

    var watchesStarted = [],
        dependenciesCache = {};

    var gulpAction = function (glob, targetDir, taskName, fileList, brandCode, brandFileNames, bundle, done) {
        if (typeof dependenciesCache[taskName] === "undefined") {
            dependenciesCache[taskName] = "\r\n" + bundles.getDependencyFiles(bundle, "less")
                    .filter(function (dep) {
                        return dep.match(/(bundles)(\\|\/)(shared)/);
                    }).map(function (dep) {
                        return "@import \"" + dep + "\";"
                    }).join("\r\n");
        }

        var lessDependencies = dependenciesCache[taskName];

        // Functionality for "extension bundles"
        // replaceImports builds a list of files to replace the paths of in the supplied build file
        var replaceImports = [];

        if (typeof bundles.collection[bundle] !== "undefined" && typeof bundles.collection[bundle].extends !== "undefined") {
            replaceImports = bundles.getBundleFiles(bundle, "less", null, false);

            // Update the glob to point to the parent bundle if no build file is present
            if (replaceImports.length && replaceImports.indexOf("build.less") === -1) {
                glob = glob.replace("bundles\\" + bundle, "bundles\\" + bundles.collection[bundle].extends);
            }
        }

        var hasVariablesLess = (fileList.indexOf("variables.less") !== -1);

        var stream = gulp.src(glob)
            .pipe(plumber({
                errorHandler: gulp.globalPlugins.notify.onError("Error: <%= error.message %>")
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
        if (notInWatchesStarted) {
            stream = stream.pipe(
                watchLess(glob, {name: taskName}, function () {
                    gulpAction(glob, targetDir, taskName, fileList, brandCode, brandFileNames, bundle);
                })
            );

            watchesStarted.push(taskName);
        }

        stream.pipe(
                intercept(function (file) {
                    // Check if there are imports to replace (from a bundle extending another bundle)
                    if (replaceImports.length) {
                        var contents = file.contents.toString();

                        contents = contents.split(";").map(function(line) {
                            if(line.match(/(webapp)/)) {
                                var matchAt = "bundles",
                                    parsedLine = line
                                        .replace(/\\/g, "/")
                                        .substring(line.indexOf(matchAt) + matchAt.length, line.length)
                                        .replace("/", "");

                                line = "@import \"../../" + parsedLine;
                            }

                            return line;
                        }).join(";\r\n").replace(/\s{2,}/g, "\r\n");

                        var parentBundlePath = "\"../../" + bundles.collection[bundle].extends + "/less/";

                        // Use import paths relative to the extended bundle
                        contents = contents.replace(/(\")([a-z])/g, parentBundlePath + "$2");

                        for (var i = 0; i < replaceImports.length; i++) {
                            contents = contents.replace(parentBundlePath + replaceImports[i], "\"" + replaceImports[i]);
                        }

                        file.contents = new Buffer(contents);
                    }

                    return file;
                })
            )
            // Parse the LESS
            .pipe(sourcemaps.init())
            .pipe(less(glob, {
                name: taskName,
                paths: [
                    path.join(gulp.pipelineConfig.bundles.dir),
                    path.join(gulp.pipelineConfig.bootstrap.dir, "less")
                ]
            }))
            .pipe(rename(bundle + ".css"))
            .pipe(sourcemaps.write("./maps"))
            .pipe(gulp.dest(targetDir))
            .pipe(gulp.globalPlugins.notify({
                title: taskName + " compiled",
                message: bundle + " successfully compiled"
            }))
            .pipe(intercept(function(file){
                return file;
            }))
            .on("end", function () {
                var filePath = path.join(targetDir, bundle + ".css"),
                    eventName = "less:" + (+ new Date()),
                    taskList = [
                        require("./minify")(gulp, filePath, brandCode, bundle),
                        require("./bless")(gulp, filePath, brandCode, bundle)
                    ],
                    counter = 0;

                eventEmitter.on(eventName, function(){
                    counter++;

                    if(counter === taskList.length && done)
                        done();
                });

                taskList.forEach(function(task) {
                    task.on("end", function(){
                        eventEmitter.emit(eventName);
                    });
                });
            });
    };

    for (var bundle in bundles.collection) {
        (function (bundle) {
            var sourceFolder = (typeof bundles.collection[bundle].originalBundle !== "undefined") ? bundles.collection[bundle].originalBundle : bundle,
                brandCodes = bundles.getBundleBrandCodes(bundle),
                bundleLessTasks = [],
                fileList = bundles.getBundleFiles(bundle, "less", false);

            for (var i = 0; i < brandCodes.length; i++) {
                var brandCode = brandCodes[i];

                (function (brandCode) {
                    var brandCodeTask = taskPrefix + bundle + ":" + brandCode,
                        brandCodeBundleSrcPath = path.join(gulp.pipelineConfig.bundles.dir, sourceFolder, "less", "build.less"),
                        targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");

                    gulp.task(brandCodeTask, function (done) {
                        var brandFileNames = {
                            variables: "variables." + brandCode + ".less",
                            theme: "theme." + brandCode + ".less"
                        };

                        gulpAction(brandCodeBundleSrcPath, targetDir, brandCodeTask, fileList, brandCode, brandFileNames, bundle, done);
                    });

                    bundleLessTasks.push(brandCodeTask);
                })(brandCode);
            }

            var bundleTaskName = taskPrefix + bundle;
            gulp.task(bundleTaskName, bundleLessTasks);
            lessTasks.push(bundleTaskName);
        })(bundle);
    }

    // Because there are so damn many LESS tasks, we split them up and only run a few concurrently at a time
    gulp.task("less", function(callback){
        var tasksArray = [],
            chunkSize = 5;

        while(lessTasks.length > 0)
            tasksArray.push(lessTasks.splice(0, chunkSize));

        tasksArray.push(callback);

        runSequence.apply(this, tasksArray);
    });
};

module.exports = LessTasks;