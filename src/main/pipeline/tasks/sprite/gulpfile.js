/**
 * Sprite tasks
 * Generates LESS and image for a sprite based on provided files
 * @author Mark Smerdon <mark.smerdon@comparethemarket.com.au>
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */
var path = require("path"),
    fs = require("fs-extra");

var spritesmith = require("gulp.spritesmith"),
    merge = require("merge-stream");

function SpriteTasks(gulp) {
    var config = gulp.pipelineConfig,
        spriteConfig = config.sprite;

    var bundleTasks = [];

    for(var bundle in gulp.bundles.collection) {
        (function (bundle) {
            var srcPath = path.join(spriteConfig.source.dir, bundle, "src");

            // Check if bundle has a sprites folder
            if(fs.existsSync(srcPath)) {
                var taskName = "sprite:" + bundle;

                gulp.task(taskName, function() {
                    var spriteSmithConfig = {
                        imgName: bundle + ".png",
                        imgPath: "../../../graphics/logos/sprites/" + bundle + ".png",
                        cssName: "logosSprites.less",
                        padding: 2,
                        cssVarMap: function(sprite) {
                            sprite.name = bundle + "-logo-" + sprite.name;
                        },
                        cssOpts: {
                            functions: false,
                            variableNameTransforms: []
                        }
                    };

                    // Not sure why, but health shouldn't have retina images
                    if(bundle !== "health") {
                        spriteSmithConfig.retinaSrcFilter = [path.join(srcPath, "*@2x.png")];
                        spriteSmithConfig.retinaImgName = bundle + "@2x.png";
                    }

                    var spriteData = gulp.src(path.join(srcPath, "*.png"))
                        .pipe(spritesmith(spriteSmithConfig));

                    var imgStream = spriteData.img
                        .pipe(gulp.dest(path.join(spriteConfig.source.dir, "sprites")));

                    var cssStream = spriteData.css
                        .pipe(gulp.dest(path.join(config.bundles.dir, bundle, "less")));

                    return merge(imgStream, cssStream);
                });

                bundleTasks.push(taskName);
            }
        })(bundle);
    }

    gulp.task("sprite:build", bundleTasks);

    gulp.task("sprite", []);
}

module.exports = SpriteTasks;