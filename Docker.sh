
#!/bin/sh

systemctl start docker

DOCKER_IMAGE=madmanfred/qt-webassembly:qt5.15-em1.39.7 #madmanfred/qt-webassembly:qt5.14-em1.39.7 #madmanfred/qt-webassembly:qt5.15-em1.39.10-remoteobjects
EMS_CACHE=$HOME/.emscripten_cache
SOURCE_DIR=$PWD

DOCKER_COMMAND="docker run --rm -v $EMS_CACHE:/emsdk_portable/.data/cache -v $SOURCE_DIR/:/src/ -u $(id -u):$(id -g) $DOCKER_IMAGE"

# Build
mkdir -p build
$DOCKER_COMMAND qmake -o /src/build CONFIG+=release
$DOCKER_COMMAND make -j $(grep -c ^processor /proc/cpuinfo) -C /src/build

# Remove intermediary files
rm -rf build/{moc,objects,*.cpp}

# Run the localserver and open the browser
xdg-open http://localhost:9191
ruby -run -e httpd . -p 9191
