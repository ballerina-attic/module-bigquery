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
import ballerina/jwt;
import ballerina/log;
import ballerina/oauth2;
import ballerina/time;

# BigQuery Endpoint object.
#
# + bigQueryClient - BigQuery Connector client
public type Client client object {

    public http:Client bigQueryClient;

    public function __init(BigQueryConfiguration bigQueryConfig) {
        // Create OAuth2 provider.
        oauth2:OutboundOAuth2Provider oauth2Provider = new (bigQueryConfig.oauthClientConfig);
        // Create bearer auth handler using created provider.
        http:BearerAuthHandler bearerHandler = new (oauth2Provider);
        self.bigQueryClient = new (BASE_URL, {
            auth: {
                authHandler: bearerHandler
            }
        });
    }

    # Lists all projects to which current user have been granted any project role.
    #
    # + nextPageToken - Page token, returned by a previous call, to request the next page of results.
    # + return - Returns the `ProjectList` object when successful. Else, returns an error.
    public remote function listProjects(string nextPageToken = "") returns @tainted ProjectList | error {
        string listProjectsPath = PROJECTS_PATH;
        if (nextPageToken != "") {
            listProjectsPath = string `${listProjectsPath}?pageToken=${nextPageToken}`;
        }
        var httpResponse = self.bigQueryClient->get(listProjectsPath);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    ProjectList projectsList = convertToProjectsList(jsonResponse);
                    return projectsList;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }


    # Returns the dataset specified by datasetID.
    #
    # + projectId - Project ID of the requested dataset.
    # + datasetId - Dataset ID of the requested dataset.
    # + return - Returns the `Dataset` object when successful. Else, returns an error.
    public remote function getDataset(string projectId, string datasetId) returns @tainted Dataset | error {
        string getDatasetPath = string `${PROJECTS_PATH}/${projectId}/datasets/${datasetId}`;
        var httpResponse = self.bigQueryClient->get(getDatasetPath);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    Dataset dataset = convertToDataset(jsonResponse);
                    return dataset;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }


    #  Lists all datasets in the specified project to which user have been granted the READER dataset role.
    #
    # + projectId - Project ID of the requested dataset.
    # + nextPageToken - Page token, returned by a previous call, to request the next page of results.
    # + return - Returns the `DatasetList` object when successful. Else, returns an error.
    public remote function listDatasets(string projectId, string nextPageToken = "") returns @tainted DatasetList | error {
        string listDatasetPath = string `${PROJECTS_PATH}/${projectId}/datasets`;
        if (nextPageToken != "") {
            listDatasetPath = listDatasetPath + QUESTION_MARK + PAGE_TOKEN_PATH + nextPageToken;
        }
        var httpResponse = self.bigQueryClient->get(listDatasetPath);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    DatasetList datasetList = convertToDatasetList(jsonResponse);
                    return datasetList;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }

    #  Lists all tables in the specified dataset.
    #
    # + projectId - Project ID of the requested dataset.
    # + datasetId - Dataset ID of the table to read.
    # + nextPageToken - Page token, returned by a previous call, to request the next page of results.
    # + return - Returns the `TableList` object when successful. Else, returns an error.
    public remote function listTables(string projectId, string datasetId, string nextPageToken = "")
    returns @tainted TableList | error {
        string listTablesPath = string `${PROJECTS_PATH}/${projectId}/datasets/${datasetId}/tables`;
        if (nextPageToken != "") {
            listTablesPath = string `{{listTablesPath}}?pageToken={{nextPageToken}}`;
        }
        var httpResponse = self.bigQueryClient->get(listTablesPath);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    TableList tableList = convertToTableList(jsonResponse);
                    return tableList;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }

    #  Gets the specified table resource by table ID.
    #
    # + projectId - Project ID of the requested dataset.
    # + datasetId - Dataset ID of the table to read.
    # + tableId - Table ID of the table to read.
    # + selectedFields - List of fields to return.
    # + return - Returns the `TableList` object when successful. Else, returns an error.
    public remote function getTable(string projectId, string datasetId, string tableId, string... selectedFields)
    returns @tainted Table | error {
        string getTablePath = string `${PROJECTS_PATH}/${projectId}/datasets/${datasetId}/tables/${tableId}`;
        string uriParams = "";
        int index = 0;
        foreach string field in selectedFields {
            if (index == 0) {
                uriParams = field;
            } else {
                uriParams = uriParams + "," + field;
            }
            index = index + 1;
        }
        if (uriParams != "") {
            getTablePath = string `${getTablePath}?selectedFields=${uriParams}`;
        }
        var httpResponse = self.bigQueryClient->get(getTablePath);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    Table tableRes = convertToTable(<map<json>>jsonResponse);
                    return tableRes;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }

    #  Retrieves table data from a specified set of rows.
    #
    # + projectId - Project ID of the requested dataset.
    # + datasetId - Dataset ID of the table to read.
    # + tableId - Table ID of the table to read.
    # + nextPageToken - Page token, returned by a previous call, to request the next page of results.
    # + selectedFields - List of fields to return.
    # + return - Returns the `TableData` object when successful. Else, returns an error.
    public remote function listTableData(string projectId, string datasetId, string tableId, string nextPageToken = "", 
    string... selectedFields) returns @tainted TableData | error {
        string listTableDataPath = string `${PROJECTS_PATH}/${projectId}/datasets/${datasetId}/tables/${tableId}/data`;
        string uriParams = "";
        if (nextPageToken != "") {
            uriParams = uriParams + AND_SIGN + PAGE_TOKEN_PATH + nextPageToken;
        }
        int index = 0;
        string fields = "";
        foreach string field in selectedFields {
            if (index == 0) {
                fields = field;
            } else {
                fields = fields + "," + field;
            }
            index = index + 1;
        }
        if (fields != "") {
            uriParams = uriParams + AND_SIGN + FIELDS_PATH + fields;
        }
        if (uriParams != "") {
            listTableDataPath = listTableDataPath + "?" + uriParams.substring(1, uriParams.length());
        }

        var httpResponse = self.bigQueryClient->get(<@untainted>listTableDataPath);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    TableData tableData = convertToTableData(jsonResponse);
                    return tableData;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }

    #  Streams data into BigQuery one record at a time without needing to run a load job.
    #
    # + projectId - Project ID of the destination table.
    # + datasetId - Dataset ID of the destination table.
    # + tableId - Table ID of the destination table.
    # + rows - The rows to insert.
    # + templateSuffix - If specified, treats the destination table as a base template, and inserts the rows into an
    #                    instance table named "{destination}{templateSuffix}". BigQuery will manage creation of the
    #                    instance table, using the schema of the base template table.
    # + return - Returns the `InsertTableData` object when successful. Else, returns an error.
    public remote function insertAllTableData(string projectId, string datasetId, string tableId,
    InsertRequestData[] rows, string? templateSuffix = ()) returns @tainted InsertTableData | error {
        http:Request request = new;
        string insertDataPath = string `${PROJECTS_PATH}/${projectId}/datasets/${datasetId}/tables/${tableId}/insertAll`;
        map<json> jsonPayload = {kind: "bigquery#tableDataInsertAllRequest"};
        map<json>[] jsonRows = [];
        int i = 0;
        foreach InsertRequestData row in rows {
            map<json> jsonRow = {};
            jsonRow["json"] = row.jsonData;
            if (row.insertId != "") {
                jsonRow["insertId"] = row.insertId;
            }
            jsonRows[i] = jsonRow;
            i = i + 1;
        }
        jsonPayload["rows"] = jsonRows;
        if (templateSuffix is string) {
            jsonPayload["templateSuffix"] = templateSuffix;
        }
        request.setJsonPayload(<@untainted>jsonPayload);
        var httpResponse = self.bigQueryClient->post(insertDataPath, request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    return convertToInsertTableData(jsonResponse);
                } else {
                    return setInsertResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }

    #  Runs a BigQuery SQL query and returns results if the query completes within a specified timeout.
    #
    # + projectId - Project ID of the requested dataset.
    # + queryString - The query string of the query to execute which is following the BigQuery query syntax.
    # + queryParameters - Query parameters for Standard SQL queries.
    # + parameterMode - Query parameters for Standard SQL queries.
    # + return - Returns the `QueryResults` object when successful. Else, returns an error.
    public remote function runQuery(string projectId,@untainted string queryString, json queryParameters = (),
    ParameterMode parameterMode = "POSITIONAL") returns @tainted QueryResults | error {
        http:Request request = new;
        string getQueryResultsPath = string `${PROJECTS_PATH}/${projectId}/queries`;
        map<json> jsonPayload = {"kind": "bigquery#queryRequest", "query": queryString};
        if (queryParameters != ()) {
            jsonPayload["queryParameters"] = queryParameters;
            jsonPayload["useLegacySql"] = false;
            if (parameterMode == NAMED_MODE) {
                jsonPayload["parameterMode"] = NAMED_MODE;
            } else if (parameterMode == POSITIONAL_MODE) {
                jsonPayload["parameterMode"] = POSITIONAL_MODE;
            }
        }
        request.setJsonPayload(<@untainted>jsonPayload);
        var httpResponse = self.bigQueryClient->post(getQueryResultsPath, request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    QueryResults queryResults = convertToQueryResults(jsonResponse);
                    return queryResults;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }

    #  Retrieves the results of a query job.
    #
    # + projectId - Project ID of the requested dataset.
    # + jobId - Job ID of the query job.
    # + nextPageToken - Page token, returned by a previous call, to request the next page of results.
    # + return - Returns the `QueryResults` object when successful. Else, returns an error.
    public remote function getQueryResults(string projectId, string jobId, string nextPageToken = "")
    returns @tainted QueryResults | error {
        string getQueryResultsPath = string `${PROJECTS_PATH}/${projectId}/queries/${jobId}`;
        if (nextPageToken != "") {
            getQueryResultsPath = string `{{getQueryResultsPath}}?pageToken={{nextPageToken}}`;
        }
        var httpResponse = self.bigQueryClient->get(getQueryResultsPath);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    QueryResults queryResults = convertToQueryResults(jsonResponse);
                    return queryResults;
                } else {
                    return setResponseError(jsonResponse);
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE,
                message = "Error occurred while accessing the JSON payload of the response");
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = "Error occurred while invoking the REST API");
            return err;
        }
    }

    #  Get an access token from the service account.
    #
    # + keyStoreLocation - The location where the p12 key file is located.
    # + serviceAccount - The value of the service Account.
    # + scope - The scope to access the API.
    # + return - Returns the details of the access token as a JSON when successful. Else, returns an error.
    public remote function getAccessTokenFromServiceAccount(string keyStoreLocation, string serviceAccount,
    string scope) returns @tainted json | error {
        jwt:JwtHeader header = {};
        header.alg = JWT_HEADER_ALGO_VALUE;
        header.typ = JWT_HEADER_TYPE_VALUE;

        jwt:JwtPayload payload = {};
        payload.iss = serviceAccount;
        payload.aud = [BASE_URL + TOKEN_ENDPOINT];

        int iat = (time:currentTime().time / 1000) - 60;
        int exp = iat + 3600;
        payload.exp = exp;
        payload.iat = iat;

        map<string> customClaims = {};
        customClaims[SCOPE] = scope;
        payload.customClaims = customClaims;
        payload.sub = serviceAccount;

        jwt:JwtKeyStoreConfig keyStoreConfig = {
            keyAlias: KEYALIAS,
            keyPassword: PASSWORD,
            keyStore: {path: keyStoreLocation, password: PASSWORD}
        };

        string jwtToken = check jwt:issueJwt(header, payload, keyStoreConfig);
        json requestPayload = {"grant_type": GRANT_TYPE_HEADER, "assertion": jwtToken};
        http:Request request = new;
        request.setJsonPayload(requestPayload);
        var httpResponse = self.bigQueryClient->post(TOKEN_ENDPOINT, request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var jsonResponse = httpResponse.getJsonPayload();
            if (jsonResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    return jsonResponse;
                } else {
                    log:printError("ccc" + jsonResponse.toJsonString());
                    return setResponseError(jsonResponse.toString() + "ccc");
                }
            } else {
                error err = error(BIGQUERY_ERROR_CODE, message = jsonResponse.detail()?.message.toString());
                return err;
            }
        } else {
            error err = error(BIGQUERY_ERROR_CODE, message = httpResponse.detail()?.message.toString());
            return err;
        }
    }
};

# BigQueryConfiguration is used to set up the Google BigQuery configuration. In order to use
# this Connector, you need to provide the oauth2 credentials.
#
# + oauthClientConfig - OAuth client configuration.
public type BigQueryConfiguration record {
    oauth2:DirectTokenConfig oauthClientConfig;
};
