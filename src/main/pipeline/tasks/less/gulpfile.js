/**
 * Build Less Tasks
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var less = require("gulp-less"),
    intercept = require("gulp-intercept"),
    concat = require("gulp-concat"),
    minifyCSS = require("gulp-minify-css"),
    rename = require("gulp-rename"),
    insert = require("gulp-insert"),
    path = require("path");

function LessTasks(gulp, bundles) {
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
                            return gulp.src([
                                    brandCodeBundleSrcPath
                                ])
                                .pipe(insert.prepend("@import '../../build/brand/" + brandCode + "/build.less';\r\n"))
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