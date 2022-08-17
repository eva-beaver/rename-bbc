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

LOGDIR="log"
FULLLOGDIR=$LOGDIR
FILEDIR="files"
FULLFILEDIR=$FILEDIR
CACHEDIR="cache"
FULLCACHEDIR=$CACHEDIR

DIRECTORY_NAME=""
TOKEN="xxxx"
KEEPFILES=0
KEEPCACHE=0
DEBUG=0

CURRDIRECTORYNAME=""
CURRFULLFILENAME=""
CURRFILENAME=""
CURRFileExtension=""

dirScannedCnt=0
fileScannedCnt=0

items="album: .media.track[0].Album"
items+=", title: .media.track[0].Title"
items+=", track: .media.track[0].Track"
items+=", season: .media.track[0].Season"
items+=", part: .media.track[0].Part"
items+=", grouping: .media.track[0].Grouping"
items+=", trackposition: .media.track[0].Track_Position"
items+=", trackpositiontotal: .media.track[0].Track_Position_Total"
items+=", performer: .media.track[0].Performer"
items+=", genre: .media.track[0].Genre"
items+=", contenttype: .media.track[0].ContentType"
items+=", description: .media.track[0].Description"
items+=", recorded_date: .media.track[0].Recorded_Date"
items+=", tagged_date: .media.track[0].Tagged_Date"
items+=", lyrics: .media.track[0].Lyrics"
items+=", comment: .media.track[0].Comment"
items+=", longdescription: .media.track[0].extra.LongDescription"
items+=", duration: .media.track[0].Duration"
items+=", filesize:.media.track[0].FileSize"
items+=", format:.media.track[0].Format"
items+=", hdvideo:.media.track[0].extra.HDVideo"
items+=", fileextension:.media.track[0].FileExtension"
