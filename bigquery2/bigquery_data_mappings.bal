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

import ballerina/file;

function convertToProjectsList(json jsonProjectList) returns ProjectList {
    ProjectList projectList = {};
    projectList.nextPageToken = jsonProjectList.nextPageToken != null ? jsonProjectList.nextPageToken.toString() : "";
    projectList.projects = jsonProjectList.projects != null ? convetToProjects(<json[]>jsonProjectList.projects) : [];
    projectList.totalItems = convertToInt(jsonProjectList.totalItems);
    return projectList;
}

function convetToProjects(json[] jsonProjects) returns Project[] {
    int i = 0;
    Project[] projects = [];
    foreach json jsonProject in jsonProjects {
        projects[i] = convetToProject(jsonProject);
        i = i + 1;
    }
    return projects;
}

function convetToProject(json jsonProject) returns Project {
    Project project = {};
    project.id = jsonProject.id.toString();
    project.numericId = convertToFloat(jsonProject.numericId.toString());
    project.projectId = jsonProject.projectReference.projectId.toString();
    project.friendlyName = jsonProject.friendlyName.toString();
    return project;
}

function convertToDatasetList(json jsonDatasetList) returns DatasetList {
    DatasetList datasetList = {};
    datasetList.nextPageToken = jsonDatasetList.nextPageToken != null ? jsonDatasetList.nextPageToken.toString() : "";
    datasetList.datasets = jsonDatasetList.datasets != null ? convertToDatasets(<json[]>jsonDatasetList.datasets) : [];
    return datasetList;
}

function convertToDatasets(json[] jsonDatasets) returns Dataset[] {
    int i = 0;
    Dataset[] datasets = [];
    foreach json jsonDataset in jsonDatasets {
        datasets[i] = convertToDataset(jsonDataset);
        i = i + 1;
    }
    return datasets;
}

function convertToDataset(json jsonDataset) returns Dataset {
    Dataset dataset = {};
    dataset.id = jsonDataset.id.toString();
    dataset.projectId = jsonDataset.datasetReference.projectId != null ?
    jsonDataset.datasetReference.projectId.toString() : "";
    dataset.datasetId = jsonDataset.datasetReference.datasetId.toString();
    dataset.creationTime = jsonDataset.creationTime != null ? convertToInt(jsonDataset.creationTime.toString()) : 0;
    dataset.lastModifiedTime = jsonDataset.lastModifiedTime != null ?
    convertToInt(jsonDataset.lastModifiedTime.toString()) : 0;
    dataset.location = jsonDataset.location != null ? jsonDataset.location.toString() : "";
    return dataset;
}

function convertToQueryResuls(json jsonQueryResults) returns QueryResults {
    QueryResults queryResults = {};
    return queryResults;
}

function convertToInt(json jsonVal) returns int {
    string stringVal = jsonVal.toString();
    if (stringVal != "") {
        var intVal = int.convert(stringVal);
        if (intVal is int) {
            return intVal;
        } else {
            error err = error(BIGQUERY_ERROR_CODE,
            { message: "Error occurred when converting " + stringVal + " to int" });
            panic err;
        }
    } else {
        return 0;
    }
}

function convertToFloat(json jsonVal) returns float {
    string stringVal = jsonVal.toString();
    if (stringVal != "") {
        var floatVal = float.convert(stringVal);
        if (floatVal is float) {
            return floatVal;
        } else {
            error err = error(BIGQUERY_ERROR_CODE,
            { message: "Error occurred when converting " + stringVal + " to float" });
            panic err;
        }
    } else {
        return 0;
    }
}

function convertToTableData(json jsonTableData) returns TableData {
    TableData tableData = {};
    tableData.nextPageToken = jsonTableData.nextPageToken != null ? jsonTableData.nextPageToken.toString() : "";
    tableData.totalRows = jsonTableData.totalRows != null ? convertToInt(jsonTableData.totalRows) : 0;
    tableData.rows = jsonTableData.rows != null ? <json[]>jsonTableData.rows : [];
    return tableData;
}

function convertToTableList(json jsonTableList) returns TableList {
    TableList tableList = {};
    tableList.nextPageToken = jsonTableList.nextPageToken != null ? jsonTableList.nextPageToken.toString() : "";
    tableList.totalRows = jsonTableList.totalRows != null ? convertToInt(jsonTableList.totalRows) : 0;
    tableList.tables = jsonTableList.tables != null ? convertToTables(<json[]>jsonTableList.tables) : [];
    return tableList;
}

function convertToTables(json[] jsonTables) returns Table[] {
    int i = 0;
    Table[] tables = [];
    foreach json jsonTable in jsonTables {
        tables[i] = convertToTable(jsonTable);
        i = i + 1;
    }
    return tables;
}

function convertToTable(json jsonTable) returns Table {
    Table tableRecord = {};
    tableRecord.id = jsonTable.id.toString();
    tableRecord.tableId = jsonTable.tableReference.tableId.toString();
    tableRecord.projectId = jsonTable.tableReference.projectId.toString();
    tableRecord.datasetId = jsonTable.tableReference.datasetId.toString();
    tableRecord.description = jsonTable.description != null ? jsonTable.description.toString() : "";
    tableRecord.^"type" = jsonTable["type"] != null ? jsonTable["type"].toString() : "";
    tableRecord.creationTime = jsonTable.creationTime != null ? convertToInt(jsonTable.creationTime.toString()) : 0;
    tableRecord.lastModifiedTime = jsonTable.lastModifiedTime != null ?
                convertToInt(jsonTable.lastModifiedTime.toString()) : 0;
    tableRecord.expirationTime = jsonTable.expirationTime != null ?
                convertToInt(jsonTable.expirationTime.toString()) : 0;
    tableRecord.fields = jsonTable.schema != null && jsonTable.schema.fields != null ?
                convertToFields(<json[]>jsonTable.schema.fields) : [];
    return tableRecord;
}

function convertToFields(json[] jsonFields) returns Field[] {
    int i = 0;
    Field[] fields = [];
    foreach json jsonField in jsonFields {
        fields[i] = convertToField(jsonField);
        i = i + 1;
    }
    return fields;
}

function convertToField(json jsonField) returns Field {
    Field field = {};
    field.name = jsonField.name.toString();
    field.^"type" = jsonField["type"] != null ? jsonField["type"].toString() : "";
    field.mode = jsonField.mode != null ? jsonField.mode.toString() : "";
    field.description = jsonField.description != null ? jsonField.description.toString() : "";
    return field;
}

function convertToQueryResults(json jsonQueryResults) returns QueryResults {
    QueryResults queryResults = {};
    queryResults.projectId = jsonQueryResults.jobReference.projectId.toString();
    queryResults.jobId = jsonQueryResults.jobReference.jobId.toString();
    queryResults.location = jsonQueryResults.jobReference.location != null
                ? jsonQueryResults.jobReference.location.toString() : "";
    queryResults.fields = jsonQueryResults.schema != null && jsonQueryResults.schema.fields != null ?
                convertToFields(<json[]>jsonQueryResults.schema.fields) : [];
    queryResults.jobComplete = jsonQueryResults.jobComplete != null ?
                boolean.convert(jsonQueryResults.jobComplete.toString()) : false;
    queryResults.tableData = convertToTableData(jsonQueryResults);
    return queryResults;
}
