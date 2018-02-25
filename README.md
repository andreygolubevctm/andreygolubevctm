# Compare The Market Web Technology Platform (WebCTM)

![Compare The Market](https://i.imgur.com/AprqyZd.png "Compare The Market Logo")

The WebCTM platform began life from the original Auto & General technology stack, used in budget direct web quote and sale, but has since diverged and evolved into it's own entity.

WebCTM is a Java Spring Boot application which consists of a front-end is built from a combination of Java Server Pages (JSP) and Scriptlets (Tags), [LESS](http://lesscss.org/), [Bootstrap3](http://getbootstrap.com) and CTM's custom ES5 modular JS framework (Meerkat Modules). Some Java Back-end code still exists in the project but majority of core vertical services have been moved into their own Java micro services. See [CTM Architecture](http://confluence:8090/display/CM/CtM+Architecture) and [Microservices overview](http://confluence:8090/display/CM/Microservices+overview) for more details on CTM's Architecture and the various micros services used within CTM.

The Insurance verticals currently using WebCTM include:
* [Health](https://secure.comparethemarket.com.au/ctm/health_quote_v4.jsp)
* [Simples (Health Internal Call Centre Application)](https://secure.comparethemarket.com.au/ctm/simples.jsp) (Currently been migrated to Everest Project)
* [Travel](https://secure.comparethemarket.com.au/ctm/travel_quote.jsp)
* [Car](https://secure.comparethemarket.com.au/ctm/car_quote.jsp) (Currently been migrated to Everest Project)
* [Fuel](https://secure.comparethemarket.com.au/ctm/fuel_quote.jsp)
* [Roadside](https://secure.comparethemarket.com.au/ctm/roadside_quote.jsp)
* [Life](https://secure.comparethemarket.com.au/ctm/life_quote.jsp)
* [Income](https://secure.comparethemarket.com.au/ctm/ip_quote.jsp)
* [Homeloan](https://secure.comparethemarket.com.au/ctm/homeloan_quote.jsp)

## Prerequisites
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
* [Maven](https://maven.apache.org/download.cgi)
* [Tomcat](https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.65/bin/)
* [Git](https://git-scm.com/) with [Bitbucket SSH Keys](http://confluence:8090/display/CM/Setting+up+GIT+and+SourceTree+with+SSH+access+to+Bitbucket+Repositories) to pull down repositories.
* [NodeJS](https://nodejs.org/en/)
* [Gulp](https://gulpjs.com/)
* NXI (Dev) database credentials to add to your `settings.xml` for Maven. Speak to your manager if you haven't got them yet.

## Getting Started

To get started with WebCTM you will need to pull down the [WebCTM](http://bitbucket.budgetdirect.com.au/projects/CW/repos/web_ctm/browse) repository locally and setup your IDE. As this is a Java Springboot application it is recommended to use IntelliJ configured with Tomcat and Maven. We currently have a license generator for developers to activate IntelliJ.

Please follow these steps very closely for your OS to get WebCTM running on your machine successfully:

* [Setting up IntelliJ & WebCTM (Windows)](http://confluence:8090/pages/viewpage.action?pageId=42769127)
* [Setting up IntelliJ & WebCTM (Mac OS X & Ubuntu 16.04)](http://confluence:8090/pages/viewpage.action?pageId=128976322)

Once IntelliJ and WebCTM have been configured it is recommended to run the application in debug mode.

Those documents also contain troubleshooting information on resolving issues with building WebCTM.

## Compiling The Frontend

WebCTM uses [Gulp.js](https://gulpjs.com/) to compile and build the Frontend CSS and JS. Gulp compiles and watches for LESS and JS changes.

To setup and build:
1. Install the [Latest stable (LTS) NodeJS](https://nodejs.org/en/download/). You can also use [Node Version Management](https://github.com/creationix/nvm) to switch between Node versions.
2. Open your terminal and install [Gulp.js](https://gulpjs.com/) `npm install gulp-cli -g`.
3. Open your terminal in the root `web_ctm` folder of the project enter `cd src/main/pipeline`.
4. Install Project dependencies by entering `npm install`.
5. Then run `gulp --fast --disableNotify`. Always have this running when making Frontend changes. The build has finished when `Finished 'default` is displayed.

## Updating Partner Logo Sprite Sheets
Partner logos are generated with a gulp task which creates a sprite sheet from single logos and generates less. To update partmer logos:
1. Replace the existing original and retina artwork in your verticals logo src folder - `web_ctm/src/main/webapp/assets/graphics/logos/{vertical}/` using the same name. Eg. `ING.png` and `ING@2x.png`. Keep the image size the same as other images within the vertical and the retina image `@2x` needs to be twice the size.
2. Open your terminal in the root `web_ctm` folder of the project enter `cd src/main/pipeline`.
3. Run the gulp task to build sprites for the corresponding vertical eg `gulp sprite:health`.
4. Confirm that the sprite sheet and less file have been generated for the vertical and test on the frontend.

See [Logo Sprites - Web CTM](http://confluence:8090/display/CM/Logo+Sprites+-+Web+CTM) for more information.

## Environments
WebCTM has a number of build environments. When code is pushed to a feature branch and a Pull Request is opened this will trigger a feature branch being built.

* [DEV (NXI)](http://web-ctm-dev.ctm.cloud.local/launcher/)
* [UAT (NXQ)](http://nxq.secure.comparethemarket.com.au/ctm/)
* [PREPROD (PRELIVE)](https://prelive.secure.comparethemarket.com.au/ctm/)
* [PROD](https://secure.comparethemarket.com.au/ctm/)

## Copyright and license
Copyright 2018 Compare The Market PTY LTD, all rights reserved. Privately owned project. No Public Licence.
