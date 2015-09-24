var minifyCSS = require("gulp-minify-css"),
    bless = require('gulp-bless'),
    intercept = require("gulp-intercept"),
    cached = require("gulp-cached"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    rename = require("gulp-rename"),
    path = require("path"),
    fs = require("fs");

module.exports = function(gulp, filePath, brandCode, bundle) {
    return gulp.src(filePath)
        .pipe(plumber({
            errorHandler: notify.onError("Error: <%= error.message %>")
        }))
        .pipe(cached("splitcss"))
        .pipe(minifyCSS({
            advanced: true,
            aggressiveMerging: true,
            compatibility: "ie8"
        }))
        .pipe(rename(function(renameFile){
            renameFile.basename = renameFile.basename + "-blessed";
            renameFile.dirname = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");
        }))
        .pipe(bless())
        .pipe(intercept(function(file) {
            file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");
            return file;
        }))
        .pipe(gulp.dest(function(file){
            return file.targetDir;
        }))
        .pipe(notify("4095 split: " + brandCode + " " + bundle + " CSS"));
};