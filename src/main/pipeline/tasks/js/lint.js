var path = require("path"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    cached = require("gulp-cached"),
    stylish = require("jshint-stylish"),
    intercept = require("gulp-intercept"),
    jshint = require("gulp-jshint");

module.exports = function(gulp, filePath) {

    if(filePath.length == 1 && filePath[0].indexOf('plugins') != -1) {
        return false;
    }
    return gulp.src(filePath)
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