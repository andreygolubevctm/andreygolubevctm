"use strict";

var rootDir = __dirname;

module.exports = {
    pipeline: {
        dir: rootDir
    },
    testLocation: {
        dir:  "unit/",
    },
    webapp: {
        dir:  "../../../main/webapp/",
    },
    base : {
        dir: "../../../main/webapp/bundles/"
    },
    index: {
        dir: rootDir + "/../frontend/qunit/",
        entryPoint: "index.html",
        template: "index.template",
    },
    test : {
        dir: rootDir + "/../frontend/qunit/unit/"
    },
    testList : {
        dir: rootDir + "/../frontend/qunit/",
        entryPoint: "testList.json",

    }
};