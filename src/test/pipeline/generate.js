var argv = require("yargs").argv,
    fs = require("fs");

var config = require("./config"),
    fileHelper = require("../../main/pipeline/helpers/fileHelper");
var action = argv._[0];
var testList = require(config.testList.dir + config.testList.entryPoint );

function generateIncludes(base, moduleNames, postfix) {
    var baseCode = [];
    for (var i in moduleNames) {
        var moduleName= moduleNames[i];
        console.log("moduleName" , moduleName);
        baseCode[i] = "<script src=\"" + base + moduleName + postfix + "\"></script>";
    }

    return baseCode.join("\r\n");
}

var generators = {
    index: function() {
        fs.readFile(config.index.dir + config.index.template, 'utf8', function (err,data) {
                if (err) {
                    return console.log(err);
                }
                var result = data.replace(/\$\{webappLocation\}/g, config.webapp.dir);
                var result = result.replace(/\$\{base\}/g, config.base.dir);
                var result = result.replace(/\$\{unitTests\}/g, generateIncludes(config.testLocation.dir, testList.tests , "Test.js"));
                var result = result.replace(/\$\{modulesUnderTest\}/g, generateIncludes(config.base.dir, testList.tests , ".js"));
                fileHelper.writeFileToFolder(config.index.dir, config.index.entryPoint, result);
        });
    }
};

if(typeof generators[action] !== "undefined")
    generators[action]();