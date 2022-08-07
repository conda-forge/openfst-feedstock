@echo on

mkdir build
cd build

mkdir tmp

set "LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%"
set "TMPDIR=%SRC_DIR%\build\tmp"
set "OLDPATH=%PATH%"

cmake -GNinja ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DBUILD_SHARED_LIBS=ON ^
    -DOPENFST_BUILD_TEST=ON ^
    ..

if %ERRORLEVEL% neq 0 exit 1

cmake --build . --verbose --config Release -- -v -j %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit 1
set "PATH=%LIBRARY_PREFIX%\lib;%SRC_DIR%\build\src\lib;%SRC_DIR%\build\src\test;%PATH%"
ctest
set "PATH=%OLDPATH%"
if %ERRORLEVEL% neq 0 exit 1

cmake --install . --verbose --config Release
if %ERRORLEVEL% neq 0 exit 1
