/**
 * Meerkat Asset Pipeline
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

// Important!
// The watch method used by gulp plugins doesn't seem to appreciate having so many active listeners
// To get around it, we set the default number of listeners to be greater than the default (10)
require('events').EventEmitter.prototype._maxListeners = 30;

var fs = require("fs"),
    gulp = require("gulp"),
    path = require("path");

var BundlesHelper = require("./helpers/bundlesHelper");

console.log("Initialising gulp tasks... Give it a moment, yo!");

// TODO: Do maven integration
// TODO: Create task for build server? Or prevent watch on build server etc
// TODO: Create task for creating new bundles
// TODO: Create task for compiling plugins
// TODO: Create task for sprites (see Mark)

// Inject our config into the gulp object so that
// we can use it easily in our bundles
gulp.pipelineConfig = require("./config");
gulp.bundles = new BundlesHelper(gulp.pipelineConfig);

var tasks = {};

// Load in our tasks
fs.readdirSync(gulp.pipelineConfig.tasks.dir)
    .forEach(function(folder) {
        var entryPoint = path.join(gulp.pipelineConfig.tasks.dir, folder, gulp.pipelineConfig.tasks.entryPoint);
        tasks[folder] = require(entryPoint)(gulp);
    });

gulp.task("default", Object.keys(tasks));