setlocal
cd ..
REM make sure node/npm are installed and run initial gulp post-processing
call mvn -Pbuild-frontend frontend:install-node-and-npm@node-and-npm-install frontend:npm@npm-install
cd src\main\pipeline
echo Targeting Gulp folder=%1
REM run gulp process continuosly
gulp --targetFolder=%1
REM gulp
