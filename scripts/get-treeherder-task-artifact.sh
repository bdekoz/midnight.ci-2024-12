#!/usr/bin/env bash

#ISODATE=`date --iso`
ISODATE=2024-12-11

XITERATION=$MOZPERFAX/bin/moz-perf-x-extract.browsertime_iteration.exe
XURLMIN=$MOZPERFAX/bin/moz-perf-x-transform-url.exe

SITELIST=sitelist.txt

CHROMEDIR=chrome
FIREFOXDIR=firefox
mkdir $CHROMEDIR
mkdir $FIREFOXDIR

get_artifact_and_unpack() {
    PLATFORM="$1"
    TESTNAME="$2"
    BROWSER="$3"
    TASKID="$4"

    # ARTIFACT=browsertime-results.tgz
    ARTIFACT=browsertime-videos-original
    ARTIFACT_URL="https://firefox-ci-tc.services.mozilla.com/api/queue/v1/task/${TASKID}/runs/0/artifacts/public/test_info/${ARTIFACT}.tgz"

    #curl --fail --silent --show-error "${ARTIFACT_URL}" --output "$ARTIFACTF";
    wget "${ARTIFACT_URL}"
    tar xfz ${ARTIFACT}.tgz

    # find browsertime result json file
    ARTIFACT1_NAME=cold-browsertime.json
    ARTIFACT1=`find ./$ARTIFACT -type f -name $ARTIFACT1_NAME`

    URL=`cat ${ARTIFACT1} | jq -r '.[0].info.url'`
    echo "$URL" >> sitelist.txt
    URLM=`${XURLMIN} "$URL"`

    # select data files and copy/rename.
    ARTIFACT_BASE="${BROWSER}/${URLM}"

    ARTIFACT1_ONAME=${ARTIFACT_BASE}-${ARTIFACT1_NAME};
    cp ${ARTIFACT1} ./${ARTIFACT1_ONAME};

    # use it to select iteration to use for rest of extraction.
    # Note browsertime numbering starts at 0, artifact numbering starts at 1
    ITER=`$XITERATION ./${ARTIFACT1_ONAME}`
    ITER=$((ITER + 1))

    # find video file.
    ARTIFACT2_NAME=${ITER}-original.mp4
    ARTIFACT2=`find ./$ARTIFACT -type f -name $ARTIFACT2_NAME | grep cold`
    cp ${ARTIFACT2} ./${ARTIFACT_BASE}.mp4;

    # make json file with video file, iteration info
    VOFILE=${ARTIFACT_BASE}-"video.json"
    echo '{' >> $VOFILE
    str1='"file": "XXFILE",'
    echo ${str1/XXFILE/${ARTIFACT_BASE}.mp4} >> $VOFILE
    str2='"iteration": "XXITER"'
    echo ${str2/XXITER/${ITER}} >> $VOFILE
    echo "}" >> $VOFILE

    #rm -rf ${ARTIFACT} ${ARTIFACT}.tgz

    rm -rf ${ARTIFACT}
    mv ${ARTIFACT}.tgz ${ARTIFACT_BASE}-${ARTIFACT}.tgz
}


# latest platform almost-matches as of 2024-12-12

# 2024-12-11
# revision 2b2422cd05b931e4ebe38754df3ca56ce3e3dc2e
# "amarc@mozilla.com", id(486417162), push_id(1548183)
get_artifact_and_unpack "win11" "amazon" "chrome" "GOquU6R6TImHYqmnOnLAhA"
get_artifact_and_unpack "win11" "bing" "chrome" "b4CUU1UFSoqDmU81cfFwxQ"
get_artifact_and_unpack "win11" "cnn" "chrome" "aCXYDNr_QGa3uL7w0RQPjw"
get_artifact_and_unpack "win11" "fandom" "chrome" "JseHKJZ3R7i9BF8Pn5DE3Q"
get_artifact_and_unpack "win11" "gslides" "chrome" "dRRIygVRQju1jpbvMmAPgA"
get_artifact_and_unpack "win11" "instagram" "chrome" "QmXPDH7LRuGcuF2TL18jdg"
get_artifact_and_unpack "win11" "twitter" "chrome" "GcZMIRKXTPWvfj4_qpCC6g"
get_artifact_and_unpack "win11" "wikipedia" "chrome" "D7AcB7WFRQ6nPZ3eCJUfhw"
get_artifact_and_unpack "win11" "yahoo-mail" "chrome" "EK3nYflJSRWl4sVj-egNEA"

# 2024-12-11
# revision c0157231377305c8d7c22e452beff7c43fe4e9d7
# "agoloman@mozilla.com", id(486540021), push_id(1548795)
get_artifact_and_unpack "win11" "amazon" "firefox" "eM_a4US3SECL0A39m78I0A"
get_artifact_and_unpack "win11" "bing" "firefox" "aDN9Eq2QTcah5PE9i_DaJw"
get_artifact_and_unpack "win11" "cnn" "firefox" "Jg4GDO_4Q-mAjmv3iLXksQ"
get_artifact_and_unpack "win11" "fandom" "firefox" "C2jYIa6ERRqaaEsNQipkzw"
get_artifact_and_unpack "win11" "gslides" "firefox" "Yp3c1TUrSyK48eU1tPunkg"
get_artifact_and_unpack "win11" "instagram" "firefox" "azd7JTRXTzKSGPnTJ7ZiCA"
get_artifact_and_unpack "win11" "twitter" "firefox" "NmdyxwohTjCCMBk_R0-oaw"
get_artifact_and_unpack "win11" "wikipedia" "firefox" "ZfmKQ2-0Q7WENdwWy7rOag"
get_artifact_and_unpack "win11" "yahoo-mail" "firefox" "MyHCxztqT5Se__p6qoUJVA"
