@echo off
SET ELM=elm make
SET PAGES=../elm-mdc-gh-pages
SET BUILD_PARAM=%~1

IF "%BUILD_PARAM%" == "" (
    SET BUILD_PARAM=build-demo
)

IF "%BUILD_PARAM%" == "docs" (
    GOTO :docs
)

IF "%BUILD_PARAM%" == "build-demo" (
    GOTO :build-demo
)

:node-modules
call npm install
GOTO :end

:material-components-web-css
xcopy node_modules\material-components-web\dist\material-components-web.css /Y /i

:elm-mdc-js
call ./node_modules/.bin/webpack
GOTO :end

:build-demo
call :node-modules
call :material-components-web-css
call :elm-mdc-js
IF NOT EXIST build (
    mkdir build
)
xcopy demo\images build\images /Y /i
copy demo\page.html build\index.html /Y
xcopy material-components-web.css build /Y
xcopy elm-mdc.js build /Y
CD demo
call %ELM% Demo.elm --output ../build/demo.js
GOTO:EOF


:docs
call %ELM% --docs=docs.json

:end
ENDLOCAL
