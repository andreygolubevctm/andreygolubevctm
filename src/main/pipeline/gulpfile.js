/**
 * Meerkat Asset Pipeline
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var fs = require("fs"),
    gulp = require("gulp");

// Inject our config into the gulp object so that
// we can use it easily in our bundles
gulp.pipelineConfig = require("./config");

var BundlesHelper = require("./helpers/bundlesHelper");

var bundles = new BundlesHelper(gulp.pipelineConfig),
    tasks = {};

// Find our bundles and read their bundle.json configurations
fs.readdirSync(gulp.pipelineConfig.bundles.dir)
    .forEach(function(folder) {
        var bundleJSONPath = [
                gulp.pipelineConfig.bundles.dir,
                folder,
                gulp.pipelineConfig.bundles.entryPoint
            ].join("/");

        if(fs.existsSync(bundleJSONPath)) {
            var bundleJSON = fs.readFileSync(bundleJSONPath, "utf8");
            bundles.addBundle(folder, bundleJSON);
        }
    });

// Load in our tasks
fs.readdirSync(gulp.pipelineConfig.tasks.dir)
    .forEach(function(folder) {
        var entryPoint = [
                gulp.pipelineConfig.tasks.dir,
                folder,
                gulp.pipelineConfig.tasks.entryPoint
            ].join("/");

        tasks[folder] = require(entryPoint)(gulp, bundles);
    });

gulp.task("default", Object.keys(tasks));