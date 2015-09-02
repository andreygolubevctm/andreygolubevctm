/**
 * Brand Tasks
 * Runs tasks for a given brand
 * e.g.: `gulp brand:ctm` will run all tasks related to the CTM brand
 *
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
function BrandTasks(gulp) {
    var bundles = gulp.bundles;

    var brandCodes = bundles.getBrandCodes();

    brandCodes.forEach(function(brandCode) {
        (function(brandCode){
            var brandBundles = bundles.getBrandCodeBundles(brandCode);

            brandBundles = brandBundles.map(function(bundle) {
                return "bundle:" + bundle;
            });

            gulp.task("brand:" + brandCode, brandBundles);
        })(brandCode);
    });

    gulp.task("brand", function() {});
}

module.exports = BrandTasks;