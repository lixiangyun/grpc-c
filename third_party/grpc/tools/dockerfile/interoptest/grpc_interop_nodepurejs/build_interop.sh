#!/bin/bash
# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Builds Node interop server and client in a base image.
set -e

mkdir -p /var/local/git
git clone /var/local/jenkins/grpc-node /var/local/git/grpc-node
# clone gRPC submodules, use data from locally cloned submodules where possible
(cd /var/local/jenkins/grpc-node/ && git submodule foreach 'cd /var/local/git/grpc-node \
&& git submodule update --init --recursive --reference /var/local/jenkins/grpc-node/${name} \
${name}')

# copy service account keys if available
cp -r /var/local/jenkins/service_account $HOME || true

cd /var/local/git/grpc-node

# build Node interop client & server
npm install -g gulp
npm install
gulp js.core.install
gulp protobuf.install
gulp internal.test.install
