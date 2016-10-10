#!/bin/bash

#/
# Copyright 2016 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#/
#
set -e
set -x

if [ $# -eq 0 ]
then
    echo "Usage: ./install.sh $API_HOST $AUTH_KEY $WSK_CLI $PROVIDER_ENDPOINT"
    exit
fi

API_HOST="$1"
AUTH_KEY="$2"
WSK_CLI="$3"
PROVIDER_ENDPOINT="$4"

PACKAGE_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $PACKAGE_HOME
echo Installing Watson MQTT Package 

$WSK_CLI --apihost "$API_HOST" package create --auth "$AUTH_KEY" --shared yes -p apiHost "$API_HOST" -p provider_endpoint "$PROVIDER_ENDPOINT" mqtt-watson \
    -a description "Watson MQTT Package" \
    -a parameters '[{"name":"provider_endpoint", "required":true, "bindTime":true, "description":"Watson IoT MQTT event provider host"}]' \
    -v

$WSK_CLI --apihost "$API_HOST" action create --auth "$AUTH_KEY" --shared yes mqtt-watson/feed-action $PACKAGE_HOME/mqtt-watson/feed-action.js \
    -a feed true \
    -a description "A feed action to register to Watson IoT MQTT events meeting user specified criteria" \
    -a parameters '[{"name": "url", "required": true, "bindTime": true, "description": "Watson MQTT host URL"}, {"name": "topic", "required": true, "bindTime": true, "description": "MQTT topic to subscribe to"}, {"name": "apiKey", "required": true, "bindTime": true, "": "API key"}, {"name": "apiToken", "required": true, "bindTime": true, "": "API token"}, {"name": "client", "required": true, "bindTime": true, "": "Application client id"}]' \
    -a sampleInput '{"url": "ssl://a-123xyz.messaging.internetofthings.ibmcloud.com:8883", "topic": "iot-2/type/+/id/+/evt/+/fmt/json", "apiKey": "a-123xyz", "apiToken": "+-derpbog", "client": "a:12e45g:mqttapp"}' \
    -v