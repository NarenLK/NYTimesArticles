#!/bin/sh
#
# Build script

if [ "$#" -ne 4 ]; then
  echo "ERROR: Pass all the arguments"
  echo "eg: . build.sh \"BUILD TYPE\" \"VERSION\" \"BUILD NUMBER\" \"TEAM ID\""
  exit 0
fi

BUILD_TYPE="$(tr '[:upper:]' '[:lower:]' <<<"${1}")"
VERSION="${2}"
BUILD_NUMBER="${3}"
TEAM_ID="${4}"

WORKSPACE="${PWD}"
WORKSPACE_NAME="NyTimes.xcworkspace"
TARGET_NAME="NyTimes"
INFO_PLIST_PATH="NyTimes/Info.plist"
EXPORT_OPTION_FILE_PATH="ExportOptions.plist"
OUTPUT_DESTINATION="build"
LOG_FILE="error.log"

# Add TeamID to 
plutil -replace teamID -string "${TEAM_ID}" "${EXPORT_OPTION_FILE_PATH}"

# Add build Number
plutil -replace CFBundleVersion -string "${BUILD_NUMBER}" "${INFO_PLIST_PATH}"

if [ "release" == ${BUILD_TYPE} ]
then
  BUILD_TYPE="Release"
  plutil -replace method -string app-store "${EXPORT_OPTION_FILE_PATH}"
else
  BUILD_TYPE="Debug"
  plutil -replace method -string development "${EXPORT_OPTION_FILE_PATH}"
fi

if [ -z "${VERSION}" ]
then
  VERSION="$(plutil -p "${INFO_PLIST_PATH}" | awk '/CFBundleShortVersionString/ {print substr($3, 2, length($3)-2)}')"
  VERSION="${VERSION}.$(git rev-parse --short HEAD)"
fi

# to set build version
echo "INFO: Start version update"
agvtool new-marketing-version "${VERSION}" &> "${LOG_FILE}"
return_value=$?
if [ $return_value -ne 0 ]; then
  cat "${LOG_FILE}"
  exit $return_value
else
  rm "${LOG_FILE}"
  echo "INFO: Version updated to ${VERSION}"
fi

# Install POD
echo "INFO: pod install started"
pod install &> "${LOG_FILE}"
return_value=$?
if [ $return_value -ne 0 ]; then
  cat "${LOG_FILE}"
  exit $return_value
else
  echo "INFO: pod install COMPLETE"
  rm "${LOG_FILE}"
fi

# clean target
echo "INFO: Cleaning target"
xcodebuild -scheme "${TARGET_NAME}" -configuration ${BUILD_TYPE} clean &> "${LOG_FILE}"
return_value=$?
if [ $return_value -ne 0 ]; then
  cat "${LOG_FILE}"
  exit $return_value
else
  echo "INFO: Target clean COMPLETE"
  rm "${LOG_FILE}"
fi

# build target
echo "INFO: Building Project"
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -destination generic/platform=iOS build &> "${LOG_FILE}"
return_value=$?
if [ $return_value -ne 0 ]; then
  cat "${LOG_FILE}"
  exit $return_value
else
  echo "INFO: Project build COMPLETE"
  rm "${LOG_FILE}"
fi

# create archive
echo "INFO: Creating Archive"
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -sdk iphoneos -configuration AppStoreDistribution archive -archivePath "${WORKSPACE}/${OUTPUT_DESTINATION}/${BUILD_TYPE}/${TARGET_NAME}.xcarchive" &> "${LOG_FILE}"
return_value=$?
if [ $return_value -ne 0 ]; then
  cat "${LOG_FILE}"
  exit $return_value
else
  echo "INFO: Archive created"
  rm "${LOG_FILE}"
fi

# create IPA from archive
echo "INFO: Creating IPA from Archive"
xcodebuild -exportArchive -archivePath "${WORKSPACE}/${OUTPUT_DESTINATION}/${BUILD_TYPE}/${TARGET_NAME}.xcarchive" -exportOptionsPlist "${EXPORT_OPTION_FILE_PATH}" -exportPath "${WORKSPACE}/${OUTPUT_DESTINATION}/${BUILD_TYPE}" &> "${LOG_FILE}"
return_value=$?
if [ $return_value -ne 0 ]; then
  cat "${LOG_FILE}"
  exit $return_value
else
  echo "INFO: IPA Createion Completed"
  echo "INFO: Artifactes located at ${WORKSPACE}/${OUTPUT_DESTINATION}/${BUILD_TYPE}/"
  rm "${LOG_FILE}"
fi

