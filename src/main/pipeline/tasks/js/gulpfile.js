/**
 * JS Tasks
 * Compiles a bundle's JS with a minified version
 * e.g.: `gulp js:health` will compile the health bundle's JS
 *
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var path = require("path");

var concat = require("gulp-concat"),
    beautify = require("gulp-beautify"),
    uglify = require("gulp-uglify"),
    sourcemaps = require("gulp-sourcemaps");

var fileHelper = require("./../../helpers/fileHelper");

function JSTasks(gulp) {
    var bundles = gulp.bundles;

    var taskPrefix = "js:",
        targetDirectory = path.join(gulp.pipelineConfig.target.dir, "js", "bundles");

    var bundleTasks = [];

    // Generic Gulp action
    // - Combine files into single JS and write to target directory
    // - Uglify combined file and write to target directory
    var gulpAction = function (taskName, fileArray, fileName, done) {
        var incDir = path.join(gulp.pipelineConfig.target.dir, "includes", "js"),
            revDate = + new Date();

        fileHelper.writeFileToFolder(incDir, fileName + gulp.pipelineConfig.target.inc.extension, fileArray.map(function(file){
            return "<script type=\"text\/javascript\" src=\"" + file.slice(file.indexOf("bundles"), file.length).replace(/\\/g, "/") + "?rev=" + revDate + "\"></script>";
        }).join("\r\n"));

        gulp.src(fileArray)
            .pipe(gulp.globalPlugins.plumber({
                errorHandler: gulp.globalPlugins.notify.onError("Error: <%= error.message %>")
            }))
            .pipe(concat(fileName + ".js"))
            .pipe(beautify())
            .pipe(gulp.dest(targetDirectory))
            .pipe(gulp.globalPlugins.notify({
                title: taskName + " compiled",
                message: fileName + " successfully compiled"
            }))
            .pipe(uglify())
            .pipe(gulp.globalPlugins.rename(fileName + ".min.js"))
            .pipe(gulp.dest(targetDirectory))
            .pipe(gulp.globalPlugins.debug({
                title: "Finished Minify JS"
            }))
            .pipe(gulp.globalPlugins.intercept(function(file){
                return file;
            }))
            .on("end", function() {
                var lint = require("./lint")(gulp, fileArray);

                if(lint.hasOwnProperty("on")) {
                    lint.on("end", function(){
                        done();
                    });
                } else {
                    done();
                }
            });
    };

    // Iterate through provided bundles and create build JS tasks for each loaded bundle
    for (var bundle in bundles.collection) {
        (function (bundle) {
            var bundleTask = taskPrefix + bundle,
                bundleTaskOnLoad = bundleTask + ":onload",
                bundleTaskAsync = bundleTask + ":async";

                // Array of dependencies file paths
            var dependenciesFileArray = bundles.getDependencyFiles(bundle, "js", true),
                // Array of bundle file paths
                bundleFileArray = bundles.getBundleFiles(bundle, "js", true),
                // All files living together happily
                completeFileArray = dependenciesFileArray.concat(bundleFileArray),
                // Array of files to be loaded on page load
                onLoadFileArray = [],
                // Array of files to be loaded after page load
                deferredFileArray = [];

            // Look for files that should be included on load and put their paths in the appropriate array
            for (var i = 0; i < completeFileArray.length; i++) {
                var filePath = completeFileArray[i];
                if (filePath.match(/(\.deferred\.js)/)) {
                    deferredFileArray.push(filePath);
                } else {
                    onLoadFileArray.push(filePath);
                }
            }

            // JS loaded on page load
            gulp.task(bundleTaskOnLoad, function (done) {
                var fileName = bundle;
                gulp.watch(onLoadFileArray, [bundleTaskOnLoad]);
                return gulpAction(bundleTaskOnLoad, onLoadFileArray, fileName, done);
            });

            // JS loaded after page load
            gulp.task(bundleTaskAsync, function (done) {
                var fileName = bundle + ".deferred";
                gulp.watch(deferredFileArray, [bundleTaskAsync]);
                return gulpAction(bundleTaskAsync, deferredFileArray, fileName, done);
            });

            gulp.task(bundleTask, [bundleTaskOnLoad, bundleTaskAsync]);
            bundleTasks.push(bundleTask);
        })(bundle);
    }

    // Run it!
    gulp.task("js", bundleTasks);
}

module.exports = JSTasks;