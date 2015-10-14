/**
 * Bundle Tasks
 * Helper task for grouping tasks by bundle
 * e.g.: `gulp bundle:health` will run all health related bundle tasks
 *
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
function BundleTasks(gulp) {
    var bundles = gulp.bundles,
        bundlesCollection = bundles.collection;

    for(var bundle in bundlesCollection) {
        (function(bundle) {
            var lessFiles = bundles.getWatchableBundlesFilePaths(bundle, "less"),
                jsFiles = bundles.getWatchableBundlesFilePaths(bundle, "js");

            var bundleTasks = [];

            bundleTasks.push("dependencies:" + bundle);

            if(lessFiles.length)
                bundleTasks.push("less:" + bundle);

            if(jsFiles.length)
                bundleTasks.push("js:" + bundle);

            if(bundleTasks.length)
                gulp.task("bundle:" + bundle, bundleTasks);
        })(bundle);
    }

    gulp.task("bundle", function() {});
}

module.exports = BundleTasks;