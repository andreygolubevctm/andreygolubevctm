module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-croc-qunit');
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        qunit: {
            options: {
                'phantomPath': grunt.option('phantomPath')
            },
            all:['qunit/*.html']
        }
    });
    grunt.registerTask('default',['qunit']);
};