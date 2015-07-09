module.exports = function(grunt,tools,brandMapping,rootOverride){
	"use strict";
	var rt = (typeof rootOverride !== 'undefined') ? rootOverride : '';
	//TODO: LEGACY: rootOverride should not be used. grunt.file.setBase sorts this instead now.


	/*|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	 *-------------------------------------------------------------------------------
	 * DYNAMICALLY GENERATED TASK REFERENCES IN GRUNT:
	 *-------------------------------------------------------------------------------
	 * This file also utilises building the dynamically named iterations of the 
	 * various tasks per vertical. This is currently being done in a way that isn't
	 * as neat as a more 'grunt-ish' solution which i hadn't yet discovered until 
	 * now. In order to continue to see progress, this shal be left for another
	 * refactor soon.
	 *-------------------------------------------------------------------------------
	 *||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	 */


	//Task objects for populating (including dynamically) and then passing to the main grunt task via the return statement
	var uglify = {},
		jshint = {},
		cssmetrics = {},
		csslint = {},
		less = {},
		clean = {},
		watch = {},
		notify = {},
		qunit = {};

	var brand = brandMapping.brandcode; //string we'll get this from the main grunt task
	var verticals = brandMapping.verticals; //Array we'll get this from the main grunt task

	tools.getComponents().forEach(function(folder) {
		tools.writeComponentLess(folder, brand);
	});

//----------------------------------------------------------------------
// UGLIFY: Takes a source and minifies it for smaller file sizes
//----------------------------------------------------------------------

	uglify.options = {	//global options
		banner: '<%= banner %>',
		sourceMapRoot: '../../../',  //Fixes insane relative root magic
		sourceMapPrefix: '1' //drops first directory from path prefix
	};

	uglify[brand+'_bootstrap'] = {
		//Explicitly defined to control what we use
		//Remember to update the brand's include of the LESS too
		src: [
			tools.getFrameworkPath('bootstrap','js') + 'transition.js',
			tools.getFrameworkPath('bootstrap','js') + 'alert.js',
			tools.getFrameworkPath('bootstrap','js') + 'button.js',
			//tools.getFrameworkPath('bootstrap','js') + 'carousel.js',
			tools.getFrameworkPath('bootstrap','js') + 'collapse.js',
			tools.getFrameworkPath('bootstrap','js') + 'dropdown.js',
			tools.getFrameworkPath('bootstrap','js') + 'modal.js',
			//tools.getFrameworkPath('bootstrap','js') + 'tooltip.js',
			//tools.getFrameworkPath('bootstrap','js') + 'popover.js',
			//tools.getFrameworkPath('bootstrap','js') + 'scrollspy.js',
			tools.getFrameworkPath('bootstrap','js') + 'tab.js',
			tools.getFrameworkPath('bootstrap','js') + 'affix.js'
		],
		dest: tools.getBrandFile(brand,'js','dest','bootstrap'),
		options: {
			sourceMap: tools.getBrandFile(brand,'js','dest','bootstrap') + '.map',
		sourceMappingURL: tools.relativizer(tools.getBrandFile(brand,'js','dest','bootstrap') + '.map','../../../')//override - fine grained control - use a function. NOTE: Fixes insane relative root magic with the ../'s
		}
	};

	uglify[brand+'_modules'] = {
		src: [
			tools.getFrameworkPath('meerkat') + '*.js', //First
			tools.getFrameworkPath('../common/','js/results/') + '*.js', //Results Library
			tools.getFrameworkPath('../common/','js/features/') + 'Features.js', //Features library
			tools.getFrameworkPath('modules','js/core') + '*.js' //General Core components

		],
		dest: tools.getBrandFile(brand,'js','dest','modules'),
		options: {
			sourceMap: tools.getBrandFile(brand,'js','dest','modules') + '.map',
			sourceMappingURL: tools.relativizer(tools.getBrandFile(brand,'js','dest','modules') + '.map','../../../')//override - fine grained control - use a function. NOTE: Fixes insane relative root magic with the ../'s
		}
	};

	//Because NXI and NXS do not yet support building minified files, and we don't want to commit them due to constant conflicts on update, these files will be built and committed too.
	uglify[brand+'_modules_notmin'] = {
		src: '<%= uglify.'+brand+'_modules.src %>',
		dest: tools.getBrandFile(brand,'js','source','modules'),
		options: {
			mangle: false,
			compress: false,
			beautify: true
		}
	};

	/*
	 * Building the dynamically named iterations of uglify task per vertical.
	 * It loops over each vertical string in the array and populates a task combination.
	 */
	//Dynamic task name creation
	verticals.forEach(function(vertical) {
		uglify[brand+'_'+vertical+'_modules'] = {
			src: [tools.getFrameworkPath('modules','js/'+vertical) + '*.js'],
			dest: tools.getBrandFile(brand,'js','dest',vertical+'.modules'),
			options: {
				sourceMap: tools.getBrandFile(brand,'js','dest',vertical+'.modules') + '.map',
				sourceMappingURL: tools.relativizer(tools.getBrandFile(vertical,'js','dest','modules.'+vertical) + '.map','../../../')//override - fine grained control - use a function. NOTE: Fixes insane relative root magic with the ../'s
			}
		};
		uglify[brand+'_'+vertical+'_modules_notmin'] = {
			src: '<%= uglify.'+brand+'_'+vertical+'_modules.src %>',
			dest: tools.getBrandFile(brand,'js','source',vertical+'.modules'),
			options: {
				mangle: false,
				compress: false,
				beautify: true
			}
		};
	});

	tools.getComponents().forEach(function(folder) {
		folder = "components_" + folder;
		var folderPath = folder.replace("_", "/");

		uglify[brand+'_'+folder+'_modules'] = {
			src: [tools.getFrameworkPath('modules','js/'+folderPath) + '*.js'],
			dest: tools.getBrandFile(brand,'js','dest',folderPath+'.modules'),
			options: {
				sourceMap: tools.getBrandFile(brand,'js','dest',folderPath+'.modules') + '.map',
				sourceMappingURL: tools.relativizer(tools.getBrandFile(folder,'js','dest','modules.'+folderPath) + '.map','../../../')//override - fine grained control - use a function. NOTE: Fixes insane relative root magic with the ../'s
			}
		};

		uglify[brand+'_'+folder+'_modules_notmin'] = {
			src: '<%= uglify.'+brand+'_'+folder+'_modules.src %>',
			dest: tools.getBrandFile(brand,'js','source',folderPath+'.modules'),
			options: {
				mangle: false,
				compress: false,
				beautify: true
			}
		};
	});



//----------------------------------------------------------------------
// JSHINT: Lets us know about JS issues and style problems.
//----------------------------------------------------------------------

	jshint.options = {
		// This file defines the standard of JSHint validation. 
		// It lives in this build folder.
		// It doesn't appear in eclipse's project explorer since it's got a . on the filename.
		jshintrc: tools.getFrameworkPath('modules','js') + '.jshintrc'
		//reporter: require('jshint-stylish'), //errors are blue and hard to read. Stick with default for now.
	};
	jshint.gruntfile = { src: '../Gruntfile.js' }; //TODO: should probably check this file too.
	jshint.meerkat = { src: [tools.getFrameworkPath('meerkat') + '*.js'] }; // Source files to JSHint
	jshint.modules = { src: [tools.getFrameworkPath('modules','js/core') + '*.js'] };
	
	//Dynamic task name creation
	verticals.forEach(function(vertical) {
		jshint['modules_'+vertical] = {
			src: [tools.getFrameworkPath('modules','js/'+vertical) + '*.js']
		}; // Source files to be JSHint validated
	});

	tools.getComponents().forEach(function(folder) {
		folder = "components_" + folder;
		jshint['modules_' + folder] = {
			src: [tools.getFrameworkPath('modules','js/' + folder.replace("_", "/")) + '*.js']
		}; // Source files to be JSHint validated
	});
	//Seriously, we don't need to check the bootstrap source too, it's done upstream.


//----------------------------------------------------------------------
// CSSMETRICS: Does simple metrics instead of the full csslint below
//----------------------------------------------------------------------

	cssmetrics.options = {
		quiet: false,
		maxSelectors: 4096,
		maxFileSize: 10240000
	};
	cssmetrics[brand] = {
		src: [tools.getBrandFile(brand,'css','dest')]
	};
	//Dynamic task name creation
	verticals.forEach(function(vertical) {
		cssmetrics[brand+'_'+vertical] = {
			src: [tools.getBrandFile(brand,'css','dest',vertical)]
		};
	});
	tools.getComponents().forEach(function(folder) {
		folder = "components_" + folder;
		cssmetrics[brand+'_'+folder] = {
			src: [tools.getBrandFile(brand,'css','dest',folder.replace("_", "/"))]
		};
	});


//----------------------------------------------------------------------
// CSSLINT: Mainly to warn us of crazy things like the IE selector limit
//----------------------------------------------------------------------

//The csslint API is a bit awkward: For each option (rule), a value of false ignores the rule, a value of 2 will set it to become an error. Otherwise all rules are considered warnings.
	
	csslint.options = {
		csslintrc: tools.getFrameworkPath('modules','less') + '.csslintrc'
	};
	csslint[brand] = {
		src: [tools.getBrandFile(brand,'css','dest')]
	};
	//Dynamic task name creation
	verticals.forEach(function(vertical) {
		csslint[brand+'_'+vertical] = {
			src: [tools.getBrandFile(brand,'css','dest',vertical)]
		};
	});
	tools.getComponents().forEach(function(folder) {
		folder = "components_" + folder;
		csslint[brand+'_'+folder] = {
			src: [tools.getBrandFile(brand,'css','dest',folder.replace("_", "/"))]
		};
	});

//----------------------------------------------------------------------
// LESS: Compile LESS to CSS
//----------------------------------------------------------------------
/**
 * Up until recently the tools we're using grunt-recess to compile LESS to CSS.
 * Since the RECESS project hasn't updated and I wanted to take advantage
 * of source maps, i've replaced grunt-recess with grunt-contrib-less.
 * grunt-contrib-less comes with LESS 1.6.0 and allows us to enable source
 * maps.
 * NOTE: Sourcemaps get their paths repaired by the replace task below!
 * You can specify multiple builds, including minification, etc.
 */

	less.options = {
		strictmath: true,
		banner: '<%= banner %>',
		paths: [
			tools.getBrandPath(brand,'less'),
			tools.getFrameworkPath('build'),
			tools.getFrameworkPath('bootstrap','less'),
			tools.getFrameworkPath('modules','less/core')
			//tools.getFrameworkPath('modules','less/'+vertical %>')
		],
		compress: true,
		sourceMap: true,
		sourceMapBasepath: rt,
		sourceMapRootpath: '../../../' //Fixes insane relative root magic
	};
	less[brand] = {
		files: tools.getLessPathObj(brand,'css','dest','less','source'),
		options: {
			sourceMapFilename: tools.getBrandFile(brand,'css','dest') + '.map'
		}
	};
	//Because NXI and NXS do not yet support building minified files, and we don't want to commit them due to constant conflicts on update, these files will be built and committed too.
	less[brand+'_notmin'] = {
		files: tools.getLessPathObj(brand,'css','source','less','source'),
		options: { compress: false, sourceMap: false }
	};

	//Dynamic task name creation
	verticals.forEach(function(vertical) {
		less[brand+'_'+vertical] = {
			files: tools.getLessPathObj(brand,'css','dest','less','source',vertical),
			options: {
				sourceMapFilename: tools.getBrandFile(brand,'css','dest',vertical) + '.map'
			}
		};
		//Because NXI and NXS do not yet support building minified files, and we don't want to commit them due to constant conflicts on update, these files will be built and committed too.
		less[brand+'_'+vertical+'_notmin'] = {
			files: tools.getLessPathObj(brand,'css','source','less','source',vertical),
			options: { compress: false, sourceMap: false }
		};
	});

	tools.getComponents().forEach(function(folder) {
		folder = "components_" + folder;

		less[brand+'_'+folder] = {
			files: tools.getLessPathObj(brand,'css','dest','less','source',folder),
			options: {
				sourceMapFilename: tools.getBrandFile(brand,'css','dest',folder) + '.map'
			}
		};
		//Because NXI and NXS do not yet support building minified files, and we don't want to commit them due to constant conflicts on update, these files will be built and committed too.
		less[brand+'_'+folder+'_notmin'] = {
			files: tools.getLessPathObj(brand,'css','source','less','source',folder.replace("_","/")),
			options: { compress: false, sourceMap: false }
		};
	});


//----------------------------------------------------------------------
// CLEAN: Nuke previous build output.
//----------------------------------------------------------------------

	clean.bootstrap = [
		'<%= uglify.'+brand+'_bootstrap.dest %>',
		'<%= uglify.'+brand+'_bootstrap.options.sourceMap %>'
	];
	clean[brand] = [
		tools.getBrandFile(brand,'css','source'),
		tools.getBrandFile(brand,'css','dest'),
		'<%= less.'+brand+'.options.sourceMapFilename %>',
		'<%= uglify.'+brand+'_modules.dest %>',
		'<%= uglify.'+brand+'_modules_notmin.dest %>',
		'<%= uglify.'+brand+'_modules.options.sourceMap %>'
	];
	verticals.forEach(function(vertical) {
		clean[brand+'_'+vertical] = [
			tools.getBrandFile(brand,'css','source',vertical),
			tools.getBrandFile(brand,'css','dest',vertical),
			'<%= less.'+brand+'_'+vertical+'.options.sourceMapFilename %>',
			'<%= uglify.'+brand+'_'+vertical+'_modules.dest %>',
			'<%= uglify.'+brand+'_'+vertical+'_modules_notmin.dest %>',
			'<%= uglify.'+brand+'_'+vertical+'_modules.options.sourceMap %>'
		];
	});
	tools.getComponents().forEach(function(folder) {
		folder = "components_" + folder;
		var folderPath = folder.replace("_", "/");

		clean[brand+'_'+folder] = [
			tools.getBrandFile(brand,'css','source',folderPath),
			tools.getBrandFile(brand,'css','dest',folderPath),
			'<%= less.'+brand+'_'+folder+'.options.sourceMapFilename %>',
			'<%= uglify.'+brand+'_'+folder+'_modules.dest %>',
			'<%= uglify.'+brand+'_'+folder+'_modules_notmin.dest %>',
			'<%= uglify.'+brand+'_'+folder+'_modules.options.sourceMap %>'
		];
	});

//----------------------------------------------------------------------
// QUNIT: Runs javascript unit tests with the help of phantomJS
//----------------------------------------------------------------------

	// Defines required options for the js unit test runner
	qunit =  {
		files: [tools.getFrameworkPath('modules','js') + 'tests/*.html'],
		options: {
			inject: tools.getFrameworkPath('bootstrap','js') + 'tests/unit/phantom.js'
		}
	};


//----------------------------------------------------------------------
// WATCH: Defines all the automatic build and watch tasks.
//----------------------------------------------------------------------

	// Uses the task options which have been applied from above.

	//JS TASKS
	watch[brand+'_bootstrap'] = {
		files: ['<%= uglify.'+brand+'_bootstrap.src %>'],
		tasks: ['build_'+brand+'_bootstrap_js']
	};
	watch[brand+'_meerkat'] = {
		files: ['<%= jshint.meerkat.src %>'],
		tasks: ['jshint:meerkat','build_'+brand+'_js']
	};
	watch[brand+'_modules'] = {
		files: ['<%= uglify.'+brand+'_modules.src %>'],
		tasks: ['jshint:modules','build_'+brand+'_js']
	};
	watch.grunt_file = {
		files: [
			'Gruntfile.js',
			tools.getFrameworkPath('modules','less') + '.csslintrc',
			tools.getFrameworkPath('modules','js') + '.jshintrc'
		],
		//tasks: ['concurrent:less_jshint_brand','concurrent:js_brand']
		tasks: ['build_'+brand+'_nowatch']
	};
	verticals.forEach(function(vertical) {
		watch[brand+'_'+vertical+'_modules'] = {
			files: ['<%= uglify.'+brand+'_'+vertical+'_modules.src %>'],
			tasks: ['jshint:modules_'+vertical,'build_'+brand+'_'+vertical+'_js']
		};
	});
	tools.getComponents().forEach(function(folder) {
		folder = "components_" + folder;

        watch[brand + "_" + folder + "_modules"] = {
			files: ['<%= uglify.' + brand + '_' + folder + '_modules.src %>'],
			tasks: ['jshint:modules_' + folder, 'build_' + brand + '_' + folder + '_js']
		};
	});

	//LESS TASKS
	watch[brand+'_less'] = {
		files: [
			tools.getBrandPath(brand,'less') + '*.less',
			tools.getFrameworkPath('build') + '*.less',
			tools.getFrameworkPath('bootstrap','less') + '*.less',
			tools.getFrameworkPath('modules','less/core') + '*.less'
		],
		//tasks: ['concurrent:less_brand']
		tasks: ['build_'+brand+'_css'] // You could run a notification here if you like
	};
	verticals.forEach(function(vertical) {
		watch[brand+'_'+vertical+'_less'] = {
			files: [
				tools.getFrameworkPath('modules','less/'+vertical) + '*.less'
			],
			//tasks: ['concurrent:less_brand']
			tasks: ['build_'+brand+'_'+vertical+'_css'] // You could run a notification here if you like
		};
	});

	tools.getComponents().forEach(function(folder) {
		var task = "components_" + folder;
		var folderPath = task.replace("_", "/");

		watch[brand+'_'+task+'_less'] = {
			files: [
				tools.getBrandPath(brand,'less') + '*.*.' + folder + '.less',
				tools.getBrandPath(brand,'less') + 'components/*.*.' + folder + '.less',
				tools.getBrandPath(brand,'less') + 'framework.build.'+brand+'.*.less',
				tools.getFrameworkPath('modules','less/' + folderPath) + '*.less'
			],
			//tasks: ['concurrent:less_brand']
			tasks: ['build_'+brand+'_'+task+'_css'] // You could run a notification here if you like
		};
	});

	//This is it's own watcher because it needs to pass the css file path not less change as a trigger to the livereload browser plugins.
	watch[brand+'_livereload_css'] = {
		files: [
			tools.getBrandPath(brand,'css') + '*.min.css'
		],
		options: {
			livereload: true
		}
	};


//----------------------------------------------------------------------------
// NOTIFY: Grunt Notify - uses growl or snarl - toast popups for grunt events
//-----------------------------------------------------------------------------

	notify.startup = {
		options: {
			title: "Asset Builder", // optional
			message: "Watching for changes..." //required
		}
	};
	notify.complete = {
		options: {
			title: "Asset Builder",
			message: "Building has completed!"
		}
	};

	//CLEAN TASKS
	notify.all_clean = {
		options: {
			title: "Clean - ALL",
			message: "Completed"
		}
	};
	notify[brand+'_clean'] = {
		options: {
			title: "Clean - "+brand,
			message: "Completed"
		}
	};

	//LESS TASKS
	notify.all_less = {
		options: {
			title: "LESS - ALL",
			message: "CSS Compiled w/ Sourcemaps + nonmin"
		}
	};
	notify[brand+'_less'] = {
		options: {
			title: "LESS - "+brand,
			message: "CSS Compiled w/ Sourcemaps"
		}
	};
	notify[brand+'_less_notmin'] = {
		options: {
			title: "LESS - "+brand,
			message: "Non minified CSS built"
		}
	};

	//JS TASKS
	notify.all_js = {
		options: {
			title: "JS Modules - ALL",
			message: "Compiled & Compressed + nonmin"
		}
	};
	notify[brand+'_js'] = {
		options: {
			title: "JS Modules - "+brand,
			message: "Compiled & Compressed"
		}
	};
	notify[brand+'_js_notmin'] = {
		options: {
			title: "JS Modules - "+brand,
			message: "Non minified JS built"
		}
	};


/********************************************************************************
 * Return dynamic grunt tasks to be loaded in the gruntfile.
 */
	return {
		pkg: grunt.file.readJSON('../package.json'),
		banner: '/*!\n'  +
				' * <%= pkg.name %> v<%= pkg.version %>\n'  +
				' * Copyright <%= grunt.template.today("yyyy") %> <%= pkg.author %>\n'  +
				' * <%= pkg.homepage %>\n'  +
				' */\n\n',
		uglify: uglify,
		jshint: jshint,
		cssmetrics: cssmetrics,
		csslint: csslint,
		less: less,
		qunit: qunit,
		clean: clean,
		watch: watch,
		notify: notify
	}
	
};


//----------------------------------------------------------------------
// Deprecated code, experimental or things to keep around:
//----------------------------------------------------------------------
	
	//shell: { tasks: [{ cmd: 'whoami' }] } //Example way to call shell commands

	/**
	 * Runs tasks in parallel threads.
	 * This unfortunately for now, just adds overhead for our 'quick' tasks.
	 * Explicit definitions give fine control on concurrency.
	 */
	/*
	concurrent: {
		jshint_all: ['jshint:gruntfile','jshint:meerkat','jshint:modules'],
		less_brand: ['less:brand','less:brand_min'],
		js_brand: ['concat:brand_meerkat_modules','uglify:brand_meerkat_modules']
		//this is a special option - only used to get the jshint happening while the less is being done too, and then we concurrent the js_brand. Efficient!
		, less_jshint_brand: ['concurrent:less_brand','concurrent:jshint_all']
	},
	*/

	/**
	 * Javascript Code style checker is awesome, but this will require a lot 
	 * of changes to make our style consistant, and we'll get to many conflicts
	 * to do this during this heavy dev.
	 * package.json entry:  "grunt-jscs-checker": "~0.4.1"
	 */
	/*
	jscs: {
		options: {
			config: tools.getFrameworkPath('bootstrap','js') + '.jscs.json',
		},
		grunt: {
			src: 'Gruntfile.js' // This file
		}//,
		//modules: {
		//	src: [
		//		tools.getFrameworkPath('modules','js/core') + '*.js',
		//		tools.getFrameworkPath('modules','js/<%= mapping.vertical %>') + '*.js'
		//	] // Source files to be JSCS validated
		//}
		//Seriously, we don't need to check the bootstrap source too, it's done.
	},
	*/

	/**
	 * Replaces texts inside files.
	 * 
	 * Used for above sourcemaps in removing the root path
	 * (conveniently documented in rt variable) which is written
	 * in the sources array in a sourcemap file while we wait for
	 * official support to remove preceding paths as per the
	 * sourceMapPrefix which uglify uses.
	 */
	/*
	replace: {
		fixLessSourceMaps: {
			src: [
				'<%= less.brand.options.sourceMapFilename %>',
				'<%= less.brand_vertical.options.sourceMapFilename %>'
			],
			overwrite: true,// overwrite matched source files
			replacements: [{
				from: rt,
				to: ''
			}]
		},
		fixJSSourceMaps: {
			src: [
				'<%= uglify.brand_bootstrap.options.sourceMap %>',
				'<%= uglify.brand_modules.options.sourceMap %>',
				'<%= uglify.brand_vertical_modules.options.sourceMap %>'
			],
			overwrite: true,// overwrite matched source files
			replacements: [{
				from: rt,
				to: ''
			}]
		}
	},
	*/


	// An example of the dynamic renaming of output based on input params
	/*
	module.exports = function(grunt) {
		grunt.loadNpmTasks('grunt-contrib-requirejs');
		var locales = ['en-us', 'fr-fr'];
		for(var i = 0; i < locales.length; i++) {
			var locale = locales[i];

			grunt.config(['requirejs', locale], {
				options: {
					mainConfigFile: 'require-config.js',
					out: locale === 'en-us' ? 'build/main.js' : 'build/main.' + locale + '.js',
					i18n: {
						locale: locale
					}
				}
			});
		}
	};
	*/

//----------------------------------------------------------------------
// No more magic to see here.
//----------------------------------------------------------------------