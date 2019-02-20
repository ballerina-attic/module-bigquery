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

import ballerina/http;

function setResponseError(json jsonResponse) returns error {
    error err = error(BIGQUERY_ERROR_CODE, { message: jsonResponse["error"].message.toString() });
    return err;
}

function setInsertResponseError(json jsonResponse) returns error {
    string errorMessage = "";
    if (jsonResponse.insertErrors != null) {
        errorMessage = errorMessage + "Error occoured when inserting the row";
        json[] jsonErrors = <json[]>jsonResponse.insertErrors;
        foreach json jsonError in jsonErrors) {
            json jsonErr = <json>jsonError.errors[0];
            errorMessage = errorMessage  + "index: " + jsonError.index.toString() + "due to "+
                jsonErr["message"].toString() + "\n";
        }
    } else {
        errorMessage = errorMessage + jsonResponse["error"].message.toString();
    }

    error err = error(BIGQUERY_ERROR_CODE, { message: errorMessage });
    return err;
}
