setlocal
cd ..
IF NOT EXIST "target\springloaded\springloaded.jar" call mvn dependency:copy@copy-springloaded
IF NOT EXIST "target\ctm-*\WEB-INF\lib" call mvn -Pskip-tests -Pskip-quality compile war:exploded
rem set MAVEN_OPTS=-javaagent:target/springloaded/springloaded.jar -noverify -Xint -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=15005
set MAVEN_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=15005
call mvn tomcat7:run@tomcat7-run
