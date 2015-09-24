var minifyCSS = require("gulp-minify-css"),
    intercept = require("gulp-intercept"),
    cached = require("gulp-cached"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    rename = require("gulp-rename"),
    path = require("path");

module.exports = function(gulp, filePath, brandCode, bundle) {
    return gulp.src(filePath)
        .pipe(plumber({
            errorHandler: notify.onError("Error: <%= error.message %>")
        }))
        .pipe(minifyCSS({
            advanced: true,
            aggressiveMerging: true,
            compatibility: "ie8"
        }))
        .pipe(intercept(function(file){
            file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");
            return file;
        }))
        .pipe(rename(function(renameFile) {
            renameFile.dirname = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");
            renameFile.extname = ".min.css";
        }))
        .pipe(gulp.dest(function(file){
            return file.targetDir;
        }))
        .pipe(notify("Minified: " + brandCode + " " + bundle + " CSS"))
        .pipe(intercept(function(file) {
            require("./bless")(gulp, file.path, brandCode, bundle);
            return file;
        }));
};