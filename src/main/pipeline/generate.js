var argv = require("yargs").argv,
    path = require("path"),
    fs = require("fs"),
    beautify = require('js-beautify').js_beautify,
    mkdirp = require("mkdirp"),
    prompt = require("prompt");

var config = require("./config"),
    fileHelper = require("./helpers/fileHelper"),
    action = argv._[0];

function stringifyJSON(jsonObj) {
    return JSON.stringify(jsonObj, null, 4);
}

function capitaliseFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function beautifyJS(JS) {
    return beautify(JS, {
       indent_size: 4
    });
}

function generateTaskJS(task, description, author, email) {
    var capitalisedTaskName = capitaliseFirstLetter(task);

    var baseCode = [
        "/**",
        " * " + capitalisedTaskName + " tasks",
        " * " + description,
        " * @author " + author + " <" + email + ">",
        " */",
        "",
        "function " + capitalisedTaskName + "Tasks(gulp) {",
            "// Your code goes here",
            "",
            "// Required task name. Gets auto executed by the main gulpfile.",
            "gulp.task(\"" + task + "\", []);",
        "}",
        "",
        "module.exports = " + capitalisedTaskName + "Tasks;"
    ].join("\r\n");

    return beautifyJS(baseCode);
};

function generateModuleJS(moduleName) {
    var capitalisedModuleName = capitaliseFirstLetter(moduleName);

    var baseCode = [
        ";(function($, undefined) {",
            "var meerkat = window.meerkat,",
                "meerkatEvents = meerkat.modules.events,",
                "log = meerkat.logging.info;",
            "var events = {};",
            "",
            "function init" + capitalisedModuleName + " () {",
                "// Code goes here",
            "}",
            "",
            "meerkat.modules.register(\"" + moduleName + "\", {",
                "init: init" + capitalisedModuleName + ",",
                "events: events",
            "});",
        "})(jQuery);"
    ].join("\r\n");

    return beautifyJS(baseCode);
}

var generators = {
    task: function() {
        prompt.start();

        var schema = [
            {
                name: "task",
                description: "Task name",
                type: "string",
                required: true
            }, {
                name: "description",
                description: "Task description",
                type: "string",
                required: false
            }, {
                name: "author",
                description: "Author name",
                type: "string",
                required: false
            }, {
                name: "email",
                description: "Email address",
                type: "string",
                required: false
            }
        ];

        prompt.get(schema, function(err, result) {
            if(err) return console.error(err);

            var folderPath = path.join(__dirname, "tasks", result.task.toLowerCase());
            fileHelper.writeFileToFolder(folderPath, "gulpfile.js", generateTaskJS(result.task, result.description, result.author, result.email));

            console.log("Generated Gulp Task: " + result.task);
        });
    },
    /**
     * Create a new
     */
    module: function() {
        prompt.start();

        var schema = [
            {
                name: "bundle",
                description: "Bundle name",
                type: "string",
                required: true
            }, {
                name: "module",
                description: "Module name",
                type: "string",
                required: true
            }
        ];

        prompt.get(schema, function(err, result) {
            if(err) return console.error(err);

            var folderPath = path.join(config.bundles.dir, result.bundle, "js");
            fileHelper.writeFileToFolder(folderPath, result.module + ".js", generateModuleJS(result.module));

            console.log("Generated Module: " + result.module + " for Bundle: " + result.bundle);
        });
    },
    bundle: function() {
        prompt.start();

        var schema = [
            {
                name: "bundle",
                description: "Bundle name",
                type: "string",
                required: true
            },
            {
                name: "directory",
                description: "Directory",
                type: "string",
                required: false
            }
        ];

        prompt.get(schema, function(err, result){
            if(err) return console.error(err);

            var folderPath = path.join(config.bundles.dir, result.directory, result.bundle);

            var paths = {
                js: path.join(folderPath, "js"),
                less: path.join(folderPath, "less")
            };

            fileHelper.writeFileToFolder(paths.js, result.bundle + ".js", generateModuleJS(result.bundle));
            fileHelper.writeFileToFolder(paths.less, "build.less", "// " + result.bundle + " custom LESS goes here");
            fileHelper.writeFileToFolder(paths.less, "variables.less", "// " + result.bundle + " variables go here");

            var bundleJson = {
                brandCodes: ["ctm"],
                dependencies: ["meerkat", "core"]
            };

            fileHelper.writeFileToFolder(folderPath, "bundle.json", stringifyJSON(bundleJson));

            console.log("Generated Bundle: " + result.bundle);
        });
    }
};

if(typeof generators[action] !== "undefined")
    generators[action]();