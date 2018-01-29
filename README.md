# Compare The Market Web Technology Platform

The web CTM platform began life from the original Auto & General technology stack, used in budget direct web quote and sale, but has since diverged and evolved into it's own entity.

Web CTM is a Java Spring Boot application which consists of a front-end is built from a combination of Java Server Pages (JSP) and Scriptlets (Tags), [LESS](http://lesscss.org/), [Bootstrap3](http://getbootstrap.com) and CTM's custom ES5 modular JS framework (Meerkat Modules).

You can read more about the project on our confluence: [CTM Architecture](http://confluence:8090/display/CM/CtM+Architecture).

## Getting Started

If you are a new starter, you should setup your IDE. Most of us use [IntelliJ](http://confluence:8090/display/CM/Setting+Up+IntelliJ).  To get started with a web_ctm project, checkout a branch from http://gitstash/ using cli, source tree, or intellij's built in options.


## Compiling CSS and JavaScript

The platform frontend uses [Grunt](http://gruntjs.com/) with convenient methods for working with the framework. It's how we compile our code, run tests, and more. To use it, install the required dependencies as directed and then run some Grunt commands:

### Install the build chain:

From the command line:

0. You must have nodejs installed.
1. Install `grunt-cli` globally with `npm install -g grunt-cli`.
2. Navigate to src/main/javascript of your checkout, then run `npm install`. npm will look at [package.json](package.json) and automatically install the necessary local dependencies listed there.

When completed, you'll be able to run the various Grunt commands provided from the command line.

Notifications for builds, errors, task responses will be pushed through [grunt-notify](https://github.com/dylang/grunt-notify) which will show Growl Notifications on your desktop (though you'll probably need growl for windows installed).

### Available Grunt commands

#### Build - `grunt`
Run `grunt` to run tests locally and compile the CSS and JavaScript into the appropriate `/src/main/webapp/brand` subfolder (whitelabeling support) and common `src/main/webapp/framework/build` folders for other shared resourced. **Uses [recess](http://twitter.github.io/recess/) and [UglifyJS](http://lisperator.net/uglifyjs/) for compilation and minification respectively.**

#### Only compile CSS and JavaScript - `grunt build`
`grunt build` creates the `/src/main/webapp/framework/build` directory with compiled files. **Uses [recess](http://twitter.github.io/recess/) and [UglifyJS](http://lisperator.net/uglifyjs/) for compilation and minification respectively.**

#### Tests - test/javascript `grunt test`
Runs [JSHint](http://jshint.com) and [QUnit](http://qunitjs.com/) tests headlessly in [PhantomJS](http://phantomjs.org/) (used for CI).

#### Watch - `grunt watch`
This is a convenience method for watching just Less files and automatically building them whenever you save.

### Troubleshooting dependencies

Should you encounter problems with installing dependencies or running Grunt commands, As dependencies are installed locally for the project - that's going to be located in the node_modules directory which will be built inside your branches src\main\frontend directory. Deleting that, and rerunning `npm install` in that directory should solve most catastrophies. If all else fails uninstall all previous dependency versions (global and local). Then `npm install` in the root again.

## Versioning

At the moment, there's only a minor concern with versioning builds as they are purely for internal build tracking purposes or to see 'which build is released to x'. It would be prudent to develop a method to sync to the release numbering of 'week x' which is happening for 'one click deploys' at CTM. However in lieu of that i've implemented the Semantic Versioning guidelines as much as possible.

Until some common ground is required or created, releases will be numbered with the following format:
`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

## Copyright and license


Copyright 2015 Compare The Market PTY LTD, all rights reserved. Privately owned project. No Public Licence.

