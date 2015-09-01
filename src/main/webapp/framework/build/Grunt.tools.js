/**
 * PATH FUNCTIONS FOR BUILDING:
 * This is currently not brand generic, which should be looked at.
 * I think there's a way to make tasks take a variable as a param
 * for the brand, and act on an array of acceptable brand names.
 * TODO: The above will be for future work.
 */

/*
	NB: useful grunt functions:
	grunt.file.exists()
	grunt.file.isDir()
	grunt.file.isFile()
	http://gruntjs.com/api/grunt.file#file-types
*/

module.exports = function(grunt,rootOverride){

	var rt = (typeof rootOverride !== 'undefined') ? rootOverride : '';
	//TODO: LEGACY: root override in this context should not be used - grunt.file.setBase sorts this instead.

	var fs = require('fs'),
		path = require('path');

	return {

		getExternalPath: function(component,sub,rootOverride) {
			var subPath = '/';
			if (typeof sub !== 'undefined') { subPath  += sub + '/'; }
			var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
			return '' + root + 'external/' + component + subPath;
		},

		getFrameworkPath: function(component,sub,rootOverride) {
			var subPath = '/';
			if (typeof sub !== 'undefined') { subPath  += sub + '/'; }
			var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
			return '' + root + 'framework/' + component + subPath;
		},

		getAssetsPath: function(subpath,rootOverride) {
			var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
			return '' + root + 'assets/' + subpath;
		},

		componentFolderPath: "framework/modules/js/components",

		writeComponentLess: function(component, brand) {
			console.log("Creating component less for:", component, brand);
			var folderPath = "brand/" + brand + "/less/components/",
				fileName = folderPath + "framework.build." + component + "." + brand + ".less",
				fileContent = [
					"// Dynamically generated LESS file. See Grunt.tools.js.",
					"@import (reference) '../framework.build." + brand + ".less';",
					"@import '../modules/less/components/" + component + "/imports.less';"
				].join("\r\n");

			var writeFile = function() {
				fs.writeFile(fileName, fileContent, function(err) {
					if(err)
						return console.log("Could not create Component LESS: ", err);
				});
			};

			console.log("Writing file to:", fileName);
			console.log("=========================");
			fs.exists(folderPath, function(exists) {
				if(exists) {
					writeFile();
				} else {
					fs.mkdir(folderPath,function(err){
						if(!err || (err && err.code === 'EEXIST')){
							writeFile();
						} else {
							console.log("Could not create folder for Component LESS: ", err);
						}
					});
				}
			});
		},

		getComponents: function() {
			return this.getDirectories(this.componentFolderPath);
		},

		getDirectories: function(srcpath) {
			return fs.readdirSync(srcpath).filter(function(file) {
				return fs.statSync(path.join(srcpath, file)).isDirectory();
			});
		},

		getBrandPath: function(brand,filetype,rootOverride) {
			var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
			return '' + root + 'brand/' + brand + '/' + filetype + '/';
		},

		//Kills the use of the rt for source map options, and allows us to specify the context root of the path used in the tomcat serving
		relativizer: function(pathString,brandServePrefix,rootOverride) {
			var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
			if (typeof brandServePrefix === 'undefined') { brandServePrefix = ''; }
			return brandServePrefix + pathString.replace(root,'');
		},

		//Leaves only the filename from a supplied full path
		pathKiller: function(pathString) {
			return pathString.replace(/^.*(\\|\/|\:)/, '');
		},

		//This is a little insane. Forgive me. Should make sense once seen in use though!
		getBrandFile: function(brand,fileType,sourceOrDest,component) {
			var action = fileType + "|" + sourceOrDest;

			//component is optional
			var componentDot = '';
			var isComponentsModule = false;
			if (typeof component !== 'undefined') {
				if(component.match(/(components\/)/g)) {
					isComponentsModule = true;
				}

				componentDot = component + ".";
			}

			switch (action) {
				case 'less|source':
					if(isComponentsModule) {
						return '' + this.getBrandPath(brand,fileType) + 'components/framework.build.' + componentDot.replace("components/", "") + brand + '.' + fileType;
					} else {
						return '' + this.getBrandPath(brand,fileType) + 'framework.build.' + componentDot + brand + '.' + fileType;
					}
				case 'less|dest':
					fileType = 'css'; //in this weird case you're asking for the compiled css so lets run again
					return this.getBrandFile(brand,fileType,sourceOrDest,component);
				case 'css|source':
					return '' + this.getBrandPath(brand, fileType) + componentDot + brand + '.' + fileType;
				case 'css|dest':
					return '' + this.getBrandPath(brand, fileType) + componentDot + brand + '.min.' + fileType;
				case 'js|source':
					return '' + this.getBrandPath(brand, fileType) + componentDot + brand + '.' + fileType;
				case 'js|dest':
					return '' + this.getBrandPath(brand, fileType) + componentDot + brand + '.min.' + fileType;
				default:
					return grunt.log.error('Invalid param combo on getBrandFile()');
			}
		},

		//For the grunt-contrib-less package, it's a config requirement to build the source file path into the JSON key of the files object reference, which means it needs a whole object built instead of passing a function as the JSON key (since that's illegal JSON).
		//Eg to achieve: { 'src/main/webapp/brand/ctm/css/ctm.css' : [this.getBrandFile('ctm','less','source')] }
		getLessPathObj: function(brand,fileType1,sourceOrDest1,fileType2,sourceOrDest2,verticalIn) {
			//pass through vertical's lack of existance when we're not compiling vertical specific less build files.
			var vertical;
			typeof verticalIn === "undefined" ? vertical = undefined : vertical = verticalIn;

			var pathObj = {};
			pathObj['' + this.getBrandFile(brand,fileType1,sourceOrDest1,vertical)] = ['' + this.getBrandFile(brand,fileType2,sourceOrDest2,vertical)];
			//grunt.log.writeflags(pathObj);
			return pathObj;
		}

		//TODO: FIXME. LOL i think this whole function is already catered by grunt.file.expandMapping. I should read docs.
		//grunt.file.expandMapping(this.getBrandFile(brand,fileType1,sourceOrDest1,vertical), this.getBrandFile(brand,fileType2,sourceOrDest2,vertical));
	}

};