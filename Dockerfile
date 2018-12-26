FROM ros:indigo
MAINTAINER Matt Vollrath <matt@endpoint.com>
ARG BUILD_DEBS='false'

# install system dependencies
RUN apt-get update \
 && apt-get install -y \
      curl \
      git \
      g++ \
      pep8 \
      closure-linter \
      python-catkin-lint \
      libfontconfig \
 && if [ "$BUILD_DEBS" = "true" ]; then \
  apt-get install -y \
     debhelper \
 ;fi \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get -y install nodejs \
 && rm -rf /var/lib/apt/lists/*

ENV THIS_PROJECT command_handler

ENV CATKIN_WS /catkin_ws
RUN echo '#!/bin/bash' > /ros_entrypoint.sh \
 && echo 'source $CATKIN_WS/devel/setup.bash' >> /ros_entrypoint.sh \
 && echo 'exec "$@"' >> /ros_entrypoint.sh

# Set up a catkin workspace complete with built run deps
RUN mkdir -p $CATKIN_WS/src \
 && . /opt/ros/indigo/setup.sh \
 && catkin_init_workspace $CATKIN_WS/src \
 && git clone https://github.com/EndPointCorp/appctl /tmp/appctl \
 && git clone https://github.com/EndPointCorp/lg_ros_nodes /tmp/lg_ros_nodes \
 && ln -snf /tmp/appctl $CATKIN_WS/src/ \
 && ln -snf /tmp/lg_ros_nodes/lg_common $CATKIN_WS/src/ \
 && ln -snf /tmp/lg_ros_nodes/interactivespaces_msgs $CATKIN_WS/src/ \
 && if [ "$BUILD_DEBS" = "true" ]; then \
    ln -snf /tmp/lg_ros_nodes/lg_builder $CATKIN_WS/src/ \
    && mkdir /output \
 ;fi \
 && apt-get update \
 && rosdep update \
 && rosdep install -y --from-paths $CATKIN_WS/src --ignore-src --rosdistro=indigo \
 && rm -rf /var/lib/apt/lists/*

# Install deps for this package
COPY package.xml /tmp/$THIS_PROJECT
RUN cd $CATKIN_WS \
 && . /opt/ros/indigo/setup.sh \
 && apt-get update \
 && rosdep install -y --from-paths /tmp/$THIS_PROJECT --ignore-src --rosdistro=indigo \
 && rm -rf /var/lib/apt/lists/*

# Build this package
COPY . $CATKIN_WS/src/$THIS_PROJECT
RUN cd $CATKIN_WS \
 && . /opt/ros/indigo/setup.sh \
 && catkin_make

WORKDIR $CATKIN_WS
