/**
 * Build Less Tasks
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

function BuildLessTasks(gulp, bundles) {

    gulp.task("build_less", function() {
        console.log("build less", bundles);
    });

};

module.exports = BuildLessTasks;