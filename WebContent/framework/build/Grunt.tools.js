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

	return {

		getFrameworkPath: function(component,sub,rootOverride) {
			var subPath = '/';
			if (typeof sub !== 'undefined') { subPath  += sub + '/'; }
			var root = (typeof rootOverride !== 'undefined') ? '/' : rt;
			return '' + root + 'framework/' + component + subPath;
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
			//component is optional
			var componentDot = '';
			if (typeof component !== 'undefined') { componentDot = component + '.'; }

			switch (fileType + "|" + sourceOrDest) {
				case 'less|source':
					return '' + this.getBrandPath(brand,fileType) + 'framework.build.' + componentDot + brand + '.' + fileType;
				case 'less|dest':
					fileType = 'css'; //in this weird case you're asking for the compiled css so lets run again
					return this.getBrandFile(brand,fileType,sourceOrDest);
				case 'css|source':
					return '' + this.getBrandPath(brand,fileType) + componentDot + brand + '.' + fileType;
				case 'css|dest':
					return '' + this.getBrandPath(brand,fileType) + componentDot + brand + '.min.' + fileType;
				case 'js|source':
					return '' + this.getBrandPath(brand,fileType) + componentDot + brand + '.' + fileType;
				case 'js|dest':
					return '' + this.getBrandPath(brand,fileType) + componentDot + brand + '.min.' + fileType;
				default:
					return grunt.log.error('Invalid param combo on getBrandFile()');
			}
		},

		//For the grunt-contrib-less package, it's a config requirement to build the source file path into the JSON key of the files object reference, which means it needs a whole object built instead of passing a function as the JSON key (since that's illegal JSON).
		//Eg to achieve: { 'WebContent/brand/ctm/css/ctm.css' : [this.getBrandFile('ctm','less','source')] }
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