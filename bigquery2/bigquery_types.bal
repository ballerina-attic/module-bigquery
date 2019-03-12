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

public type QueryResults record {
    Field[] fields = [];
    string projectId = "";
    string jobId = "";
    string location?;
    boolean jobComplete?;
    TableData tableData?;
};

public type Field record {
    string name = "";
    string ^"type"?;
    string mode?;
    string description?;
};

public type TableData record {
    string nextPageToken?;
    int totalRows = 0;
    json[] rows = [];
};

public type ProjectList record {
    string nextPageToken?;
    int totalItems = 0;
    Project[] projects = [];
};

public type Project record {
    string id = "";
    float numericId?;
    string projectId = "";
    string friendlyName?;
};

public type Dataset record {
    string id = "";
    string location?;
    string datasetId = "";
    string projectId = "";
    int creationTime?;
    int lastModifiedTime?;
    string description?;
};

public type DatasetList record {
    string nextPageToken?;
    Dataset[] datasets = [];
};

public type InsertRequestData record {
    string insertId = "";
    json jsonData = {};
};

public type TableList record {
    string nextPageToken?;
    Table[] tables = [];
    int totalItems = 0;
};

public type Table record {
    string id = "";
    string tableId = "";
    string datasetId = "";
    string projectId = "";
    string description?;
    string ^"type" = "";
    int creationTime?;
    int expirationTime?;
    int lastModifiedTime?;
    Field[] fields?;
};

public type InsertTableData record {
    string kind = "";
    InsertError[] insertErrors = [];
};

public type InsertError record {
    int index = 0;
    Error[] errors = [];
};

public type Error record {
    string reason = "";
    string location = "";
    string debugInfo = "";
    string message = "";
};
