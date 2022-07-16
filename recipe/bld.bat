
mkdir build
cd build

set "LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%"

cmake -GNinja ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DBUILD_SHARED_LIBS=ON ^
    ..
if %ERRORLEVEL% neq 0 exit 1

cmake --build . --verbose --config Release -- -v -j 1
if %ERRORLEVEL% neq 0 exit 1

cmake --install . --verbose --config Release
if %ERRORLEVEL% neq 0 exit 1