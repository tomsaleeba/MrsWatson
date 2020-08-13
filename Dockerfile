FROM ubuntu as build

RUN apt-get update && apt-get install -y unzip wget \
 && wget -O /vstsdk.zip "http://www.steinberg.net/sdk_downloads/vstsdk366_27_06_2016_build_61.zip" \
 && unzip /vstsdk.zip \
 && rm /vstsdk.zip

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
      clang \
      clang-format \
      cmake \
      cmake-data \
      gcc \
      g++-multilib \
      libc6-dev \
      libc6-dev-i386 \
      libx11-dev \
      ninja-build \
      wget

RUN apt-get install -y git

ADD . /src
WORKDIR /src

RUN mkdir build \
 && cd build \
 && cmake -G Ninja -D CMAKE_BUILD_TYPE= -D VERBOSE=ON -D WITH_VST_SDK=/VST3\ SDK/ .. \
 && cmake --build . --config "" \
 && ./test/mrswatsontest64 -r ../vendor/AudioTestData -m ./main/mrswatson64

FROM ubuntu as packaged
COPY --from=build /src/build/main/mrswatson64 /usr/local/bin/mrswatson
ENTRYPOINT ["/usr/local/bin/mrswatson"]
