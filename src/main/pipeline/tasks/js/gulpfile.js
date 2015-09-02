/**
 * Build JS Tasks
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var path = require("path");

var concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    rename = require("gulp-rename");

// TODO: Add .map files
// TODO: Build .tpl file which includes references to <script src=""></script> for each individual file

function JSTasks(gulp) {
    var bundles = gulp.bundles;

    var taskPrefix = "js:",
        targetDirectory = path.join(gulp.pipelineConfig.target.dir, "js");

    var bundleTasks = [];

    // Generic Gulp action
    // - Combine files into single JS and write to target directory
    // - Uglify combined file and write to target directory
    var gulpAction = function (fileArray, fileName) {
        return gulp.src(fileArray)
            .pipe(concat(fileName + ".js"))
            .pipe(gulp.dest(targetDirectory))
            .pipe(uglify())
            .pipe(rename(fileName + ".min.js"))
            .pipe(gulp.dest(targetDirectory));
    };

    // Iterate through provided bundles and create build JS tasks for each loaded bundle
    for (var bundle in bundles.collection) {
        (function (bundle) {
            var bundleTask = taskPrefix + bundle,
                bundleTaskOnLoad = bundleTask + ":onload",
                bundleTaskAsync = bundleTask + ":async";

            // Tasks to be run on watch of bundle file change
            var watchTasks = [];

            // Array of dependencies file paths
            var dependenciesFileArray = bundles.getJSDependencyFiles(bundle),
            // Array of bundle file paths
                bundleFileArray = bundles.getBundleFiles(bundle, "js"),
            // All files living together happily
                completeFileArray = dependenciesFileArray.concat(bundleFileArray),
            // Array of files to be loaded on page load
                onLoadFileArray = [],
            // Array of files to be loaded after page load
                deferredFileArray = [];

            // Total combined JS (ignoring before/after page load)
            gulp.task(bundleTask, function () {
                return gulpAction(completeFileArray, bundle);
            });

            bundleTasks.push(bundleTask);
            watchTasks.push(bundleTask);

            // Look for files that should be included on load and put their paths in the appropriate array
            for (var i = 0; i < completeFileArray.length; i++) {
                var filePath = completeFileArray[i];
                if (filePath.match(/(\.onload\.js)/)) {
                    onLoadFileArray.push(filePath);
                } else {
                    deferredFileArray.push(filePath);
                }
            }


            if (onLoadFileArray.length) {
                // JS loaded on page load
                gulp.task(bundleTaskOnLoad, function () {
                    var fileName = bundle + ".onload";
                    return gulpAction(onLoadFileArray, fileName);
                });

                bundleTasks.push(bundleTaskOnLoad);
                watchTasks.push(bundleTaskOnLoad);

                // JS loaded after page load
                gulp.task(bundleTaskAsync, function () {
                    var fileName = bundle + ".deferred";
                    return gulpAction(deferredFileArray, fileName);
                });

                bundleTasks.push(bundleTaskAsync);
                watchTasks.push(bundleTaskAsync);
            }

            // Files paths to watch
            var bundleDependencies = bundles.getWatchableBundlesJSFilePaths(bundle);

            gulp.watch(bundleDependencies, watchTasks);
        })(bundle);
    }

    // Run it!
    gulp.task("js", bundleTasks);
}

module.exports = JSTasks;