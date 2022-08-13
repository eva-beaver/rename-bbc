#!/usr/bin/env bash
#/*
# * Copyright 2014-2022 the original author or authors.
# *
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# */

# emojipedia.org

WORKING_DIRECTORY=$(cd $(dirname $0); pwd)
DEBUG=0

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPT_DIR_PARENT="$(dirname "$SCRIPT_DIR")"
SCRIPT_NAME=${0##*/}


LOGDIR="./log"
FILEDIR="./files"
CACHE="./cache"

dirScannedCnt=0
fileScannedCnt=0