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

// API urls.
const string BASE_URL = "https://www.googleapis.com";
const string REFRESH_URL = "https://www.googleapis.com/oauth2/v3/token";
const string PROJECTS_PATH = "/bigquery/v2/projects";
const string DATASETS_PATH = "/datasets";
const string TABLES_PATH = "/tables";
const string DATA_PATH = "/data";
const string QUERIES_PATH = "/queries";
const string INSERT_PATH = "/insertAll";

const string PAGE_TOKEN_PATH = "pageToken=";
const string FIELDS_PATH = "selectedFields=";
const string QUESTION_MARK = "?";
const string AND_SIGN = "&";
const string SLASH = "/";

const string TOKEN_ENDPOINT = "/oauth2/v4/token";
const string JWT_HEADER_ALGO_VALUE = "RS256";
const string JWT_HEADER_TYPE_VALUE = "JWT";
const string GRANT_TYPE_HEADER = "urn:ietf:params:oauth:grant-type:jwt-bearer";
const string SCOPE = "scope";
const string PASSWORD = "notasecret";
const string KEYALIAS = "privatekey";

public const POSITIONAL_MODE = "POSITIONAL";
public const NAMED_MODE = "NAMED";
public type ParameterMode "POSITIONAL"|"NAMED";

// Error Codes.
const BIGQUERY_ERROR_CODE = "{wso2/bigquery2}BigQueryError";

// Header parameters.
const string ALG = "alg";
const string TYP = "typ";
const string JWT = "JWT";

// Payload parameters.
const string ISS = "iss";
const string SUB = "sub";
const string AUD = "aud";
const string JTI = "jti";
const string EXP = "exp";
const string IAT = "iat";
