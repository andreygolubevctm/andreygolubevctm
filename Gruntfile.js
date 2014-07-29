/* jshint node: true */

/**
 * GRUNTFILE.JS:
 * What's this for and why do i care?
 * Grunt is a JavaScript Task Runner. This file defines it's operation and actions.
 * It that belongs in the root directory of our framework project, next to
 * the package.json file, and should be committed with your project source.
 * (package.json is a node-ism, which defines meta and required packages for install)
 *
 * A Gruntfile is comprised of the following parts:
 *  - The "wrapper" function
 *  - Project and task configuration
 *  - Loading Grunt plugins and tasks
 *  - Custom tasks
 *
 * It will be responsible for doing all of the things. See below.
 */

module.exports = function(grunt) {

"use strict";

	//Time just gives us some timings stats while i'm making this performance faster.
	require('time-grunt')(grunt);
	var _ = require('lodash');

	//Auto loadtask based on the globbing pattern against the package.json
	require('load-grunt-tasks')(grunt, {pattern: 'grunt-*'});

	/**---------------------------------------------------------------------------
	 * GRUNT PROJECT CONFIGURATION:
	 * This specifies all the information that will be required when resolving deps,
	 * collating files, or running plugin tasks on the correct codebase.
	 * Calling tasks is done with task alias's at bottom.
	 */

	//Please see http://itsupport.intranet:8080/browse/AGG-1780 for information
	//on the latest refactor to define tasks programatically via a brand and
	//vertical array mapping. There's suggested resources for a somewhat cleaner
	//approach to the same problem in the commentary too.

	//PS... if you're console averse, you can get text output in 'Grunt Devtools'
	//chrome extension with: "grunt-devtools": "~0.2.1" in the package.json.

	// Path Root - Sets the base directory for file paths henceforth.
	grunt.file.setBase('WebContent/');

	//Initial tests with trying to determine brand and vertical combos.
	//var lessBrandAndVerticalPaths = grunt.file.expand({cwd:'brand/'},'*/less/framework.build.*.less');
	//console.log(lessBrandAndVerticalPaths);

		/**
		 * TASK CONFIG OPTIONS:
	 * This sets up options for all the various task utilities; 
	 * aka Grunt plugins doing stuff for us.
		 * Paths are relative to this Gruntfile.js
		 */

	//You're able to define many verticals per brand.
	var brandMapping = [
		{
			brandcode : 'guar',
			verticals : ['health','generic']
		},
		{
			brandcode : 'amcl',
			verticals : ['health','generic']
		},
		{
			brandcode : 'yhoo',
			verticals : ['health','generic','car']
			},
		{
			brandcode : 'ctm',
			verticals : ['health','homeloan','simples','car'] //ctm will use the old platform code for it's generic.
			}
	];

	//Our internal functions are brought in
	var tools = require('./WebContent/framework/build/Grunt.tools')(grunt);

	//Output a heading to explain the log output in the forloop.
	grunt.log.subhead('Passing Brand Vertical Maps:');

		/*
	 * Loop through brands and build a task list up via merging to the
	 * masterTaskList object. Then pass that to initConfig for grunt to run.
	 * If we had many separate files in the require()... we'd likely do:
	 * _.merge.apply(masterTaskList, _.values( lots of tasks here ));
		*/
	var masterTaskList = {};
	for (var i = brandMapping.length - 1; i >= 0; i--) {
		grunt.log.writeln(brandMapping[i].brandcode,brandMapping[i].verticals);
		masterTaskList = _.merge(masterTaskList,
			require('./WebContent/framework/build/Grunt.tasks')(grunt,tools,brandMapping[i]) //Bring in the file.
		);
				}
	//console.log(masterTaskList);

	//Now that it's built, get grunt to load everything.
	grunt.initConfig(masterTaskList);

	//This throws the task alias's in - they are normally what we run things from.
	//We do some loops INSIDE this file with the original brandMapping obj.
	require('./WebContent/framework/build/Grunt.aliases')(grunt,brandMapping);

	//In future, it would be nice to break up the gruntfiles even further (by task) and have https://github.com/firstandthird/load-grunt-config do the heavy lifting as per it's example. This also supports load-grunt-tasks as a dep, so no need to use it above anymore. http://firstandthird.github.io/load-grunt-config/ is more docco.


}; //END OF FUNCTION HERE: module.exports = function(grunt)