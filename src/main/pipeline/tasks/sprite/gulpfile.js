/**
 * Sprite tasks
 * Generates LESS and image for a sprite based on provided files
 * @author Mark Smerdon <mark.smerdon@comparethemarket.com.au>
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */

var path = require("path"),
    fs = require("graceful-fs-extra");

var spritesmith = require("gulp.spritesmith"),
    imagemin = require('gulp-imagemin'),
    buffer = require('vinyl-buffer'),
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
                var taskName = "sprite:" + bundle,
                    imgPathPrefix = "../../../graphics/logos/" + bundle;

                gulp.task(taskName, function() {
                    var ts = new Date().getTime();
                    var spriteSmithConfig = {
                        cssName: "logosSprites.less",
                        imgName: "spritesheet.png",
                        imgPath: imgPathPrefix + "/spritesheet.png?ts=" + ts,
                        cssSpritesheetName: bundle + "-logo",
                        retinaImgName: "spritesheet@2x.png",
                        retinaImgPath: imgPathPrefix + "/spritesheet@2x.png?ts=" + ts,
                        cssRetinaSpritesheetName: bundle + "-logo-2x",
                        retinaSrcFilter: [path.join(srcPath, "*@2x.png")],
                        padding: 2,
                        cssVarMap: function(sprite) {
                            sprite.name = bundle + "-logo-" + sprite.name;
                        },
                        cssOpts: {
                            functions: false,
                            variableNameTransforms: []
                        }
                    };

                    var spriteData = gulp.src(path.join(srcPath, "*.png"))
                        .pipe(spritesmith(spriteSmithConfig));
                    var imgStream = spriteData.img
                        .pipe(buffer())
                        .pipe(imagemin([imagemin.optipng()], {verbose: true} ))
                        .pipe(gulp.dest(path.join(spriteConfig.source.dir, bundle)))
                        .pipe(gulp.globalPlugins.debug({
                            title: "Finished Spritesheet Image"
                        }));

                    var cssStream = spriteData.css
                        .pipe(gulp.dest(path.join(config.bundles.dir, bundle, "less")))
                        .pipe(gulp.globalPlugins.debug({
                            title: "Finished Spritesheet LESS"
                        }));

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