/**
 * Build Less Tasks
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
    intercept = require("gulp-intercept"),
    fs = require("fs"),
    path = require("path");

function LessTasks(gulp) {
    var bundles = gulp.bundles;

    var taskPrefix = "less:",
        lessTasks = [];

    for(var bundle in bundles.collection) {
        if(bundle !== "core") {
            (function (bundle) {
                var brandCodes = bundles.getBundleBrandCodes(bundle);

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
                                .pipe(gulpIf(fs.existsSync(path.join(gulp.pipelineConfig.bundles.dir, bundle, "less", brandVariablesFileName)), insert.prepend("@import '" + brandVariablesFileName + "';\r\n")))
                                // Prepend generic brand build file
                                .pipe(insert.prepend("@import '../../build/brand/" + brandCode + "/build.less';\r\n"))
                                // Append brand specific theme less if file exists
                                .pipe(gulpIf(fs.existsSync(path.join(gulp.pipelineConfig.bundles.dir, bundle, "less", brandThemeFileName)), insert.append("\r\n@import '" + brandThemeFileName + "'")))
                                .pipe(intercept(function(file){
                                    console.log(file.contents.toString());
                                }))
                                .pipe(watchLess(brandCodeBundleSrcPath, null, function(events, done){
                                    gulp.start(brandCodeTask, done);
                                }))
                                .pipe(less({
                                    paths: [
                                        gulp.pipelineConfig.build.dir + "/../**"
                                    ]
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

                        lessTasks.push(brandCodeTask);
                    })(brandCode);
                }
            })(bundle);
        }
    }

    gulp.task("less", lessTasks);
};

module.exports = LessTasks;