// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/internal;
import ballerina/encoding;

function addMapToJson(json inJson, map<any> mapToConvert) returns (json) {
    if (mapToConvert.length() != 0) {
        foreach var key in mapToConvert.keys() {
            var customClaims = mapToConvert[key];
            if (customClaims is string[]) {
                inJson[key] = convertStringArrayToJson(customClaims);
            } else if (customClaims is int[]) {
                inJson[key] = convertIntArrayToJson(customClaims);
            } else if (customClaims is string) {
                inJson[key] = customClaims;
            } else if (customClaims is int) {
                inJson[key] = customClaims;
            } else if (customClaims is boolean) {
                inJson[key] = customClaims;
            }
        }
    }
    return inJson;
}

function convertStringArrayToJson(string[] arrayToConvert) returns (json) {
    json jsonPayload = [];
    int i = 0;
    while (i < arrayToConvert.length()) {
        jsonPayload[i] = arrayToConvert[i];
        i = i + 1;
    }
    return jsonPayload;
}

function convertIntArrayToJson(int[] arrayToConvert) returns (json) {
    json jsonPayload = [];
    int i = 0;
    while (i < arrayToConvert.length()) {
        jsonPayload[i] = arrayToConvert[i];
        i = i + 1;
    }
    return jsonPayload;
}

function validateMandatoryFields(internal:JwtPayload jwtPayload) returns (boolean) {
    if (jwtPayload.iss == "" || jwtPayload.sub == "" || jwtPayload.exp == 0 || jwtPayload.aud.length() == 0) {
        return false;
    }
    return true;
}

function validateMandatoryJwtHeaderFields(internal:JwtHeader jwtHeader) returns (boolean) {
    if (jwtHeader.alg == "") {
        return false;
    }
    return true;
}

function encodeBase64Url(byte[] valueToEncode) returns string {
    string encodedString = encoding:encodeBase64(valueToEncode);
    encodedString = encodedString.replaceAll("[+]+", "-");
    encodedString = encodedString.replaceAll("/", "_");
    return encodedString;
}