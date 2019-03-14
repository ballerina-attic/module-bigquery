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

# Define the QueryResults.
#
# + fields - Describes the fields in a table.
# + projectId - The ID of the project containing this job.
# + jobId - The ID of the job.
# + location - The geographic location of the job.
# + jobComplete - Whether the query has completed or not.
# + tableData - Describes the data in a table.
public type QueryResults record {
    Field[] fields = [];
    string projectId = "";
    string jobId = "";
    string location?;
    boolean jobComplete?;
    TableData tableData?;
};

# Define the Field.
#
# + name - The field name.
# + type - The field data type.
# + mode - The field mode.
# + description - The field description.
public type Field record {
    string name = "";
    string ^"type"?;
    string mode?;
    string description?;
};

# Define the TableData.
#
# + nextPageToken - A token used for paging results.
# + totalRows - The total number of rows in the complete query result set.
# + rows - Rows of results.
public type TableData record {
    string nextPageToken?;
    int totalRows = 0;
    json[] rows = [];
};

# Define the ProjectList.
#
# + nextPageToken - A token to request the next page of results.
# + totalItems - The total number of projects in the list.
# + projects - List of Projects.
public type ProjectList record {
    string nextPageToken?;
    int totalItems = 0;
    Project[] projects = [];
};

# Define the Project.
#
# + id - An opaque ID of this project.
# + numericId - The numeric ID of this project.
# + projectId - ID of the project.
# + friendlyName - A descriptive name for this project.
public type Project record {
    string id = "";
    float numericId?;
    string projectId = "";
    string friendlyName?;
};

# Define the Dataset.
#
# + id - The fully-qualified unique name of the dataset in the format projectId:datasetId.
# + location - The geographic location where the dataset should reside.
# + datasetId - A unique ID for this dataset, without the project name.
# + projectId - The ID of the project containing this dataset.
# + creationTime - The time when this dataset was created, in milliseconds since the epoch.
# + lastModifiedTime - The date when this dataset or any of its tables was last modified,
# in milliseconds since the epoch.
# + description - A user-friendly description of the dataset.
public type Dataset record {
    string id = "";
    string location?;
    string datasetId = "";
    string projectId = "";
    int creationTime?;
    int lastModifiedTime?;
    string description?;
};

# Define the DatasetList.
#
# + nextPageToken - A token that can be used to request the next results page.
# + datasets - An array of the dataset resources in the project.
public type DatasetList record {
    string nextPageToken?;
    Dataset[] datasets = [];
};

# Define the InsertRequestData.
#
# + insertId - A unique ID for each row.
# + jsonData - A JSON object that contains a row of data.
public type InsertRequestData record {
    string insertId = "";
    json jsonData = {};
};

# Define the TableList.
#
# + nextPageToken - A token to request the next page of results.
# + tables - Tables in the requested dataset.
# + totalItems - The total number of tables in the dataset.
public type TableList record {
    string nextPageToken?;
    Table[] tables = [];
    int totalItems = 0;
};

# Define the Table.
#
# + id - An opaque ID of the table.
# + tableId - The ID of the table.
# + datasetId - The ID of the dataset containing this table.
# + projectId - The ID of the project containing this table.
# + description - A user-friendly description of the table.
# + type - The type of table.
# + creationTime - The time when this table was created, in milliseconds since the epoch.
# + expirationTime - The time when this table expires, in milliseconds since the epoch.
# + lastModifiedTime - The date when this tables was last modified.
# + fields - One or more fields on which data should be clustered.
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

# Define the InsertTableData.
#
# + kind - The resource type of the response.
# + insertErrors - An array of errors for rows that were not inserted.
public type InsertTableData record {
    string kind = "";
    InsertError[] insertErrors = [];
};

# Define the InsertError.
#
# + index - The index of the row that error applies to.
# + errors - Error information for the row indicated by the index property.
public type InsertError record {
    int index = 0;
    Error[] errors = [];
};

# Define the Error.
#
# + reason - A short error code that summarizes the error.
# + location - Specifies where the error occurred, if present.
# + debugInfo - Debugging information.
# + message - A human-readable description of the error.
public type Error record {
    string reason = "";
    string location = "";
    string debugInfo = "";
    string message = "";
};
