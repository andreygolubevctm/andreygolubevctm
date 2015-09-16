/**
 * IE4095 tasks
 * Splits up CSS for IE to help with the 4095 selector issue
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
var fs = require("fs"),
    path = require("path"),
    sakugawa = require('gulp-sakugawa'),
    plumber = require("gulp-plumber"),
    mkdirp = require("mkdirp"),
    intercept = require("gulp-intercept"),
    notify = require("gulp-notify");

var fileHelper = require("./../../helpers/fileHelper");

function IE4095Tasks(gulp) {
    var bundles = gulp.bundles,
        config = gulp.pipelineConfig,
        brands = bundles.getBrandCodes().filter(function(brand){
            return brand !== "generic";
        });

    var taskList = [],
        watchPaths = [];

    for(var i = 0; i < brands.length; i++) {
        var brand = brands[i];

        (function (brand) {
            var targetDir = path.join(config.target.dir, "brand", brand, "css"),
                glob = path.join(targetDir, "*.min.css");

            var taskName = "ie4095:" + brand;

            gulp.task(taskName, function() {
                var filePath = fileName = targetFolder = targetFile = "";

                return gulp.src(glob)
                    .pipe(plumber({
                        errorHandler: notify.onError("Error: <%= error.message %>")
                    }))
                    // Get the original file name and wipe its list of includes
                    .pipe(intercept(function(file){
                        filePath = file.path;
                        fileName = path.basename(file.path).replace(/\.[^/.]+$/, "");
                        targetFolder = path.dirname(filePath) + "\\inc";
                        targetFile = fileName + ".txt";

                        // Wipe the original target file
                        mkdirp.sync(targetFolder);
                        fs.writeFileSync(path.join(targetFolder, targetFile), "");

                        return file;
                    }))
                    .pipe(sakugawa({
                        maxSelectors: 4090,
                        suffix: "."
                    }))
                    // Append to the list of includes
                    .pipe(intercept(function(file){
                        var tempPath = file.path,
                            revDate = + new Date(),
                            appendContent = "<link rel=\"stylesheet\" href=\"" + path.normalize(tempPath.slice(tempPath.indexOf("assets"), tempPath.length)) + "?rev=" + revDate + "\" media=\"all\">";
                        fileHelper.appendToFile(targetFolder, targetFile, appendContent);
                        return file;
                    }))
                    .pipe(gulp.dest(targetDir))
                    .pipe(notify({
                        title: taskName + " " + brand + " 4095 split for IE",
                        message: "Successfully split up for IE (4095)"
                    }));
            });

            taskList.push(taskName);
            watchPaths.push(glob);
        })(brand);
    }

    // Required task name. Gets auto executed by the main gulpfile.
    gulp.task("ie4095", []);
    gulp.watch(watchPaths, taskList);
}

module.exports = IE4095Tasks;