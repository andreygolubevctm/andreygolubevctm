/**
 * Minifycss tasks
 * Minifies CSS after it is compiled
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
var minifyCSS = require("gulp-minify-css"),
    intercept = require("gulp-intercept"),
    cached = require("gulp-cached"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    rename = require("gulp-rename"),
    path = require("path"),
    fs = require("fs");

function MinifycssTasks(gulp) {
    var glob = path.join(gulp.pipelineConfig.target.dir, "brand", "*", "css"),
        globArray = [path.join(glob, "*.css"), path.join("!" + glob, "*.min.*")];

    // Required task name. Gets auto executed by the main gulpfile.
    gulp.task("minifycss", []);

    gulp.watch(globArray, function() {
        gulp.src(globArray)
            .pipe(plumber({
                errorHandler: notify.onError("Error: <%= error.message %>")
            }))
            .pipe(cached("minifycss"))
            .pipe(minifyCSS({
                advanced: true,
                aggressiveMerging: true,
                compatibility: "ie8"
            }))
            .pipe(intercept(function(file){
                var replaceDir = path.normalize(path.join(gulp.pipelineConfig.target.dir, "brand")),
                    reducedFilePath = file.path.replace(replaceDir, ""),
                    // Reduce the array to brand code and file name
                    splitFilePath = reducedFilePath.split(/(\\|\/)/).filter(function(segment) {
                        return (segment && !segment.match(/(\\|\/)/) && segment !== "css");
                    });

                file.brandCode = splitFilePath[0];
                file.bundle = splitFilePath[1].replace(".css", "");
                file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", file.brandCode, "css");

                return file;
            }))
            .pipe(rename(function(renameFile) {
                renameFile.dirname = path.join(gulp.pipelineConfig.target.dir, "brand", renameFile.dirname);
                renameFile.extname = ".min.css";
            }))
            .pipe(gulp.dest(function(file){
                return file.targetDir;
            }))
            .pipe(notify("Minified: <%= file.brandCode %> <%= file.bundle %> CSS"))
    });
}

module.exports = MinifycssTasks;