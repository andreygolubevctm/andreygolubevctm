/**
 * IE4095 tasks
 * Splits up CSS for IE to help with the 4095 selector issue
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
var path = require("path"),
    sakugawa = require('gulp-sakugawa'),
    plumber = require("gulp-plumber"),
    notify = require("gulp-notify");

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
                IEDir = path.join(targetDir, "ie"),
                glob = path.join(targetDir, "*.min.css");

            var taskName = "ie4095:" + brand;

            gulp.task(taskName, function() {
                return gulp.src(glob)
                    .pipe(plumber({
                        errorHandler: notify.onError("Error: <%= error.message %>")
                    }))
                    .pipe(sakugawa({
                        maxSelectors: 4090,
                        suffix: "."
                    }))
                    .pipe(gulp.dest(IEDir))
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