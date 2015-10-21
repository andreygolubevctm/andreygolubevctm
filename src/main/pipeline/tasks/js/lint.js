var path = require("path"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    cached = require("gulp-cached"),
    stylish = require("jshint-stylish"),
    intercept = require("gulp-intercept"),
    jshint = require("gulp-jshint");

module.exports = function(gulp, fileArray) {
    // Remove plugins from lintable fileArray
    fileArray = fileArray.filter(function(file) {
        return file.indexOf("plugins") === -1;
    });

    return gulp.src(fileArray)
        .pipe(plumber({
            errorHandler: notify.onError("Error: <%= error.message %>")
        }))
        .pipe(cached())
        .pipe(jshint({
                "boss"     : true,
                "browser"  : true,
                "curly"    : false,
                "debug"    : true,
                "devel"    : true,
                "eqeqeq"   : false,
                "eqnull"   : true,
                "expr"     : true,
                "validthis": true,
                "laxbreak" : true,
                "sub"      : true
            }
        ))
        .pipe(jshint.reporter(stylish))
        .pipe(jshint.reporter("fail"));
};