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
    path = require("path");

function LessTasks(gulp, bundles) {
    var taskPrefix = "less:",
        lessTasks = [];

    var targetDir = gulp.pipelineConfig.target.dir + "/css";

    for(var bundle in bundles.collection) {
        if(bundle !== "core") {
            (function (bundle) {
                var brandCodes = bundles.getBundleBrandCodes(bundle);

                for (var i = 0; i < brandCodes.length; i++) {
                    var brandCode = brandCodes[i];

                    (function(brandCode) {
                        var brandCodeTask = taskPrefix + bundle + ":" + brandCode,
                            brandCodeSrcPath = path.join(gulp.pipelineConfig.brand.dir, brandCode, "less", "framework.build." + brandCode + ".less"),
                            brandCodeBundleSrcPath = path.join(gulp.pipelineConfig.brand.dir, brandCode, "less", "framework.build." + bundle + "." + brandCode + ".less");

                        gulp.task(brandCodeTask, function () {
                            var fileName = bundle + "." + brandCode;

                            return gulp.src([
                                    brandCodeSrcPath,
                                    brandCodeBundleSrcPath
                                ])
                                .pipe(less({
                                    paths: [gulp.pipelineConfig.build.dir]
                                }))
                                .pipe(concat(fileName + ".css"))
                                .pipe(gulp.dest(targetDir))
                                .pipe(minifyCSS({
                                    advanced: true,
                                    aggressiveMerging: true
                                }))
                                .pipe(rename(fileName + ".min.css"))
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