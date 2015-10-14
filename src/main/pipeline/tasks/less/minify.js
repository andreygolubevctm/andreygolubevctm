var minifyCSS = require("gulp-minify-css"),
    intercept = require("gulp-intercept"),
    cached = require("gulp-cached"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    rename = require("gulp-rename"),
    path = require("path");

module.exports = function(gulp, filePath, brandCode, bundle, done) {
    return gulp.src(filePath)
        .pipe(plumber({
            errorHandler: notify.onError("Error: <%= error.message %>")
        }))
        // Options are listed at https://github.com/jakubpawlowicz/clean-css
        .pipe(minifyCSS({
            keepSpecialComments: 0,
            mediaMerging: true, //(default is true, just for clarity)
            advanced: true,
            aggressiveMerging: true,
            compatibility: "ie8"
        }))
        .pipe(intercept(function(file){
            file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");
            return file;
        }))
        .pipe(rename(function(renameFile) {
            renameFile.extname = ".min.css";
        }))
        .pipe(gulp.dest(function(file){
            return file.targetDir;
        }))
        .pipe(notify("Minified: " + brandCode + " " + bundle + " CSS"))
        // We do this to ensure that the file object is sent back
        .pipe(intercept(function(file){
            return file;
        }));
};