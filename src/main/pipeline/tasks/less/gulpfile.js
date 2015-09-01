/**
 * Build Less Tasks
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var less = require("gulp-less");

function LessTasks(gulp, bundles) {
    var taskPrefix = "less:",
        lessTasks = [];

    var coreSrcPath = [
            gulp.pipelineConfig.bundles.dir,
            "core/less/*.less"
        ].join("/"),
        bootstrapSrcPath = [
            gulp.pipelineConfig.bootstrap.dir,
            "less/*.less"
        ].join("/");

    for(var bundle in bundles.collection) {
        if(bundle !== "core") {
            (function (bundle) {
                var brandCodes = bundles.getBundleBrandCodes(bundle);

                var bundleSrcPath = [
                    gulp.pipelineConfig.bundles.dir,
                    bundle,
                    "less/*.less"
                ].join("/");

                for (var i = 0; i < brandCodes.length; i++) {
                    var brandCode = brandCodes[i],
                        brandCodeTask = taskPrefix + bundle + ":" + brandCode,
                        brandSrcPath = [
                            gulp.pipelineConfig.brandFiles.dir,
                            brandCode,
                            "less",
                            "framework.build." + brandCode + "." + bundle + ".less"
                        ].join("/");

                    // TODO: Remove and replace if necessary
                    var buildSrcPath = [
                            gulp.pipelineConfig.bootstrap.dir,
                            "..",
                            "build/*.less",
                        ].join("/");

                    gulp.task(brandCodeTask, function () {
                        return gulp.src([brandSrcPath, buildSrcPath, bootstrapSrcPath, coreSrcPath, bundleSrcPath])
                            .pipe(less())
                            .pipe(gulp.dest(gulp.pipelineConfig.target.dir + "/css"));
                    });

                    lessTasks.push(brandCodeTask);
                }
            })(bundle);
        }
    }

    gulp.task("less", lessTasks);

};

module.exports = LessTasks;