module.exports = function(grunt,brandMapping){
	"use strict";

/**---------------------------------------------------------------------------
 * TASK ALIAS DEFINITIONS:
 * Task configs are in Grunt.tasks
 */

//----------------------------------------------------------------------
// BRAND LEVEL ALIAS DEFINITIONS:
//----------------------------------------------------------------------

	for (var i = brandMapping.length - 1; i >= 0; i--) {

		var brandObj = brandMapping[i];
		var brand = brandObj.brandcode; //string we'll get from the main grunt task
		var verticals = brandObj.verticals; //array we'll get from the main grunt task

		// Bootstrap JS build task.
		grunt.registerTask('build_'+brand+'_bootstrap_js',
			['uglify:'+brand+'_bootstrap']
		);

		// CSS build task.
		grunt.registerTask('build_'+brand+'_css',
			[
				'less:'+brand,
				'cssmetrics:'+brand, /*Check the built css after less task*/
				'csslint:'+brand, /*Check the built css after less task*/
				/*Notification only after minified version*/ 'notify:'+brand+'_less',
				'less:'+brand+'_notmin'
			]
		);

		//JS build task.
		grunt.registerTask('build_'+brand+'_js',
			[
				'uglify:'+brand+'_modules',
				/*Notification only after minified version*/ 'notify:'+brand+'_js',
				'uglify:'+brand+'_modules_notmin'
			]
		);

		// --------------------------------------------
		// Vertical dependent actions, looped per brand
		// --------------------------------------------
		verticals.forEach(function(vertical) {

			// JSHint module tasks are core code - they shouldn't need to be re-run per brand, just per watch event or full build. See the build build_'+brand+'_nowatch and build_all... as well as the watch tasks in the task file.

			// Vertical JS build task.
			grunt.registerTask('build_'+brand+'_'+vertical+'_js',
				[
					'uglify:'+brand+'_'+vertical+'_modules',
					/*Notification only after minified version*/ 'notify:'+brand+'_js',
					'uglify:'+brand+'_'+vertical+'_modules_notmin'
				]
			);

			// Vertical CSS build task.
			grunt.registerTask('build_'+brand+'_css',
				[
					'less:'+brand,
					'less:'+brand+'_health',
					'cssmetrics:'+brand,
					'csslint:'+brand+'_'+vertical,
					/*Notification only after minified version*/ 'notify:'+brand+'_less',
					'less:'+brand+'_notmin',
					'less:'+brand+'_'+vertical+'_notmin'
				]
			);
		});

		// branded build without watch task.
		grunt.registerTask('build_'+brand+'_nowatch',
			[
				'clean:'+brand,
				'notify:'+brand+'_clean',
				'build_'+brand+'_css',
				'jshint',
				'build_'+brand+'_js',
				'build_'+brand+'_bootstrap_js',
				'notify:complete'
			]
		);

		// Full branded build task.
		grunt.registerTask('build_'+brand,
			[
				'build_'+brand+'_nowatch',
				'watch'
			]
		);

		// Full ALL build task.
		grunt.registerTask('build_all_nowatch',
			[
				'clean',
				'notify:all_clean',
				'less',
				'cssmetrics',
				'csslint',
				'notify:all_less',
				'jshint',
				'uglify',
				'notify:all_js',
				'notify:complete'
			]
		);

		// Full ALL build task with watching.
		grunt.registerTask('build_all', ['build_all_nowatch','watch']);

	}

//----------------------------------------------------------------------
// GLOBAL LEVEL ALIAS DEFINITIONS:
//----------------------------------------------------------------------

	// Default task.
	grunt.registerTask('default', ['build_all']);
	//grunt.registerTask('default', ['notify:startup','build']);

	// Test task.
	//grunt.registerTask('test', ['build-wo-watch', 'qunit']);

	// The docs for Grunt Notify tell me this is required if you use any options.
	//grunt.task.run('notify_hooks');

	grunt.registerTask('css_all_brands',
		[
			'less','cssmetrics','csslint','notify:all_less'
		]
	);
	grunt.registerTask('js_all_brands',
		[
			'jshint','cssmetrics','csslint','notify:all_less'
		]
	);
	
};