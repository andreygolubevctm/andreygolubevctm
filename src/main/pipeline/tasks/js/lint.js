var path = require("path"),
    cached = require("gulp-cached"),
    stylish = require("jshint-stylish"),
    jshint = require("gulp-jshint");

module.exports = function(gulp, fileArray) {
    // Remove plugins from lintable fileArray
    fileArray = fileArray.filter(function(file) {
        return file.indexOf("plugins") === -1;
    });

    return gulp.src(fileArray)
        .pipe(gulp.globalPlugins.plumber({
            errorHandler: gulp.globalPlugins.notify.onError("Error: <%= error.message %>")
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