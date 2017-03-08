/**
 * Meerkat Asset Pipeline
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

var argv = require("yargs").argv;

if (!!argv.disableNotify) {
    process.env["DISABLE_NOTIFIER"] = true;
}

process.env["DISABLE_MINIFICATION"] = !!argv.fast;
var fs = require("graceful-fs-extra");

// Important!
// The watch method used by gulp plugins doesn't seem to appreciate having so many active listeners
// To get around it, we set the default number of listeners to be greater than the default (10)
require('events').EventEmitter.prototype._maxListeners = 200;

var gulp = require("gulp"),
    path = require("path");

var tasks = {};

var BundlesHelper = require("./helpers/bundlesHelper");

// Inject our config into the gulp object so that
// we can use it easily in our bundles
gulp.pipelineConfig = require("./config");
gulp.bundles = new BundlesHelper(gulp.pipelineConfig);

// Sometimes plugins need to access environment variables so we use this to ensure that the single plugin instance has received that value
gulp.globalPlugins = {
    notify: require("gulp-notify"),
    debug: require("gulp-debug"),
    intercept: require("gulp-intercept"),
    plumber: require("gulp-plumber"),
    rename: require("gulp-rename")
};

// Meerkat Ascii. Do not remove or Sergei gets it.
console.log("\r\nCompare the Market");
console.log("Meerkat Pipeline\r\n");
console.log("   ____                                       _____ _            __  __            _        _   \r\n  / ___|___  _ __ ___  _ __   __ _ _ __ ___  |_   _| |__   ___  |  \\/  | __ _ _ __| | _____| |_ \r\n | |   / _ \\| '_ ` _ \\| '_ \\ / _` | '__/ _ \\   | | | '_ \\ / _ \\ | |\\/| |/ _` | '__| |/ / _ \\ __|\r\n | |__| (_) | | | | | | |_) | (_| | | |  __/   | | | | | |  __/ | |  | | (_| | |  |   <  __/ |_ \r\n  \\____\\___/|_| |_| |_| .__/ \\__,_|_|  \\___|   |_| |_| |_|\\___| |_|  |_|\\__,_|_|  |_|\\_\\___|\\__|\r\n                      |_|                                                                       \r\n");
console.log("Initialising gulp tasks... Give it a moment, yo!\r\n");

gulp.task("clean:noexit", function () {
    // We delete file contents instead of folders in case gulp tries writing to a folder and permissions haven't been set yet by the OS
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "js", "bundles", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "js", "bundles", "maps", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "js", "bundles", "plugins", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "js", "bundles", "shared", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "js", "libraries", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "brand", "*", "css", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "brand", "*", "css", "maps", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "includes", "js", "*.*"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "includes", "styles", "*", "*.*"));
});

gulp.task("clean", ["clean:noexit"], function () {
    process.exit();
});

// Load in our tasks
fs.readdirSync(gulp.pipelineConfig.tasks.dir)
    .forEach(function (folder) {
        var entryPoint = path.join(gulp.pipelineConfig.tasks.dir, folder, gulp.pipelineConfig.tasks.entryPoint);
        tasks[folder] = require(entryPoint)(gulp);
    });

gulp.task("default", Object.keys(tasks));

gulp.task("build", ["clean:noexit", "default"], function () {
    // We don't need watchers so we can just exit here.
    // Don't delete the beautiful Sergei.
    console.log("   ____                                       _____ _            __  __            _        _   \r\n  / ___|___  _ __ ___  _ __   __ _ _ __ ___  |_   _| |__   ___  |  \\/  | __ _ _ __| | _____| |_ \r\n | |   / _ \\| '_ ` _ \\| '_ \\ / _` | '__/ _ \\   | | | '_ \\ / _ \\ | |\\/| |/ _` | '__| |/ / _ \\ __|\r\n | |__| (_) | | | | | | |_) | (_| | | |  __/   | | | | | |  __/ | |  | | (_| | |  |   <  __/ |_ \r\n  \\____\\___/|_| |_| |_| .__/ \\__,_|_|  \\___|   |_| |_| |_|\\___| |_|  |_|\\__,_|_|  |_|\\_\\___|\\__|\r\n                      |_|                                                                       \r\n");
    process.exit();
});