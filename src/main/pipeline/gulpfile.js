/**
 * Meerkat Asset Pipeline
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
"use strict";

// Important!
// The watch method used by gulp plugins doesn't seem to appreciate having so many active listeners
// To get around it, we set the default number of listeners to be greater than the default (10)
require('events').EventEmitter.prototype._maxListeners = 100;

// TODO: Create task for creating new bundles
// TODO: Create task for compiling plugins
// TODO: Create task for sprites (see Mark)

var gulp = require("gulp"),
    fs = require("fs-extra"),
    path = require("path");

var tasks = {};

var BundlesHelper = require("./helpers/bundlesHelper");

// Inject our config into the gulp object so that
// we can use it easily in our bundles
gulp.pipelineConfig = require("./config");
gulp.bundles = new BundlesHelper(gulp.pipelineConfig);

// Meerkat Ascii. Do not remove or Sergei gets it.
console.log("\r\nCompare the Market");
console.log("Meerkat Pipeline\r\n");
console.log("\r\n                                                                                                \r\n                                                          `                                     \r\n                                                                                                \r\n                                               ``.,:,,,,,,,`                                    \r\n                                             ` `:;;''''';'++;,..`` `.,,..`                      \r\n                                           ` `::;;'';;'';;:;''',,,,;;;;;:,`                     \r\n                                          ``.,:;;';;';;''';:,+;;::;::;;:;::.                    \r\n                                           ..:;:;:;;''+++++',;';''';;;::,,.``                   \r\n                                         ```,;;;;:;'++#####'::;';++''';:,:.  `                  \r\n               ..,,.:                     `,:;;;:;'+##+####;::;:'###++'':,.`.```                \r\n             `,,,,..,,                    `,;;;::'+#####+++:::;;+###@##+':,:::,..               \r\n            ,,,.......,:                 `.:;;;::'##+#''#+':;'';;+;'#@@@@#@#@;::.``             \r\n          `,,..`......,,:             .,..,:';::'#########';';;''@+''''++';@+++'',.             \r\n         `....``....:,:;::           `:''+++'@#;###'#####+++::;:'##@####+';##++'';,.            \r\n         ..``......:;;;;';'++++    `.:'###+'+;;+++#####+###',:;:.+#######''++''+++:`            \r\n        ...,,,,...:::;;;;;##@@#'.  `:+++#+++'+;+'+#######'';::,::.+######';+';;''+;.`           \r\n       ...:::,:::::;:;;;';;#@@@@+`.,'+++++##++''++####+#'#';;:;:;'.+'####':+';;;'':.            \r\n      :;.::::::,:::;:'+#@@@@+@@@#'.;'++'++##++''##++'+++#++;;;;;:;:'#++#++:'+''''':.            \r\n     ;#@;:::::,:'##+@@#+##+@'#@@@+.;'++''####++;'++'++###':';+;'+';:#+++++;';''''+;.            \r\n    ;@#@;;+###@#+;;#+###@@+:::@@@','+'++++###+';,;''+++++:,;'+####++:';''',;;';'+';`            \r\n    +#+###''#@;+:::,:;@#@@+::.'@@+:;'';'++###+';';+''+++;;,''###'+#+':;:;,.:'''''+;.            \r\n   `##;+.+#+@#:,:::::;'@@#':'.'@@@,:';'''+++#'';'+::';;;:'+'+######+',::',.:;;;+'':`            \r\n   .##:,.+###':::'';,::++':;'.'@@@.,'''';;++#';;''+''+;:;'''++####+#:,,;:,.;;'''';,             \r\n   .##,,`'###:,'#@##'::,::';':'#@#`.;''';''+;:;';';';';:;'++'+'''+';;:,,,..:''';';.             \r\n   .##:...##',,'@#+#+:::;:;'';'@@'`.;'''+;;';:;'';;;:;:'+''+';'+':';;::,,..;;'+;:`              \r\n   `##:....,,:,'+#+++;,:;;;'+:#@'``.,;;++':;;;;;;;::,:;+''+'''':'''+:;::,..'''';`               \r\n    '#;...,,,,,''+'+';:::;:;##''.``.,,:+''';;;;;::,,,:'++++''':;;;;+#':;,..';;:.                \r\n    `+':,.,,,,:;';#';';;:;;.`.```....::;'';'';;;:..,;:'+############';:;,,,;;,.`                \r\n      '##+,,.,,;';'::,::;;'.````......,:;''+;;;;,,.,;'+####+###++#++#;':,..```                  \r\n        ,,,,,.,,.,,,,,,::++'.``.......,;;'##+';:,,,;'++##+++++++++'';;;:,,`                     \r\n        ``..,:,.,..,:::;'+++...........,;++++';:,:,:+###++'''+++'+'';;:,,``                     \r\n       ``..,,,:;,::::;;:;;+.,..........,,:';;::::::;'+++'';;'+'''''';;:,.`                      \r\n       ``..,,,.:::::::::;:`.,............,,,,,:;;:;;'++'''''+'''''''';,.                        \r\n      ``..,,,,. ,;,,:::;```..,..,,,.....,,,,,,,;;;;''''''''''';;;;'+;:..`                       \r\n     ``..,,,,,.`` `,::;`````.:,,,,,.....,,,,,,:;;''''++''''';;;;;;';,.`                         \r\n    ``..,,,,,,```   `,:``````;:,,,....,,,,,,,,,:;''+++'+'';;;;;;';':.`                          \r\n    `...,,,,,,``    ..,`````,.,:,.....,,,,,,,,,:;'''+++'''';;;;''';`.                           \r\n   ``..,,,,,,..```   .,.````...,.,..........,,,:;;'+++'+''';';;''';`                            \r\n   ``..,,,,..`.`` `.`,.:```,`..,.,.``........,,,;;''++++''''''''';::                            \r\n   ``..,,,.`.`````  `.`,`````.....,.```````...,,;''+++++'''''''';::,                            \r\n   ``..,,.```````` ``...,````..,`.,,.```````..,,,''+++++'++''';:::,,,                           \r\n   ``..,,````````````,`,..```...`..,,.    ``...,,''++++''+''':::,,,..                           \r\n    `..,```` `````` `.`,.:;....``...,,     ``..,;''++##+++':,,,,,....                           \r\n    ``.````` ``````` ....,'..`..`...,.,`    ``..+''+####+::,,,,.....,                           \r\n     ```````  `````` .`:..:.,.`,`.....,      `..+''+###::,,,......`,.                           \r\n     ````````````````.....';:,,:......'+     ``'''''##:::,,.....``,``.                          \r\n     .`  ````.```````..,`.:```,'..`.,+'+.     `''''++',,,,.....`,`..``.                         \r\n     :.   ```, ``````....,,,....;..,+'+++     `+'';#;;;,,,...`,`.`````.                         \r\n    .:::  ```;```````,.:`,,:,....:;''++'+`    ++''++;;',,..`:...`.`..``.                        \r\n    :::,: ``.````````,,.`:.:,....:;'''++'+   +'+;:++';#..`',.....```..``.                       \r\n   `::::,:``:````````.,,.,.::..,::''++++++  +''++;';':+,+,......`......`.`                      \r\n   ,:::'#:';,````````..,`,.:;..'#'';;'++++'';;;;':;;::;,,........``````...                      \r\n   :::;+##;'.`````````,..,.;,.:;';;'''''+++;::::::';::,,..........`````....                     \r\n   ,::'+##++..`````````,.:::..:';;;;''+;+++:::::::''::.............``..``...                    \r\n   ::,,+'#+',.``````````,,:,..;+#';;;;++;++'::::::;:;,,......`....``...``...,                   \r\n   ::,,'+#'+,`````````````....:'+;;;';'';:+;:::::;;:::,.....,....``....`.`...`                  \r\n  .,::,;+;';.``````````..`....:'#+';;;;':;;::::::';::,,,....#...``.....``....,                  \r\n  :,:::'''';.````````.``.````.,:+;;;'+;';':;:::::';::,....;.#....,....````...,`                 \r\n  ,,:,,';;;:.`````````````````.'';';'+';';';:::::;'::.....:..`.........`.....,:                 \r\n `,::..,'+',.``````````````;''''+#''';;;''''':::;;:;,............`````.......,;                 \r\n```,,,,,;'+'':,,:,::;;;';';';;''+#@+;'''';''+;;:::::;,......,..````````......,:`                \r\n``..,,,,,,''''';;;;;:;';;;:;;;'''###@'''+;;'++;:;;:,,;.,,..`,..````````.....,,:`                \r\n``..,,,,,.;+''';;;;;:;;;;;;;;;';'+####,'+';'++';;;:;,;.....:;####@+.````...,,,:`                \r\n``..,,....''''':;;;;;:;;;::;;;;';+++#,,,;':;+'#';;';;;....,'#######@;```..,,,,;`                \r\n``........,''''';;;;;:::;;;;;:';;++#',,:,''++''';;;'';::,.'####@#####'.`..,,,:'`                \r\n ````````..'+''';;;;;;::+;';;;'';'++;,::;';'+';';;''+';;:,##########@#;...,,::.`                \r\n   ```````.''';;;;;;;'+####;;';;''++;,::+';;;+''';;;;''';;;+##########@,..,::'``                \r\n        ``.,'';;;;;;;''####;;;''''+''::;#';;;;+';';;;+'''';;''+########'.,::;,`                 \r\n         `..,:;;:;';;'+####;;';'''''';;'#';;;:+'';;;;;';'#'';;'+########,,:;'``                 \r\n         ``..,:::::;';''###;';''''++';;##';;;;';''';;;;;'+''';;++######@,:''```                 \r\n          `...:;;;;;'''++;';';'''+++''+##';;;;;;'+'+;';;':;'';';'+######:;'.``                  \r\n          ``..,:;;:;;;''#''';+;++'+'+'##,';;;;':;;'+'++'';;;;;;;';'+###@;+,.``                  \r\n           ```,:;;;';;''+'+;;'''''+++++,:';;;':'::;+''';;''';;;;;';'@###+'..`                   \r\n            ``:;''';'';'+'++''''''+++++''';;:+;;'::;+++'++;'+';;;;:'@#@+''..`                   \r\n              ;;'''';'''''#'';'''+++''+'+';;;':;';::;+++'+'#;;::;;,+#@+'''..`                   \r\n             .;;''''';+'+;',:'''''''++''+;;;;:;;:',:::'++'+++#':;;;+'''';;..`                   \r\n             ;:'''';'''++,,,,';''''+''''';;;;':;::;:::'+''+'''''':''''';;,..`                   \r\n             :;;'';;';'';,,,,,::,:;;''';';;;':'::::;::;+'+';';'';;'''';;;...`                   \r\n            `::'';;;;;;:,,,,,,,,,,:,:::'';;;+;;';:;'':'+;;+:';;+;'''';;::...`                   \r\n            .;;:';;;:,,,,,,,,,,,,,,,...+';;;';;':;;;';'++;'''''''''';;:::,..`                   \r\n            `:;;';;,,,,,,,,,,,,,,,,,..`+';;;;;;;';;;''+++++''';;''';;::::,..``                  \r\n             ,::::,,,,,,,,,,,,,,,,,,.``';;;;';;;;+'''++++++'';::;';;::,,:,..`                   \r\n               `..,,,,,,,,,,,,,,,,,,...';;;'''';'+++++++++++';:,:;;::,,,:,..`                   \r\n               ``..,,,,,,,,,,,,,,,,,..'';;;'++''++++++++++++;:,,,::,,,,,;,,.``                  \r\n               ``..,,,,,,,,,,,,,,,,,,.#';;;++++'+++++++++++':,,,,,:,,,,,:,,.``                  \r\n               ``..,,,,,,,,,,,,,,,,,,.+';;;'+++#++++++++++';:,,,,,,,,,,,:,,..`                  \r\n               ``..,,,,,,,,,,,,,,,,,,.'';;;;'++++++++++++';:,,,.,,,.,,,,;,,..`                  \r\n               ``..,,,,,,,,,.........;';;;;;;''+++++++++';::,,...,,.,,,,;,,..``                 \r\n               ``..,,,,,,,...........+';';;''';;;'''''';;::,......,,,,,,:,,,.``                 \r\n               ``..,,,,,,..``````````+'''''''';:;;;;;;::::,,......,.,,,,:,,,.``                 \r\n               ``.........`````````  '''''''''::::::::::,,,......,,,,,,,:,,,..``                \r\n                ``.....````         ,'''''';;':,,:::,,,,,,.......,,,,,,,,,,,,.````              \r\n                 ````````           +''''';;::,,,,,,,,,,,........,.,,,,,::,,,.````              \r\n                                    +'''';;:::,,,,,,.............,.,,,,,,::,,..````             \r\n                                    +'''';;::,:,,,,,............,,..,,,,:::,,,.````             \r\n                                   ;'''';;::::,...................`.,,,,:::,,,.````             \r\n                                   +''';;:::;....................,`,,,,,:::,,,.```              \r\n                                   +'';;;::,:......................,,,,,:::,,,.```              \r\n                                  .''';;::,,,....................,`.,,,:::,,,..```              \r\n                               ```+'';;:::,,.....................,.,,,,::::,,,.``               \r\n                            ``````+'';:::,,:...................,,,.,,,,::::,,,.```              \r\n                        ``````````+';;::,,,;.....................,.,,,,;::::,,.````             \r\n                    `````````````;+';:::,,,;.....................,.,,,,;::,:,,..```             \r\n                   ``````````````#';;::,,,,,,....................,,,,,,;::::,,,.````            \r\n                   `````````````.+'';::,,,,,;....,..............,..,,,,;:::::,,.`````           \r\n                  ````````````...+;;;:,,,,,.......................,,,,,;:,::,,,.`````           \r\n                  ``````````....'';;::,,,,:.........,.............,,,,,:,,:,,,,.``````          \r\n                  ```````````...+'::::,,,,,......................`,,,,,:,,,,,,,.`````           \r\n                   `````````...;+'::::,,,,`...................,...,,,,,:,,,,,,,.`````           \r\n                     ```````...'+':::,,,,:............,..........`..,,,:,,,,,,,.````            \r\n                      ``````...:'';::,,,,;......................``.`..,:,,,,,,..```             \r\n                       ``````...;;:::,,,,;...................,`;##+++#,,,,,,,,..``              \r\n                        ````...,+:;:,,,,,:...................+++++#''@+,,,,,,..``               \r\n                        `````..:++.;:,,,,.................`++++++'+;'#+,,,,,..``                \r\n                        ```````:+##'.,,,:..............`:'+;';''''';'+:,,,,,..``              \r\n");
console.log("Initialising gulp tasks... Give it a moment, yo!\r\n");

// Load in our tasks
fs.readdirSync(gulp.pipelineConfig.tasks.dir)
    .forEach(function (folder) {
        var entryPoint = path.join(gulp.pipelineConfig.tasks.dir, folder, gulp.pipelineConfig.tasks.entryPoint);
        tasks[folder] = require(entryPoint)(gulp);
    });

gulp.task("default", Object.keys(tasks));

gulp.task("clean", function() {
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "js"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "brand", "*", "css"));
    fs.removeSync(path.join(gulp.pipelineConfig.target.dir, "includes"));
});

gulp.task("build", ["clean", "default"], function () {
    // We don't need watchers so we can just exit here.
    // Don't delete the beautiful Sergei.
    console.log("\r\n                                     `.,;;:,                                                       \r\n                                    `.;'''''+,                                                     \r\n                                   `.:;++++++++,.`                                                 \r\n                                `;:.,:;'';;++',,;';:`                                              \r\n                              `;##+.,:'+++':+;';::,;,                                              \r\n                              ,++##,,'##+#+:;;##+;,,.                                              \r\n                              :;;'#'+++'+';;;:+#+#;.;;:.                                           \r\n                              ,:'#@+,+##+#','+###++;#+++;                                          \r\n                              .:'#@;:;+##;.;:+++##+++####,                                         \r\n                              `;++#:;:;'';,,.'++###+##+##,                                         \r\n                               ;#++;;''';:::':++##',#####.                                         \r\n                               `+''::;;'::;;;;+#+++;#####`                                         \r\n                               `;':,:::::+;'+;+:++:'####+                                          \r\n                                `:,,:;,:;#@#@+;;'':'###+`                                          \r\n                                   `,:+;;'###'';;;'+##'`                                           \r\n                                    .+#+,;'++''';;;+#,                                             \r\n                                    `,;:;''+#@++;;,                                                \r\n                                     .:;'++++++';,                                                 \r\n                                    `.;''@#++'';                                                   \r\n                                     `:'++#+'';,                                                   \r\n                                   . `::++'''';`                                                   \r\n                                  `; ``''+'''':.                 Bye bye.                          \r\n                                  `; `..++''::,;                                                   \r\n                                  .;```.+++,,,:'                                                   \r\n                                  .;.``.`@.,,,;',                                                  \r\n                                ``.;....+;;,,:;+,.                                                 \r\n                                ``.;..``':#,::;':,.                                                \r\n                                `.,:..,.;;+,::;',,.                                                \r\n                              ``..,:,...,:;:,:;',..`                                               \r\n                              .:..,:,...,;';::;',..`                                               \r\n                             `,:,,:::..,,:';::;',..``                                              \r\n                            `,::,,:;:,,,;:';:'+':,.``                                              \r\n                            .,::,,:;;:,:,'';;';'::..;,                                             \r\n                           .,:;:,,;;;;;;;;'''''';:,.::                                             \r\n                          `,:;;,,,;;;;;;;'';''''';,..;`                                            \r\n                          ..:;:,.'':::;';;'''''''':,.``                                            \r\n                      :  ...:;:,.';:;;;;;;';'''+++;,.``                                            \r\n                     .,  `.,:;',;';:;;;;;;;'''''++':...`                                           \r\n                     ,,;``.,:;';':::;;;;;;''''''++':....                                           \r\n                    `,,::..;;;;::::;;;;;;;;'''''+#':,.``.                                          \r\n                    ::,;::,;`  ,:::;;;;;;;;;'''''+';,`` '                                          \r\n                    ,,::::.   ,,:::;;;;;;;;;'''''`'+,` ';,                                         \r\n                     .,,::;   ,,:::;;;;;;;;''''''  ',.+';;                                         \r\n                     ``,:;,   ;::;;;;;;;;;;''''''`  ;###''                                         \r\n                      `,,:..  ;;;;;;;;;;;;''''''''   '+#''                                         \r\n                       .,,,,;`;;;;;;;;''';''''''';   :'++#`                                        \r\n                        ,,,,,,,;;;''''''''''''''';   .'#+';                                        \r\n                         ,,.,,':;'''''''''''''''';`   ;++''                                        \r\n                       '':,.:';':'+++''''''''+''';.   :++''                                        \r\n                       ++':,;'';'+'+++''''''++''';:    +#''         :..::;,,,,.:                   \r\n                     '`.++ `,..:;';'++++''''++''';:    ;#:;         :.:,#+++'';,`                  \r\n                    ` #;'+    .,:'''+++++'''++''';:    ,;:;         :++;+++#+;:';                  \r\n                    + #,'#';:,'';##'+++++++++'''';:    ,;,,         :;:.,':';##;;                  \r\n                     ,+;''++#+'+##+;'+++++++++''';:    .';:          +#++#+##+';;                  \r\n                     '@+++++;,`,';:;;'++++++++''';;    `;';;:`       #+'++'##:;;                   \r\n  `,,,,,,,,::,,,,,,,:'#+++;` `,  .,`+'+#+#++';';,;:;;',;::':::::;;;;++++'++++'+;,.```              \r\n  ,,,,,,,,,,,:..:,:;;:;+'';:.,:` :, :+++'':.;:;:;,';;:::+:;'+@#+#::++++'##''+#+#;:::::::::::::,,.  \r\n `::,,,,,,,..:::;;,,::;;;;;:,:.``,`,:+;:;'::',:;,:';;,:;':::,;::,,.:+#++;''''++';;::::::::::::::,,:\r\n ::,,,,,,,,,:;::,::;:,,:;''';;;;';:';;;::::::;:;''':;'''+;:::;:,,,,,,,,:;''''';;;::::::::::::::::::\r\n.;:,,,,::::,,::.:;;.:,';,.::.::,,;,:;:::,:;.:;;:;:;,;,';;+'::,::,,,,,::;;;;;;;;:::::::,::::::::,`  \r\n,;;;:;:;;;;;.;.',.;'.,`;;;;.;..':;;;;:+;'+''#+:':':+#+'.;++':'';;::;;;'''',.`````                  \r\n           ';,'.:;;':.;'.:'''::++;+;:.;++':;''';:;;';+;:;+'';..++++''''''                          \r\n          :;.:;':.';'.'..;'::.'''+';+'+:++;'+,+;'+++'''::;+:.`++++''''''                           \r\n          ,;'+.';.;:::;;:+;'':,';'',''+'':''#''.';+++;:;;:;,.++++''''''`                           \r\n           ;++'';:.:',.;;;::`.';'',',;'.;;;';,:'#;,;,#'+'';;'+++''''';`                            \r\n            ,;::';.`...:.;;;::;,.;'''+':::;,;+:'''':;+''+''#+++''''''.                             \r\n            ';::;,':.::;':;:,;;::::;+':.+''''.:.+++;;#+'+';:'+'''''':                              \r\n             ``.';';.,`;';.;;':''..''''.';+;'':'':'.;'+++','''''''''                               \r\n                .''''';.++#+''+'++++++++';'++++''';      +'++''''''                                \r\n                  ''''';.+++++++++++++++++++++''';;     +'++''''''                                 \r\n                   '''''':++++++'+++++++++++++''';:    ++++''''';                                  \r\n");
    process.exit();
});