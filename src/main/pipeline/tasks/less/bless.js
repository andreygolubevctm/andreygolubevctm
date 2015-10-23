var minifyCSS = require("gulp-minify-css"),
    cached = require("gulp-cached"),
    sakugawa = require("gulp-sakugawa"),
    path = require("path"),
    fs = require("fs"),
    mkdirp = require("mkdirp");

var fileHelper = require("./../../helpers/fileHelper");

var revDate = + new Date();

module.exports = function(gulp, filePath, brandCode, bundle, done) {
    var addExtraFileInfo = function(file) {
        var replaceDir = path.normalize(path.join(gulp.pipelineConfig.target.dir, "brand")),
            reducedFilePath = file.path.replace(replaceDir, ""),
             // Reduce the array to brand code and file name
            splitFilePath = reducedFilePath.split(/(\\|\/)/).filter(function(segment) {
                return (segment && !segment.match(/(\\|\/)/) && segment !== "css");
            });

        file.brandCode = splitFilePath[0];
        file.bundle = splitFilePath[1].replace(".css", "");
        file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");
        file.includesFolder = path.join(gulp.pipelineConfig.target.dir, "includes", "styles", brandCode);

        return file;
    };

    return gulp.src(filePath)
        .pipe(gulp.globalPlugins.plumber({
            errorHandler: gulp.globalPlugins.notify.onError("Error: <%= error.message %>")
        }))
        .pipe(gulp.globalPlugins.intercept(function(file) {
            var file = addExtraFileInfo(file);

            mkdirp.sync(file.includesFolder);
            fs.writeFileSync(path.join(file.includesFolder, bundle + gulp.pipelineConfig.target.inc.extension), "");

            return file;
        }))
        .pipe(sakugawa({
            maxSelectors: 4090,
            suffix: "."
        }))
        .pipe(gulp.globalPlugins.intercept(function(file) {
            var file = addExtraFileInfo(file);

            file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", brandCode, "css");

            var tempPath = file.path,
                appendContent = "<link rel=\"stylesheet\" type=\"text\/css\" href=\"" + tempPath.slice(tempPath.indexOf("assets"), tempPath.length).replace(/\\/g, "/").replace(".css", ".min.css") + "?rev=" + revDate + "\" media=\"all\" />";

            fileHelper.appendToFile(file.includesFolder, file.bundle.split(".")[0] + gulp.pipelineConfig.target.inc.extension, appendContent);

            return file;
        }))
        .pipe(gulp.globalPlugins.rename(function(renameFile) {
            renameFile.extname = ".min.css";
        }))
        // Sakugawa beautifies the CSS for some reason so we do this to keep file sizes down
        // Options are listed at https://github.com/jakubpawlowicz/clean-css
        .pipe(minifyCSS({
            keepSpecialComments: 0,
            mediaMerging: true, //(default is true, just for clarity)
            advanced: true,
            aggressiveMerging: true,
            compatibility: "ie8"
        }))
        .pipe(gulp.dest(function(file){
            return file.targetDir;
        }))
        .pipe(gulp.globalPlugins.debug({
            title: "Finished Bless CSS"
        }))
        // We do this to ensure that the file object is sent back
        .pipe(gulp.globalPlugins.intercept(function(file) {
            return file;
        }));
};