/**
 * Meerkat Asset Pipeline
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

// Important!
// The watch method used by gulp plugins doesn't seem to appreciate having so many active listeners
// To get around it, we set the default number of listeners to be greater than the default (10)
require('events').EventEmitter.prototype._maxListeners = 30;

var fs = require("fs"),
    gulp = require("gulp"),
    path = require("path");

var BundlesHelper = require("./helpers/bundlesHelper");

// Meerkat Ascii. Do not remove or Sergei gets it.
console.log("\r\nCompare the Market");
console.log("Meerkat Pipeline\r\n");
console.log("                                     ==~\" ~~\"\-\r\n                                ,,c=\"\",r???4;,=c,\r\n                         .ed$$$b.\"4?C,c$$$$,<$c;,\"c\r\n                       .d$$P\"\"\"\"\"$c,  \"?$$$'<$$$ $c\",\r\n                   ,c$.$$C.dMMMn.\"$$b,.`-`\",d$$F ?$;)                                \r\n                   `?$.\"?$b,4MMMMn.?$$$$$$$$$$$b,,,c<\r\n                           \"\" `\"4MM,\"$$$$$$\"\"\"'```\"\"?h\r\n                                  \"4b,\"$$$    ``~~-  ?\"h\r\n                                    `\"bn`?,          J:3\r\n                                     \"c\"4Mbnmn,_ _,/\";rF\r\n                                      \"$.\"MMM\"  ``\"??\"\r\n                                       \"\"%'4Mb\r\n                                     z$$$$$.\"4Mn,\r\n                                   .$$$$$$$$$c`4MMmn,,,\r\n                                 .d$$$$$$$$$$$$c`4MMMMbe=\r\n                               .d$$$$$$$$$$$$$$$$c`MMMMMMM,-\r\n                            ,c$$$$$$$$$???????$$$$c`MMMMMMM `,\r\n                         ,c$$$$PF\"\"      \"??$$c$$$$ MMMMMMMb 4$c,\r\n                     ,cr)C???\"            <;;,\"$$$$ MMMMMMMM>`$$$$cc,\r\n                     d3$$$$$b..            ,cd$$$$F,MMMMMMMM>   `,c$$$r\r\n                     \"?$$P\"\"\"\"??c,,        `\"?$$$$ MMMMMMMMM  ,zd??\$P\"\r\n                       \"\"        `\"\"?c,,    !>-`$F,MMMMMMMMP,f\"     \"\r\n                                      ``\"?c,J$$$F MMMMMMMMM f'\r\n                               ,       zd$$'J$$$'dMMMMMMMMf,h\r\n                            c,  \"r    J$$P  $$$F,MMMMMMMMM d\"\r\n                             `\"b,?c, z$$\"   $$$ MMMMMMMMM>;\",-//\r\n                                \"?-J:$$\"d  4$$F,MMMMMMMMM r'4P\"\r\n                            ,cc=4='\"''     d$$ MMMMMMMMM\\r\n                                           ?$'dMMMMMMMMP\r\n                                          ! F,MMMMMMMMM\r\n                                         <','MMMMMMMMMf\r\n                                        ,cd dMMMMMMMMM\r\n                                       ,$$F,MMMMMMMMMM\r\n                                       $$P,MMMMMMMMMMM\r\n                                      $$$ dMMMMMMMMMMP\r\n                                    , $$'nMMMMMMMMMMM>\r\n                                    !>?F,MMMMMMMMMMMM\r\n                                  ,$c,',MMMMMMMMMMMMM\r\n                                  $$$',MMMMMMMMMMMMMM\r\n                                < $$F,MMMMMMMMMMMMMM>J\r\n                               `!>$P,MMMMMMMMMMMMMMM Jr\r\n                             J$bc,P MMMMMMMMMMMMMMMM $b\r\n                            c$$$$$'dMMMMMMMMMMMMMMM'J$$,\r\n                        , ,d$$$$$F,MMMMMMMMMMMMMMMP,$$$$\r\n                     ,zd ,$$$$$$P MMMMMMMMMMMMMMMP,$$$$$h\r\n                ,cc$$$\",$$$$$$$$'JMMMMMMMMMMMMMP\",$$$$$$$\r\n          .,cd$$$$$$$\",$$$$$$$$$,4MMMMMMMMMMMP\",$$$$$$$$\"\r\n .,,ccd$,4$$$$$$$$$$F<$$$$$$$$PP\"              \"$$$$$$\"\r\n                      ?$$P\"\"                    `$$$\"\r\n                      ,$\"                       ,P\"\r\n      ,,;;;-=ccd$$$$P\"\"                        c$bcc,,,,,,,,ccccc ;;!';?\"\"\r\n");
console.log("Initialising gulp tasks... Give it a moment, yo!\r\n");

// TODO: Do maven integration
// TODO: Create task for build server? Or prevent watch on build server etc
// TODO: Create task for creating new bundles
// TODO: Create task for compiling plugins
// TODO: Create task for sprites (see Mark)

// Inject our config into the gulp object so that
// we can use it easily in our bundles
gulp.pipelineConfig = require("./config");
gulp.bundles = new BundlesHelper(gulp.pipelineConfig);

var tasks = {};

// Load in our tasks
fs.readdirSync(gulp.pipelineConfig.tasks.dir)
    .forEach(function(folder) {
        var entryPoint = path.join(gulp.pipelineConfig.tasks.dir, folder, gulp.pipelineConfig.tasks.entryPoint);
        tasks[folder] = require(entryPoint)(gulp);
    });

gulp.task("default", Object.keys(tasks));