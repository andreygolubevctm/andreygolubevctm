/**
 * Lint tasks
 * Runs lint commands
 * @author Christopher Dingli <christopher.dingli@comparethemarket.com.au>
 */

function LintTasks(gulp) {
    // Required task name. Gets auto executed by the main gulpfile.
    gulp.task("lint", ["lint:js"]);
}

module.exports = LintTasks;