/**
 * Bootstrap Tasks
 * Does bootstrap stuff
 * e.g.: `gulp bootstrap:build` will compile the bootstrap files
 *
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
var path = require("path"),
    concat = require("gulp-concat"),
    beautify = require("gulp-beautify"),
    uglify = require("gulp-uglify"),
    rename = require("gulp-rename");

function BootstrapTasks(gulp) {
    gulp.task("bootstrap:build", function() {
        var bootstrapJSFiles = gulp.pipelineConfig.bootstrap.jsModules;

        bootstrapJSFiles = bootstrapJSFiles.map(function(file) {
            return path.join(gulp.pipelineConfig.bootstrap.dir, "js", file + ".js");
        });

        var fileName = "bootstrap",
            targetDirectory = path.join(gulp.pipelineConfig.target.dir, "js", "libraries");

        gulp.src(bootstrapJSFiles)
            .pipe(gulp.globalPlugins.plumber({
                errorHandler: gulp.globalPlugins.notify.onError("Error: <%= error.message %>")
            }))
            .pipe(concat(fileName + ".min.js"))
            .pipe(uglify())
            .pipe(gulp.dest(targetDirectory))
            .pipe(gulp.globalPlugins.notify({
                title: "bootstrap:build minified",
                message: "bootstrap successfully minified"
            }))
            .pipe(rename(fileName + ".js"))
            .pipe(beautify())
            .pipe(gulp.dest(targetDirectory))
            .pipe(gulp.globalPlugins.notify({
                title: "bootstrap:build compiled",
                message: "bootstrap successfully compiled"
            }));
    });

    gulp.task("bootstrap", ["bootstrap:build"]);
}

module.exports = BootstrapTasks;