"use strict";

var path = require("path");

var argv = require("yargs").argv;

var rootDir = __dirname;

var fs = require("graceful-fs-extra"),
    parseXML = require("xml2js").parseString;

var targetFolderName = "";
if(argv.targetFolder) {
    targetFolderName = argv.targetFolder;
} else {
    var JavaConfigXML = fs.readFileSync(rootDir + "/../../../pom.xml").toString(),
        JavaConfig;

    parseXML(JavaConfigXML, function (err, result) {
        JavaConfig = result;
    });

    targetFolderName = JavaConfig.project.artifactId[0] + "-" + JavaConfig.project.version[0]
}

var Config = {
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
        dir: rootDir + "/../webapp/brand",
        all: ['ctm', 'choo', 'wfdd', 'bddd'/*, 'amcl','guar'*/]
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
    sprite: {
        source: {
            dir: path.join(rootDir, "..", "webapp", "assets", "graphics", "logos")
        }
    },
    target: {
        dir: rootDir + "/../../../target/" + targetFolderName + "/assets",
        inc: {
            extension: ".html"
        }
    }
};

module.exports = Config;
