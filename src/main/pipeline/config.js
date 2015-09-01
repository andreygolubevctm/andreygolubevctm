"use strict";

module.exports = {
    pipeline: {
        dir: __dirname
    },
    tasks: {
        dir: __dirname + "/tasks",
        entryPoint: "gulpfile.js"
    },
    brandFiles: {
        dir: __dirname + "/../webapp/brand"
    },
    bundles: {
        dir: __dirname + "/../webapp/bundles",
        entryPoint: "bundle.json"
    },
    bootstrap: {
        dir: __dirname + "/../webapp/framework/bootstrap"
    },
    target: {
        dir: __dirname + "/../webapp/assets"
    }
};