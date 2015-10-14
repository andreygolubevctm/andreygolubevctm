var minifyCSS = require("gulp-minify-css"),
    cached = require("gulp-cached"),
    path = require("path");

module.exports = function(gulp, filePath, brandCode, bundle, done) {
    return gulp.src(filePath)
        .pipe(gulp.globalPlugins.plumber({
            errorHandler: gulp.globalPlugins.notify.onError("Error: <%= error.message %>")
        }))
        // Options are listed at https://github.com/jakubpawlowicz/clean-css
        .pipe(minifyCSS({
            keepSpecialComments: 0,
            mediaMerging: true, //(default is true, just for clarity)
            advanced: true,
            aggressiveMerging: true,
            compatibility: "ie8"
        }))
        .pipe(gulp.globalPlugins.intercept(function(file){
            file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");
            return file;
        }))
        .pipe(gulp.globalPlugins.rename(function(renameFile) {
            renameFile.extname = ".min.css";
        }))
        .pipe(gulp.dest(function(file){
            return file.targetDir;
        }))
        .pipe(gulp.globalPlugins.debug({
            title: "Finished Minify CSS"
        }))
        // We do this to ensure that the file object is sent back
        .pipe(gulp.globalPlugins.intercept(function(file){
            return file;
        }));
};