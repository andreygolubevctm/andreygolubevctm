setlocal
cd ..
REM Run specific targets to get embedded tomcat7 running asap
call mvn -P embedded-tomcat7-run compile dependency:copy@copy-deps resources:copy-resources@copy-tomcat-resources resources:copy-resources@copy-touch-restart cargo:run
