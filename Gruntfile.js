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

	//Timer just gives us some timings stats while i'm making this performance faster.
	require('time-grunt')(grunt);

	/**
	 * PATH VARIABLES FOR BUILDING:
	 * This is currently not brand generic, which should be looked at.
	 * I think there's a way to make tasks take a variable as a param
	 * for the brand, and act on an array of acceptable brand names.
	 * TODO: The above will be for future work.
	 */

	// Path Root
	var rt = 'WebContent/';
	//grunt.file.setBase(rt); //TODO: looks like i can stop having to append rt with the use of this function... investigate later.

	function getFrameworkPath(component,sub,relativeRoot) {
		var subPath = '/';
		if (typeof sub !== 'undefined') { subPath  += sub + '/'; }
		var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
		return '' + root + 'framework/' + component + subPath;
	}

	function getBrandPath(brand,filetype,relativeRoot) {
		var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
		return '' + rt + 'brand/' + brand + '/' + filetype + '/';
	}

	//Kills the use of the rt for source map options, and allows us to specify the context root of the path used in the tomcat serving
	function relativizer(pathString,brandServePrefix) {
		if (typeof brandServePrefix === 'undefined') { brandServePrefix = ''; }
		return brandServePrefix + pathString.replace(rt,'');
	}

	//Leaves only the filename from a supplied full path
	function pathKiller(pathString) {
		return pathString.replace(/^.*(\\|\/|\:)/, '');
	}

	//This is a little insane. Forgive me. Should make sense once seen in use though!
	function getBrandFile(brand,fileType,sourceOrDest,component) {
		//component is optional
		var componentDot = '';
		if (typeof component !== 'undefined') { componentDot = component + '.'; }

		switch (fileType + "|" + sourceOrDest) {
			case 'less|source':
				return '' + getBrandPath(brand,fileType) + 'framework.build.' + componentDot + brand + '.' + fileType;
			case 'less|dest':
				fileType = 'css'; //in this weird case you're asking for the compiled css so lets run again
				return getBrandFile(brand,fileType,sourceOrDest);
			case 'css|source':
				return '' + getBrandPath(brand,fileType) + componentDot + brand + '.' + fileType;
			case 'css|dest':
				return '' + getBrandPath(brand,fileType) + componentDot + brand + '.min.' + fileType;
			case 'js|source':
				return '' + getBrandPath(brand,fileType) + componentDot + brand + '.' + fileType;
			case 'js|dest':
				return '' + getBrandPath(brand,fileType) + componentDot + brand + '.min.' + fileType;
			default:
				return grunt.log.error('Invalid param combo on getBrandFile()');
		}
	}

	//For the grunt-contrib-less package, it's a config requirement to build the source file path into the JSON key of the files object reference, which means it needs a whole object built instead of passing a function as the JSON key (since that's illegal JSON).
	//Eg to achieve: { 'WebContent/brand/ctm/css/ctm.css' : [getBrandFile('ctm','less','source')] }
	function getLessPathObj(brand,fileType1,sourceOrDest1,fileType2,sourceOrDest2,verticalIn) {
		//pass through vertical's lack of existance when we're not compiling vertical specific less build files.
		var vertical;
		typeof verticalIn === "undefined" ? vertical = undefined : vertical = verticalIn;

		var pathObj = {};
		pathObj['' + getBrandFile(brand,fileType1,sourceOrDest1,vertical)] = ['' + getBrandFile(brand,fileType2,sourceOrDest2,vertical)];
		//grunt.log.writeflags(pathObj);
		return pathObj;
	}

	//TODO: FIXME. LOL i think this whole function is already catered by grunt.file.expandMapping. I should read docs.
	//grunt.file.expandMapping(getBrandFile(brand,fileType1,sourceOrDest1,vertical), getBrandFile(brand,fileType2,sourceOrDest2,vertical));

	/**
	 * GRUNT PROJECT CONFIGURATION:
	 * This specifies all the information that will be required when resolving deps,
	 * collating files, or running plugin tasks on the correct codebase.
	 * Things only get defined here, calling is done with registerTask calls at the bottom.
	 */
	grunt.initConfig({

		// Meta-data is read out from package.json and can be referred to with grunt template tags <%= pkg.thing %>
		pkg: grunt.file.readJSON('package.json'),

		// A pretty banner to add to files built
		banner: '/*!\n'  + 
				' * <%= pkg.name %> v<%= pkg.version %>\n'  + 
				' * Copyright <%= grunt.template.today("yyyy") %> <%= pkg.author %>\n'  + 
				' * <%= pkg.homepage %>\n'  + 
				' */\n\n',

		/**
		 * TASK CONFIG OPTIONS:
		 * This sets up options for all the various task utilities; aka Grunt plugins doing stuff for us.
		 * Paths are relative to this Gruntfile.js
		 */

		// Run JS Hint
		jshint: {
			options: {
				// This file defines the standard of JSHint validation. 
				// It lives in this build folder.
				// It doesn't appear in eclipse's project explorer since it's got a . on the filename.
				jshintrc: getFrameworkPath('modules','js') + '.jshintrc'
			},
			gruntfile: {
				src: 'Gruntfile.js' // This file
			},
			meerkat: {
				src: [getFrameworkPath('meerkat') + '*.js'] // Source files to be JSHint validated
			},
			modules: {
				src: [
					getFrameworkPath('modules','js/core') + '*.js',
					getFrameworkPath('modules','js/health') + '*.js'
				] // Source files to be JSHint validated
			}
			//Seriously, we don't need to check the bootstrap source too, it's done.
		},

		//Javascript Code style checker is awesome, but this will require a lot of changes to make our style consistant, and we'll get to many conflicts to do this during this heavy dev.
		//jscs: {
		//	options: {
		//		config: getFrameworkPath('bootstrap','js') + '.jscs.json',
		//	},
		//	grunt: {
		//		src: 'Gruntfile.js' // This file
		//	}//,
		//	//modules: {
		//	//	src: [
		//	//		getFrameworkPath('modules','js/core') + '*.js',
		//	//		getFrameworkPath('modules','js/health') + '*.js'
		//	//	] // Source files to be JSCS validated
		//	//}
		//	//Seriously, we don't need to check the bootstrap source too, it's done.
		//},

		//Does simple metrics instead of the full csslint below
		cssmetrics: {
			options: {
				quiet: false,
				maxSelectors: 4096,
				maxFileSize: 10240000
			},
			ctm: {
				src: [getBrandFile('ctm','css','dest')],
			},
			ctm_health: {
				src: [getBrandFile('ctm','css','dest','health')],
			}
		},

		//CSS Lint: mainly to warn us of crazy things like the IE selector limit
		//The csslint API is a bit awkward: For each option (rule), a value of false ignores the rule, a value of 2 will set it to become an error. Otherwise all rules are considered warnings.
		csslint: {
			options: {
				csslintrc: getFrameworkPath('modules','less') + '.csslintrc'
			},
			ctm: {
				src: [getBrandFile('ctm','css','dest')]
			},
			ctm_health: {
				src: [getBrandFile('ctm','css','dest','health')]
			}
		},

		// Takes a source and minifies it for smaller file sizes
		uglify: {
			options: { //global options
				banner: '<%= banner %>',
				//report: 'min',
				sourceMapRoot: '../../../',  //Fixes insane relative root magic
				sourceMapPrefix: '1' //drops first directory from path prefix
			},
			ctm_bootstrap: {
				//Explicitly defined to control what we use
				//Remember to update the brand's include of the LESS too
				src: [
					getFrameworkPath('bootstrap','js') + 'transition.js',
					getFrameworkPath('bootstrap','js') + 'alert.js',
					getFrameworkPath('bootstrap','js') + 'button.js',
					//getFrameworkPath('bootstrap','js') + 'carousel.js',
					getFrameworkPath('bootstrap','js') + 'collapse.js',
					getFrameworkPath('bootstrap','js') + 'dropdown.js',
					getFrameworkPath('bootstrap','js') + 'modal.js',
					//getFrameworkPath('bootstrap','js') + 'tooltip.js',
					//getFrameworkPath('bootstrap','js') + 'popover.js',
					//getFrameworkPath('bootstrap','js') + 'scrollspy.js',
					//getFrameworkPath('bootstrap','js') + 'tab.js',
					getFrameworkPath('bootstrap','js') + 'affix.js'
				],
				dest: getBrandFile('ctm','js','dest','bootstrap'),
				options: {
					sourceMap: getBrandFile('ctm','js','dest','bootstrap') + '.map',
					sourceMappingURL: relativizer(getBrandFile('ctm','js','dest','bootstrap') + '.map','../../../')//override - fine grained control - use a function. NOTE: Fixes insane relative root magic with the ../'s
				}
			},
			ctm_modules: {
				src: [
					getFrameworkPath('meerkat') + '*.js', //First
					getFrameworkPath('modules','js/core') + '*.js' //General Core components
				],
				dest: getBrandFile('ctm','js','dest','modules'),
				options: {
					sourceMap: getBrandFile('ctm','js','dest','modules') + '.map',
					sourceMappingURL: relativizer(getBrandFile('ctm','js','dest','modules') + '.map','../../../')//override - fine grained control - use a function. NOTE: Fixes insane relative root magic with the ../'s
				}
			},
			ctm_health_modules: {
				src: [
					getFrameworkPath('modules','js/health') + '*.js' //Vertical addons
				],
				dest: getBrandFile('ctm','js','dest','health.modules'),
				options: {
					sourceMap: getBrandFile('ctm','js','dest','health.modules') + '.map',
					sourceMappingURL: relativizer(getBrandFile('ctm','js','dest','modules.health') + '.map','../../../')//override - fine grained control - use a function. NOTE: Fixes insane relative root magic with the ../'s
				}
			},
			//Because NXI and NXS do not yet support building minified files, and we don't want to commit them due to constant conflicts on update, these files will be built and committed too.
			ctm_modules_notmin: {
				src: '<%= uglify.ctm_modules.src %>',
				dest: getBrandFile('ctm','js','source','modules'),
				options: {
					mangle: false,
					compress: false,
					beautify: true
				}
			},
			ctm_health_modules_notmin: {
				src: '<%= uglify.ctm_health_modules.src %>',
				dest: getBrandFile('ctm','js','source','health.modules'),
				options: {
					mangle: false,
					compress: false,
					beautify: true
				}
			}
		},

		/**
		 * Up until recently the tools we're using grunt-recess to compile LESS to CSS.
		 * Since the RECESS project hasn't updated and I wanted to take advantage
		 * of source maps, i've replaced grunt-recess with grunt-contrib-less.
		 * grunt-contrib-less comes with LESS 1.5.0 and allows us to enable source
		 * maps.
		 * NOTE: Sourcemaps get their paths repaired by the replace task below!
		 * You can specify multiple builds, including minification, etc.
		 */
		less: {
			options: {
				strictMath: true,
				banner: '<%= banner %>',
				paths: [
					getBrandPath('ctm','less'),
					getFrameworkPath('build'),
					getFrameworkPath('bootstrap','less'),
					getFrameworkPath('modules','less/core'),
					getFrameworkPath('modules','less/health')
				],
				compress: true,
				sourceMap: true,
				sourceMapBasepath: rt,
				sourceMapRootpath: '../../../' //Fixes insane relative root magic
			},
			ctm: {
				files: getLessPathObj('ctm','css','dest','less','source'),
				options: {
					sourceMapFilename: getBrandFile('ctm','css','dest') + '.map'
				}
			},
			ctm_health: {
				files: getLessPathObj('ctm','css','dest','less','source','health'),
				options: {
					sourceMapFilename: getBrandFile('ctm','css','dest','health') + '.map'
				}
			},
			//Because NXI and NXS do not yet support building minified files, and we don't want to commit them due to constant conflicts on update, these files will be built and committed too.
			ctm_notmin: {
				files: getLessPathObj('ctm','css','source','less','source'),
				options: { compress: false, sourceMap: false }
			},
			ctm_health_notmin: {
				files: getLessPathObj('ctm','css','source','less','source','health'),
				options: { compress: false, sourceMap: false }
			}
		},


		/**
		 * Replaces texts inside files.
		 * 
		 * Used for above sourcemaps in removing the root path
		 * (conveniently documented in rt variable) which is written
		 * in the sources array in a sourcemap file while we wait for
		 * official support to remove preceding paths as per the
		 * sourceMapPrefix which uglify uses.
		 */
		replace: {
			fixLessSourceMaps: {
				src: [
					'<%= less.ctm.options.sourceMapFilename %>',
					'<%= less.ctm_health.options.sourceMapFilename %>'
				],
				overwrite: true,// overwrite matched source files
				replacements: [{
					from: rt,
					to: ''
				}]
			},
			fixJSSourceMaps: {
				src: [
					'<%= uglify.ctm_bootstrap.options.sourceMap %>',
					'<%= uglify.ctm_modules.options.sourceMap %>',
					'<%= uglify.ctm_health_modules.options.sourceMap %>'
				],
				overwrite: true,// overwrite matched source files
				replacements: [{
					from: rt,
					to: ''
				}]
			}
		},

		// Defines required options for the js unit test runner
		// This actually runs bootstrap unit tests.
		// When we write our own, we use this kinda thing.
		// It's not part of any automatic tasks, because bootstrap isn't touched.
		qunit: {
			options: {
				inject: getFrameworkPath('bootstrap','js') + 'tests/unit/phantom.js'
			},
			files: [getFrameworkPath('bootstrap','js') + 'tests/*.html']
		},

		// Nuke previous build output.
		clean: {
			ctm: [
				getBrandFile('ctm','css','source'),
				getBrandFile('ctm','css','dest'),
				'<%= less.ctm.options.sourceMapFilename %>',
				getBrandFile('ctm','css','source','health'),
				getBrandFile('ctm','css','dest','health'),
				'<%= less.ctm_health.options.sourceMapFilename %>',
				'<%= uglify.ctm_modules.dest %>',
				'<%= uglify.ctm_modules_notmin.dest %>',
				'<%= uglify.ctm_modules.options.sourceMap %>',
				'<%= uglify.ctm_health_modules.dest %>',
				'<%= uglify.ctm_health_modules_notmin.dest %>',
				'<%= uglify.ctm_health_modules.options.sourceMap %>'
			],
			bootstrap: [
				'<%= uglify.ctm_bootstrap.dest %>',
				'<%= uglify.ctm_bootstrap.options.sourceMap %>'
			]
		},

		//Runs tasks in parallel threads.
		//This unfortunately for now, just adds overhead for our 'quick' tasks.
		/*
		concurrent: {
			//explicit definitions give fine control on concurrency
			jshint_all: ['jshint:gruntfile','jshint:meerkat','jshint:modules'],
			less_ctm: ['less:ctm','less:ctm_min'],
			js_ctm: ['concat:ctm_meerkat_modules','uglify:ctm_meerkat_modules']
			//this is a special option - only used to get the jshint happening while the less is being done too, and then we concurrent the js_ctm. Efficient!
			, less_jshint_ctm: ['concurrent:less_ctm','concurrent:jshint_all']
		},
		*/

		// Defines all the automatic build and watch tasks.
		// Uses the task options which have been applied from above.
		watch: {
			js_ctm_bootstrap: {
				files: ['<%= uglify.ctm_bootstrap.src %>'],
				//tasks: ['concurrent:jshint','concurrent:js_ctm']
				tasks: ['build-bootstrap-js']
			},
			js_meerkat_ctm: {
				files: ['<%= jshint.meerkat.src %>'],
				//tasks: ['concurrent:jshint','concurrent:js_ctm']
				tasks: ['build-js']
			},
			js_modules_ctm: {
				files: ['<%= uglify.ctm_modules.src %>'],
				//tasks: ['concurrent:jshint','concurrent:js_ctm']
				tasks: ['build-js']
			},
			js_health_modules_ctm: {
				files: ['<%= uglify.ctm_health_modules.src %>'],
				tasks: ['build-js']
			},
			less_ctm: {
				files: [
					getBrandPath('ctm','less') + '*.less',
					getFrameworkPath('build') + '*.less',
					getFrameworkPath('bootstrap','less') + '*.less',
					getFrameworkPath('modules','less/core') + '*.less',
					getFrameworkPath('modules','less/health') + '*.less'
				],
				//tasks: ['concurrent:less_ctm']
				tasks: ['build-css'] // You could run a notification here if you like
			},
			grunt_file: {
				files: [
					'Gruntfile.js',
					getFrameworkPath('modules','less') + '.csslintrc',
					getFrameworkPath('modules','js') + '.jshintrc'
				],
				//tasks: ['concurrent:less_jshint_ctm','concurrent:js_ctm']
				tasks: ['build-wo-watch']
			},
			//This is it's own watcher because it needs to pass the css file path not less change as a trigger to the livereload browser plugins.
			livereload_css: {
				files: [
					getBrandPath('ctm','css') + '*.min.css'
				],
				options: {
					livereload: true
				}
			}
		},

		// I decided to put in some manual settings for Grunt Notify - uses growl or snarl
		/*
		notify_hooks: {
			options: {
				enabled: true,
				max_jshint_notifications: 5, // maximum number of notifications from jshint output
			}
		},
		*/
		notify: {
			startup: {
				options: {
					title: "CTM Builder", // optional
					message: "Watching for changes..." //required
				}
			},
			less: {
				options: {
					title: "LESS - CTM",
					message: "CSS Compiled w/ Sourcemaps"
				}
			},
			less_notmin: {
				options: {
					title: "LESS - CTM",
					message: "Non minified CSS built"
				}
			},
			js: {
				options: {
					title: "JS Modules",
					message: "Compiled & Compressed"
				}
			},
			js_notmin: {
				options: {
					title: "JS Modules",
					message: "Non minified JS built"
				}
			},
			clean: {
				options: {
					title: "Clean",
					message: "Completed"
				}
			},
			complete: {
				options: {
					title: "CTM Builder",
					message: "Building has completed!"
				}
			}
		}

	//	shell: { tasks: [{ cmd: 'whoami' }] } //Example way to call shell commands

	}); //END OF FUNCTION HERE: grunt.initConfig

	// These plugins provide necessary functionality for above and below, and this formally brings them into play.
	grunt.loadNpmTasks('grunt-contrib-less');
	//grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-csslint'); //to tell us about IE selector limit
	//grunt.loadNpmTasks('grunt-bless'); //auto split css files over the selector limit
	grunt.loadNpmTasks('grunt-css-metrics'); //stats and metrics only
	grunt.loadNpmTasks('grunt-text-replace');
	grunt.loadNpmTasks('grunt-notify'); // Notifications. Uses growl or snarl
	grunt.loadNpmTasks('grunt-contrib-qunit');
	//grunt.loadNpmTasks('grunt-jscs-checker');
	//Time grunt is defined at the top of the file
	//grunt.loadNpmTasks('grunt-devtools');
	//"grunt-devtools": "~0.2.1" //Get output in 'Grunt Devtools' chrome extension

	//No Longer in use:
	//grunt.loadNpmTasks('grunt-sed');
	//grunt.loadNpmTasks('grunt-concurrent');


	/**
	 * Actual Task Definitions are here, after all that option definition above.
	 */

	// Test task.
	grunt.registerTask('test', ['build-wo-watch', 'qunit']);

	// JS build task.
	grunt.registerTask('build-js', 
		//['concurrent:jshint_all', 'concurrent:js_ctm','notify:js']
		['jshint:modules','uglify:ctm_modules','uglify:ctm_health_modules','replace:fixJSSourceMaps','notify:js','uglify:ctm_modules_notmin','uglify:ctm_health_modules_notmin']//,'notify:js_notmin']
	);

	// Bootstrap JS build task.
	grunt.registerTask('build-bootstrap-js', 
		//['concurrent:jshint_all', 'concurrent:js_ctm']
		['uglify:ctm_bootstrap']
	);

	// CSS build task.
	grunt.registerTask('build-css',
		//['concurrent:less_ctm','notify:less']
		['less:ctm','less:ctm_health','cssmetrics','csslint','replace:fixLessSourceMaps','notify:less','less:ctm_notmin','less:ctm_health_notmin']//,'notify:less_notmin']
	);

	// Fonts build task.
	//grunt.registerTask('build-fonts', ['copy','notify:complete']);

	// build without watch task.
	grunt.registerTask('build-wo-watch',
		//['concurrent:less_jshint_ctm', 'concurrent:js_ctm', 'notify:complete']
		['clean','notify:clean','build-css', 'build-bootstrap-js','build-js','notify:complete']
	);

	// Full build task.
	grunt.registerTask('build',
		//['concurrent:less_jshint_ctm', 'concurrent:js_ctm', 'notify:complete']
		['build-wo-watch','watch']
	);

	// Default task.
	grunt.registerTask('default', ['notify:startup','build']);

	// The docs for Grunt Notify tell me this is required if you use any options.
	//grunt.task.run('notify_hooks');

	//TODO: SEE http://gruntjs.com/api/grunt.option for when we want to start passing the brand as an option or passing dev vs production build modes.

}; //END OF FUNCTION HERE: module.exports = function(grunt)
