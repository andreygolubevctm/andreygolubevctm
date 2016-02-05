setlocal
cd ..
REM Run complete build phase from scratch and get tomcat7 running in embedded mode
call mvn -P embedded-tomcat7-run -P build-frontend -Pskip-tests -Pskip-quality -Pskip-artifacts clean package cargo:run
