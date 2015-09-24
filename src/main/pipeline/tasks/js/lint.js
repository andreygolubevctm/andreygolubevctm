var path = require("path"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    cached = require("gulp-cached"),
    stylish = require("jshint-stylish"),
    jshint = require("gulp-jshint");

module.exports = function(gulp, filePath) {
    return gulp.src(filePath)
        .pipe(plumber({
            errorHandler: notify.onError("Error: <%= error.message %>")
        }))
        .pipe(jshint())
        .pipe(jshint.reporter(stylish))
        .pipe(jshint.reporter("fail"));
};