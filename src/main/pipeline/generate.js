var argv = require("yargs").argv,
    path = require("path"),
    fs = require("fs"),
    mkdirp = require("mkdirp"),
    prompt = require("prompt");

var config = require("./config"),
    action = argv._[0];

function writeFile(folder, fileName, content) {
    mkdirp(folder, function(err) {
        if(err) console.error(err);

        fs.writeFile(path.join(folder, fileName), content, function(err){
            if(err) return console.error(err);
        });
    });
}

function stringifyJSON(jsonObj) {
    return JSON.stringify(jsonObj, null, 4);
}

var generators = {
    bundle: function() {
        prompt.start();

        var schema = [
            {
                name: "bundlename",
                description: "Bundle name",
                type: "string",
                required: true
            }
        ];

        prompt.get(schema, function(err, result){
            if(err) return;

            var folderPath = path.join(config.bundles.dir, result.bundlename);

            mkdirp(folderPath, function(err){
                if(err) return console.error(err);

                var paths = {
                    js: path.join(folderPath, "js"),
                    less: path.join(folderPath, "less"),
                };

                // TODO: Use a meerkat module generator
                //writeFile(paths.js, result.bundlename + ".js", "hello");
                writeFile(paths.less, "build.less", "// Custom LESS goes here");

                var bundleJson = {
                    brandCodes: ["ctm"],
                    jsDependencies: ["meerkat", "core"]
                };

                writeFile(folderPath, "bundle.json", stringifyJSON(bundleJson));

                console.log("Generated Bundle: " + result.bundlename);
            });
        });
    }
};

if(typeof generators[action] !== "undefined")
    generators[action]();