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
            var lessFiles = bundles.getBundleFiles(bundle, "less", false, true),
                jsFiles = bundles.getBundleFiles(bundle, "js", false);

            var bundleTasks = [];

            if(lessFiles.length)
                bundleTasks.push("less:" + bundle);

            if(jsFiles.length)
                bundleTasks.push("js:" + bundle);

            if(bundleTasks.length)
                gulp.task("bundle:" + bundle, bundleTasks);
        })(bundle);
    };

    gulp.task("bundle", function() {});
}

module.exports = BundleTasks;