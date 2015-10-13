"use strict";

var path = require("path");

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
        dir: rootDir + "/../webapp/assets/libraries/bootstrap",
        jsModules: [
            "transition",
            "button",
            "collapse",
            "dropdown",
            "modal",
            "tab",
            "affix"
        ]
    },
    target: {
        dir: rootDir + "/../webapp/assets",
        inc: {
            extension: ".html"
        }
    }
};