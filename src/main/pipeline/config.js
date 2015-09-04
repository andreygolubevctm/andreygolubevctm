"use strict";

var rootDir = __dirname;

module.exports = {
    pipeline: {
        dir: rootDir
    },
    tasks: {
        dir: rootDir + "/tasks",
        entryPoint: "gulpfile.js"
    },
    build: {
        dir: rootDir + "/../webapp/bundles/build"
    },
    brand: {
        dir: rootDir + "/../webapp/brand"
    },
    bundles: {
        dir: rootDir + "/../webapp/bundles",
        entryPoint: "bundle.json"
    },
    bootstrap: {
        dir: rootDir + "/../webapp/assets/libraries/bootstrap"
    },
    target: {
        dir: rootDir + "/../webapp/assets"
    }
};