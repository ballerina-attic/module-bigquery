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

# Define the QueryResults object which contains the results of the run a BigQuery SQL query operation.
#
# + fields - The fields in a table
# + projectId - The ID of the project containing this job
# + jobId - The ID of the job
# + location - The geographic location of the job
# + jobComplete - Whether the query has completed or not
# + tableData - The data in a table. It is used to return a slice of rows from a specified table. Each row is
# actually a Tabledata resource
# + errors - A collection of error objects
public type QueryResults record {
    Field[] fields = [];
    string projectId = "";
    string jobId = "";
    string location?;
    boolean jobComplete?;
    TableData tableData?;
    Error[] errors = [];
};

# Define the Field object. It describes the fields in a table.
#
# + name - The field name
# + type - The field data type
# + mode - The field mode
# + description - The field description
public type Field record {
    string name = "";
    string ^"type"?;
    string mode?;
    string description?;
};

# Define the TableData object. It describes the data in a table.
#
# + nextPageToken - A token used for paging results
# + totalRows - The total number of rows in the complete query result set
# + rows - Rows of results
public type TableData record {
    string nextPageToken?;
    int totalRows = 0;
    json[] rows = [];
};

# Define the ProjectList object. It contains all projects to which you have been granted any project role.
#
# + nextPageToken - A token to request the next page of results
# + totalItems - The total number of projects in the list
# + projects - List of Projects
public type ProjectList record {
    string nextPageToken?;
    int totalItems = 0;
    Project[] projects = [];
};

# Define the Project object to which you have at least READ access.
#
# + id - An opaque ID of this project
# + numericId - The numeric ID of this project
# + projectId - ID of the project
# + friendlyName - A descriptive name for this project
public type Project record {
    string id = "";
    float numericId?;
    string projectId = "";
    string friendlyName?;
};

# Define the Dataset. It is the dataset resource in the project.
#
# + id - The fully-qualified unique name of the dataset in the format projectId:datasetId
# + location - The geographic location where the dataset should reside
# + datasetId - A unique ID for this dataset, without the project name
# + projectId - The ID of the project containing this dataset
# + creationTime - The time when this dataset was created, in milliseconds since the epoch
# + lastModifiedTime - The date when this dataset or any of its tables was last modified,
# in milliseconds since the epoch
# + description - A user-friendly description of the dataset
public type Dataset record {
    string id = "";
    string location?;
    string datasetId = "";
    string projectId = "";
    int creationTime?;
    int lastModifiedTime?;
    string description?;
};

# Define the DatasetList object. Contains all datasets in the specified project to which you have been granted the READER
# dataset role.
#
# + nextPageToken - A token that can be used to request the next results page
# + datasets - An array of the dataset resources in the project
public type DatasetList record {
    string nextPageToken?;
    Dataset[] datasets = [];
};

# Define the InsertRequestData object. Contains input parameters to insertAll table data.
#
# + insertId - A unique ID for each row
# + jsonData - A JSON object that contains a row of data
public type InsertRequestData record {
    string insertId = "";
    json jsonData = {};
};

# Define the TableList object. Contains all tables in the specified dataset.
#
# + nextPageToken - A token to request the next page of results
# + tables - Tables in the requested dataset
# + totalItems - The total number of tables in the dataset
public type TableList record {
    string nextPageToken?;
    Table[] tables = [];
    int totalItems = 0;
};

# Define the Table object. Represent the Table in the requested dataset.
#
# + id - An opaque ID of the table
# + tableId - The ID of the table
# + datasetId - The ID of the dataset containing this table
# + projectId - The ID of the project containing this table
# + description - A user-friendly description of the table
# + type - The type of table
# + creationTime - The time when this table was created, in milliseconds since the epoch
# + expirationTime - The time when this table expires, in milliseconds since the epoch
# + lastModifiedTime - The date when this tables was last modified
# + fields - One or more fields on which data should be clustered
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

# Define the InsertTableData object. Represent the response of insertAll table data.
#
# + kind - The resource type of the response
# + insertErrors - An array of errors for rows that were not inserted
public type InsertTableData record {
    string kind = "";
    InsertError[] insertErrors = [];
};

# Define the InsertError object. Error information for the row that were not inserted.
#
# + index - The index of the row that error applies to
# + errors - Error information for the row indicated by the index property
public type InsertError record {
    int index = 0;
    Error[] errors = [];
};

# Define the Error object. Represent error information.
#
# + reason - A short error code that summarizes the error
# + location - Specifies where the error occurred, if present
# + debugInfo - Debugging information
# + message - A human-readable description of the error
public type Error record {
    string reason = "";
    string location = "";
    string debugInfo = "";
    string message = "";
};
