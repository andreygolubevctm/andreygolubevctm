"use strict";

var path = require("path");

var rootDir = __dirname;

var Config = {
    pipeline: {
        dir: rootDir
    },
    tasks: {
        dir: path.normalize(rootDir + "/tasks"),
        entryPoint: "gulpfile.js"
    },
    build: {
        dir: path.normalize(rootDir + "/../webapp/bundles/build")
    },
    brand: {
        dir: path.normalize(rootDir + "/../webapp/brand")
    },
    bundles: {
        dir: path.normalize(rootDir + "/../webapp/bundles"),
        entryPoint: "bundle.json"
    },
    bootstrap: {
        dir: path.normalize(rootDir + "/../webapp/assets/libraries/bootstrap"),
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
    sprite: {
        source: {
            dir: path.join(rootDir, "..", "webapp", "assets", "graphics", "logos")
        }
    },
    target: {
        dir: path.normalize(rootDir + "/../webapp/assets"),
        inc: {
            extension: ".html"
        }
    }
};

module.exports = Config;
