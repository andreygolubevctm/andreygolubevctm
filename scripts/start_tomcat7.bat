setlocal
cd ..
IF NOT EXIST "target\springloaded\springloaded.jar" call mvn dependency:copy@copy-springloaded
call mvn -Pskip-tests -Pskip-quality war:exploded
set MAVEN_OPTS=-javaagent:target/springloaded/springloaded.jar -noverify -Xint
call mvn tomcat7:run@tomcat7-run