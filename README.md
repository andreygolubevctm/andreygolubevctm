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
* [Git](https://git-scm.com/)
* NXI (Dev) database credentials to add to your `settings.xml` for Maven. Speak to your manager if you haven't got them yet. See [Maven Settings](https://ctmaus.atlassian.net/wiki/spaces/IT/pages/28147859/Setting+up+IntelliJ+WebCTM+Mac+OS+X+Ubuntu+16.04#Maven-Settings).

## Build & Run

```
mvn -P embedded-tomcat7-run -P build-frontend -Pskip-tests -Pskip-quality -Pskip-artifacts clean package cargo:run
```

Local endpoints:

* [Health](http://localhost:8080/ctm/health_quote_v4.jsp)
* [Simples (Health Internal Call Centre Application)](http://localhost:8080/ctm/simples.jsp)
* [Travel](http://localhost:8080/ctm/travel_quote.jsp)
* [Car](http://localhost:8080/ctm/car_quote.jsp)
* [Fuel](http://localhost:8080/ctm/fuel_quote.jsp)
* [Roadside](http://localhost:8080/ctm/roadside_quote.jsp)
* [Life](http://localhost:8080/ctm/life_quote.jsp)
* [Income](http://localhost:8080/ctm/ip_quote.jsp)
* [Homeloan](http://localhost:8080/ctm/homeloan_quote.jsp)

### Frontend Only

```
mvn -P build-frontend -Pskip-tests -Pskip-quality -Pskip-artifacts
```

## Debug

Remote debugging is available via port `5005`.

### IntelliJ

Steps:

1. Select **Run** from the menu.
2. Select **Edit Configurations**
3. Click the plus (+) button
4. Select **Remote**
5. Name it 'ctm', then Save
6. Select **Run** from the menu, then select **Debug** 'ctm'

For example, see https://www.baeldung.com/intellij-remote-debugging#run-configuration

## Updating Partner Logo Sprite Sheets
Partner logos are generated with a gulp task which creates a sprite sheet from single logos and generates less. To update partmer logos:
1. Replace the existing original and retina artwork in your verticals logo src folder - `web_ctm/src/main/webapp/assets/graphics/logos/{vertical}/` using the same name. Eg. `ING.png` and `ING@2x.png`. Keep the image size the same as other images within the vertical and the retina image `@2x` needs to be twice the size.
2. Open your terminal in the root `web_ctm` folder of the project enter `cd src/main/pipeline`.
3. Run the gulp task to build sprites for the corresponding vertical eg `gulp sprite:health`.
4. Confirm that the sprite sheet and less file have been generated for the vertical and test on the frontend.

See [Logo Sprites - Web CTM](http://confluence:8090/display/CM/Logo+Sprites+-+Web+CTM) for more information.

## Environments
WebCTM has a number of build environments. When code is pushed to a feature branch and a Pull Request is opened this will trigger a feature branch being built.

* [DEV (NXI)](http://ctm-vpc-41-web-ctm-01.dev.comparethemarket.cloud/launcher/)
* [UAT (NXQ)](http://nxq.secure.comparethemarket.com.au/ctm/)
* [PREPROD (PRELIVE)](https://prelive.secure.comparethemarket.com.au/ctm/)
* [PROD](https://secure.comparethemarket.com.au/ctm/)

## Copyright and license
Copyright 2018 Compare The Market PTY LTD, all rights reserved. Privately owned project. No Public Licence.
