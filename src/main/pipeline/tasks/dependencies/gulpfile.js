/**
 * Dependencies tasks
 * Lists dependencies for the specified bundle
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */

function DependenciesTasks(gulp) {
    var bundles = gulp.bundles,
        bundlesCollection = bundles.collection;

    for(var bundle in bundlesCollection) {
        (function (bundle) {
            gulp.task("dependencies:" + bundle, function() {
                var dependencies = bundles
                    .getDependencies(bundle)
                    .map(function(dependency) {
                        return "- " + dependency;
                    }).join("\r\n");

                console.log([
                    "",
                    bundle + " dependencies:",
                    dependencies,
                    ""
                ].join("\r\n"))
            });
        })(bundle);
    }

    // Required task name. Gets auto executed by the main gulpfile.
    gulp.task("dependencies", []);
}

module.exports = DependenciesTasks;