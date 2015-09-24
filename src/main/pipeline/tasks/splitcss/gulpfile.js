/**
 * Splitcss tasks
 * Splits CSS after it is compiled
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
var minifyCSS = require("gulp-minify-css"),
    sakugawa = require('gulp-sakugawa'),
    intercept = require("gulp-intercept"),
    cached = require("gulp-cached"),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify"),
    rename = require("gulp-rename"),
    path = require("path"),
    fs = require("fs"),
    mkdirp = require("mkdirp");

var fileHelper = require("./../../helpers/fileHelper")

function SplitcssTasks(gulp) {
    var glob = path.join(gulp.pipelineConfig.target.dir, "brand", "*", "css"),
        globArray = [path.join(glob, "*.css"), path.join("!" + glob, "*.min.*")];

    var addExtraFileInfo = function(file) {
        var replaceDir = path.normalize(path.join(gulp.pipelineConfig.target.dir, "brand")),
            reducedFilePath = file.path.replace(replaceDir, ""),
        // Reduce the array to brand code and file name
            splitFilePath = reducedFilePath.split(/(\\|\/)/).filter(function(segment) {
                return (segment && !segment.match(/(\\|\/)/) && segment !== "css");
            });

        file.brandCode = splitFilePath[0];
        file.bundle = splitFilePath[1].replace(".css", "");
        file.targetDir = path.join(gulp.pipelineConfig.target.dir, "brand", file.brandCode, "css");
        file.includesFolder = path.join(gulp.pipelineConfig.target.dir, "includes", "styles", file.brandCode);

        return file;
    };

    var revDate = + new Date();

    // Required task name. Gets auto executed by the main gulpfile.
    gulp.task("splitcss", []);

    gulp.watch(globArray, function() {
        gulp.src(globArray)
            .pipe(plumber({
                errorHandler: notify.onError("Error: <%= error.message %>")
            }))
            .pipe(cached("splitcss"))
            .pipe(intercept(function(file) {
                var file = addExtraFileInfo(file);

                mkdirp.sync(file.includesFolder);
                fs.writeFileSync(path.join(file.includesFolder, file.bundle + gulp.pipelineConfig.target.inc.extension), "");

                return file;
            }))
            .pipe(sakugawa({
                maxSelectors: 4090,
                suffix: "."
            }))
            .pipe(minifyCSS({
                advanced: true,
                aggressiveMerging: true,
                compatibility: "ie8"
            }))
            .pipe(intercept(function(file){
                var file = addExtraFileInfo(file);

                var tempPath = file.path,
                    appendContent = "<link rel=\"stylesheet\" type=\"text\/css\" href=\"" + tempPath.slice(tempPath.indexOf("assets"), tempPath.length).replace(/\\/g, "/") + "?rev=" + revDate + "\" media=\"all\" />";

                fileHelper.appendToFile(file.includesFolder, file.bundle.split(".")[0] + gulp.pipelineConfig.target.inc.extension, appendContent);

                return file;
            }))
            .pipe(rename(function(renameFile) {
                renameFile.dirname = path.join(gulp.pipelineConfig.target.dir, "brand", renameFile.dirname);
                renameFile.extname = ".min.css";
            }))
            .pipe(gulp.dest(function(file){
                return file.targetDir;
            }))
            .pipe(notify("4095 split: <%= file.brandCode %> <%= file.bundle %> CSS"))
    });
}

module.exports = SplitcssTasks;