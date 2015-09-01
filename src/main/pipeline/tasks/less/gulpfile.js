/**
 * Build Less Tasks
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var less = require("gulp-less"),
    intercept = require("gulp-intercept"),
    concat = require('gulp-concat'),
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
                            brandCodeSrcPath = path.join(gulp.pipelineConfig.brand.dir, brandCode, "less", "framework.build." + brandCode + ".less"),
                            brandCodeBundleSrcPath = path.join(gulp.pipelineConfig.brand.dir, brandCode, "less", "framework.build." + bundle + "." + brandCode + ".less");

                        gulp.task(brandCodeTask, function () {
                            return gulp.src([
                                    brandCodeSrcPath,
                                    brandCodeBundleSrcPath
                                ])
                                .pipe(less({paths: [gulp.pipelineConfig.build.dir]}))
                                .pipe(concat(bundle + "." + brandCode + ".css"))
                                .pipe(gulp.dest(gulp.pipelineConfig.target.dir + "/css"));
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