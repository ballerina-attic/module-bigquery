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

import ballerinax/java;

function addMapToJson(map<json> inJson, map<any> mapToConvert) returns json {
    if (mapToConvert.length() != 0) {
        foreach var key in mapToConvert.keys() {
            var customClaims = mapToConvert[key];
            if (customClaims is string[]) {
                inJson[key] = <json[]>customClaims;
            } else if (customClaims is int[]) {
                inJson[key] = <json[]>customClaims;
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

function setResponseError(json jsonResponse) returns error {
    map<json> response = <map<json>>jsonResponse;
    error err = error(BIGQUERY_ERROR_CODE, message = response["error"].message.toString());
    return err;
}

function setInsertResponseError(json jsonResponse) returns error {
    map<json> response = <map<json>>jsonResponse;
    string errorMessage = "";
    if (jsonResponse.insertErrors != null) {
        errorMessage = errorMessage + "Error occured when inserting the row";
        json[] jsonErrors = <json[]>jsonResponse.insertErrors;
        foreach json jsonError in jsonErrors) {
            map<json> jsonMap = <map<json>>jsonError;
            json[] jsonArray = <json[]>jsonMap["errors"];

            map<json> jsonErr = <map<json>>jsonArray[0];
            errorMessage = errorMessage  + "index: " + jsonMap["index"].toString() + "due to "+
                jsonErr["message"].toString() + "\n";
        }
    } else {
        errorMessage = errorMessage + response["error"].message.toString();
    }

    error err = error(BIGQUERY_ERROR_CODE, message = errorMessage); 
    return err;
}

function getBoolean(string value) returns boolean {
    return getBooleanExternal(java:fromString(value));
}

function getBooleanExternal(handle value) returns boolean = @java:Method {
    name: "parseBoolean",
    class: "java.lang.Boolean"
} external;
