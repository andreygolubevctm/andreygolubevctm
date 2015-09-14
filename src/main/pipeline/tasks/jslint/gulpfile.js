/**
 * JSLint tasks
 * Lints JS
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
var path = require("path"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    cached = require("gulp-cached"),
    stylish = require("jshint-stylish"),
    jshint = require("gulp-jshint");

function JSLintTasks(gulp) {
    var glob = path.join(gulp.pipelineConfig.bundles.dir, "**", "js"),
        globArray = [glob + "/*.js", "!" + glob + "/*.min.js"];

    gulp.task("lint:js", function() {
        gulp.src(globArray)
            .pipe(plumber({
                errorHandler: notify.onError("Error: <%= error.message %>")
            }))
            .pipe(cached())
            .pipe(jshint())
            .pipe(jshint.reporter(stylish))
            .pipe(jshint.reporter("fail"));
    });

    gulp.watch(globArray, ["lint:js"]);

    gulp.task("jslint", []);
}

module.exports = JSLintTasks;