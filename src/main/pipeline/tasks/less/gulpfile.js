/**
 * LESS Tasks
 * Compiles LESS in bundles into CSS with minified versions for specified brand codes
 * e.g.: `gulp less:health` will compile health's LESS for all brand codes
 * e.g.: `gulp less:health:ctm` will compile health's LESS for the CTM brand code
 *
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var less = require("gulp-less"),
    concat = require("gulp-concat"),
    minifyCSS = require("gulp-minify-css"),
    rename = require("gulp-rename"),
    insert = require("gulp-insert"),
    watchLess = require("gulp-watch-less"),
    gulpIf = require("gulp-if"),
    fs = require("fs"),
    path = require("path");

// TODO: Add .map files

function LessTasks(gulp) {
    var bundles = gulp.bundles;

    var taskPrefix = "less:",
        lessTasks = [];

    for(var bundle in bundles.collection) {
        if(bundle !== "core") {
            (function (bundle) {
                var brandCodes = bundles.getBundleBrandCodes(bundle);

                var fileList = bundles.getBundleFiles(bundle, "less", false);

                var bundleLessTasks = [];

                for (var i = 0; i < brandCodes.length; i++) {
                    var brandCode = brandCodes[i];

                    (function(brandCode) {
                        var brandCodeTask = taskPrefix + bundle + ":" + brandCode,
                            brandCodeBundleSrcPath = path.join(gulp.pipelineConfig.bundles.dir, bundle, "less", "build.less");

                        var targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");

                        gulp.task(brandCodeTask, function () {
                            var brandVariablesFileName = "variables." + brandCode + ".less",
                                brandThemeFileName = "theme." + brandCode + ".less";

                            return gulp.src(brandCodeBundleSrcPath)
                                // Prepend brand specific variables if file exists
                                .pipe(
                                    gulpIf(
                                        fileList.indexOf(brandVariablesFileName) !== -1,
                                        insert.prepend("@import '" + brandVariablesFileName + "';\r\n")
                                    )
                                )
                                // Prepend generic brand build file
                                .pipe(insert.prepend("@import '../../build/brand/" + brandCode + "/build.less';\r\n"))
                                // Append brand specific theme less if file exists
                                .pipe(
                                    gulpIf(
                                        fileList.indexOf(brandThemeFileName) !== -1,
                                        insert.append("\r\n@import '" + brandThemeFileName + "';")
                                    )
                                )
                                .pipe(watchLess(brandCodeBundleSrcPath, null, function(events, done){
                                    gulp.start(brandCodeTask, done);
                                }))
                                .pipe(less({
                                    paths: [gulp.pipelineConfig.build.dir + "/../**"]
                                }))
                                .pipe(concat(bundle + ".css"))
                                .pipe(gulp.dest(targetDir))
                                .pipe(minifyCSS({
                                    advanced: true,
                                    aggressiveMerging: true
                                }))
                                .pipe(rename(bundle + ".min.css"))
                                .pipe(gulp.dest(targetDir));
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