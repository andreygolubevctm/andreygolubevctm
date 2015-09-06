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
    minifyCSS = require("gulp-minify-css"),
    rename = require("gulp-rename"),
    insert = require("gulp-insert"),
    watchLess = require("gulp-watch-less"),
    gulpIf = require("gulp-if"),
    plumber = require("gulp-plumber"),
    sakugawa = require('gulp-sakugawa'),
    notify = require("gulp-notify"),
    fs = require("fs"),
    path = require("path");

// TODO: Add .map files

function LessTasks(gulp) {
    var bundles = gulp.bundles;

    var taskPrefix = "less:",
        lessTasks = [];

    var watchesStarted = [];

    var gulpAction = function(glob, targetDir, taskName, fileList, brandCode, brandFileNames, fileName, compileAs) {
        if(typeof compileAs !== "undefined" && compileAs.constructor === Array) {
            for(var i = 0; i < compileAs.length; i++) {
                gulpAction(glob, targetDir, taskName, fileList, brandCode, brandFileNames, fileName, compileAs[i]);
            }
        } else {
            if(typeof compileAs === "string")
                fileName = compileAs;

            var notInWatchesStarted= (watchesStarted.indexOf(taskName) === -1);
            if(notInWatchesStarted)
                watchesStarted.push(taskName);

            var hasVariablesLess = (fileList.indexOf("variables.less") !== -1);

            return gulp.src(glob)
                .pipe(plumber({
                    errorHandler: notify.onError("Error: <%= error.message %>")
                }))
                // Prepend brand specific variables if file exists
                .pipe(gulpIf(hasVariablesLess, insert.prepend("@import 'variables.less';")))
                .pipe(
                    gulpIf(
                        fileList.indexOf(brandFileNames.variables) !== -1,
                        insert.prepend("@import '" + brandFileNames.variables + "';\r\n")
                    )
                )
                // Prepend generic brand build file
                .pipe(insert.prepend("@import '../../build/brand/" + brandCode + "/build.less';\r\n"))
                // Append brand specific theme less if file exists
                .pipe(
                    gulpIf(
                        fileList.indexOf(brandFileNames.theme) !== -1,
                        insert.append("\r\n@import '" + brandFileNames.theme + "';")
                    )
                )
                .pipe(
                    gulpIf(
                        !notInWatchesStarted,
                        watchLess(glob, null, function() {
                            gulpAction(glob, targetDir, taskName, fileList, brandCode, brandFileNames, fileName, compileAs);
                        })
                    )
                )
                .pipe(less({
                    paths: [gulp.pipelineConfig.build.dir + "/../**"]
                }))
                .pipe(concat(fileName + ".css"))
                .pipe(gulp.dest(targetDir))
                .pipe(notify({
                    title: taskName + " compiled",
                    message: fileName + " successfully compiled"
                }))
                .pipe(minifyCSS({
                    advanced: true,
                    aggressiveMerging: true
                }))
                .pipe(rename(fileName + ".min.css"))
                .pipe(gulp.dest(targetDir))
                .pipe(notify({
                    title: taskName + " minified",
                    message: fileName + " successfully minified"
                }))
                .pipe(sakugawa({
                    maxSelectors: 4000,
                    suffix: "."
                }))
                .pipe(gulp.dest(path.join(targetDir, "ie")))
                .pipe(notify({
                    title: taskName + " 4095 split for IE",
                    message: fileName + " successfully split up for IE (4095)"
                }));
        }
    };

    for(var bundle in bundles.collection) {
        if(bundle !== "core") {
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
    }

    gulp.task("less", lessTasks);
};

module.exports = LessTasks;