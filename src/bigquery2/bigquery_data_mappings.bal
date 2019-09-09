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

function convertToProjectsList(json jsonProjectList) returns ProjectList {
    ProjectList projectList = {};
    projectList.nextPageToken = jsonProjectList.nextPageToken != null ? jsonProjectList.nextPageToken.toString() : "";
    projectList.projects = jsonProjectList.projects != null ? convetToProjects(<json[]>jsonProjectList.projects) : [];
    if (jsonProjectList.totalItems is int) {
        projectList.totalItems = <int>jsonProjectList.totalItems;
    }
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
    if (jsonProject.numericId is float) {
        project.numericId = <float>jsonProject.numericId;
    }
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
    if (jsonDataset.creationTime is int) {
        dataset.creationTime = jsonDataset.creationTime != null ? <int>jsonDataset.creationTime : 0;
    }
    if (jsonDataset.lastModifiedTime is int) {
        dataset.lastModifiedTime = jsonDataset.lastModifiedTime != null ? <int>jsonDataset.lastModifiedTime : 0;
    }
    dataset.location = jsonDataset.location != null ? jsonDataset.location.toString() : "";
    return dataset;
}

function convertToTableData(json jsonTableData) returns TableData {
    TableData tableData = {};
    tableData.nextPageToken = jsonTableData.nextPageToken != null ? jsonTableData.nextPageToken.toString() : "";
    if (jsonTableData.totalRows is int) {
        tableData.totalRows = jsonTableData.totalRows != null ? <int>jsonTableData.totalRows : 0;
    }
    tableData.rows = jsonTableData.rows != null ? <json[]>jsonTableData.rows : [];
    return tableData;
}

function convertToInsertTableData(json jsonTableData) returns InsertTableData {
    InsertTableData tableData = {};
    tableData.kind = jsonTableData.kind != null ? jsonTableData.kind.toString() : "";
    tableData.insertErrors = jsonTableData.insertErrors != null ? convertToInsertError(<json[]>jsonTableData.
        insertErrors) : [];
    return tableData;
}

function convertToInsertError(json[] jsonInsertErrors) returns InsertError[] {
    int i = 0;
    InsertError[] insertErrors = [];
    InsertError insertError = {};
    foreach json jsonInsertError in jsonInsertErrors {
        if (jsonInsertError.index is int) {
            insertError.index = jsonInsertError.index != null ? <int>jsonInsertError.index : 0;
        }
        if (jsonInsertError.errors is json[]) {
            insertError.errors = jsonInsertError.errors != null ? convertToErrors(<json[]>jsonInsertError.errors) : [];
        }
        insertErrors[i] = insertError;
        i = i + 1;
    }
    return insertErrors;
}

function convertToErrors(json[] jsonErrors) returns Error[] {
    int i = 0;
    Error[] errors = [];
    Error errorObj = {};
    foreach json jsonError in jsonErrors {
        errorObj.reason = jsonError.reason != null ? jsonError.reason.toString() : "";
        errorObj.location = jsonError.location != null ? jsonError.location.toString() : "";
        errorObj.debugInfo = jsonError.debugInfo != null ? jsonError.debugInfo.toString() : "";
        errorObj.message = jsonError.message != null ? jsonError.message.toString() : "";
        errors[i] = errorObj;
        i = i + 1;
    }
    return errors;
}

function convertToTableList(json jsonTableList) returns TableList {
    TableList tableList = {};
    tableList.nextPageToken = jsonTableList.nextPageToken != null ? jsonTableList.nextPageToken.toString() : "";
    if (jsonTableList.totalRows is int) {
        tableList["totalRows"] = jsonTableList.totalRows != null ? <int>jsonTableList.totalRows : 0;
    }
    tableList.tables = jsonTableList.tables != null ? convertToTables(<json[]>jsonTableList.tables) : [];
    return tableList;
}

function convertToTables(json[] jsonTables) returns Table[] {
    int i = 0;
    Table[] tables = [];
    foreach json jsonTable in jsonTables {
        tables[i] = convertToTable(<map<json>>jsonTable);
        i = i + 1;
    }
    return tables;
}

function convertToTable(map<json> jsonTable) returns Table {
    Table tableRecord = {};
    tableRecord.id = jsonTable.id.toString();
    tableRecord.tableId = jsonTable.tableReference.tableId.toString();
    tableRecord.projectId = jsonTable.tableReference.projectId.toString();
    tableRecord.datasetId = jsonTable.tableReference.datasetId.toString();
    tableRecord.description = jsonTable.description != null ? jsonTable.description.toString() : "";
    tableRecord.'type = jsonTable.'type != null ? jsonTable["type"].toString() : "";
    if (jsonTable.creationTime is int) {
        tableRecord.creationTime = jsonTable.creationTime != null ? <int>jsonTable.creationTime : 0;
    }
    if (jsonTable.lastModifiedTime is int) {
        tableRecord.lastModifiedTime = jsonTable.lastModifiedTime != null ? <int>jsonTable.lastModifiedTime : 0;
    }
    if (jsonTable.expirationTime is int) {
        tableRecord.expirationTime = jsonTable.expirationTime != null ? <int>jsonTable.expirationTime : 0;
    }
    if (jsonTable.schema.fields is json[]) {
        tableRecord.fields = jsonTable.schema != null && jsonTable.schema.fields != null ?
            convertToFields(<json[]>jsonTable.schema.fields) : [];
    }
    return tableRecord;
}

function convertToFields(json[] jsonFields) returns Field[] {
    int i = 0;
    Field[] fields = [];
    foreach json jsonField in jsonFields {
        fields[i] = convertToField(<map<json>>jsonField);
        i = i + 1;
    }
    return fields;
}

function convertToField(map<json> jsonField) returns Field {
    Field field = {};
    field.name = jsonField.name.toString();
    field.'type = jsonField.'type != null ? jsonField["type"].toString() : "";
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
    if (jsonQueryResults.schema.fields is json[]) {
        queryResults.fields = jsonQueryResults.schema != null && jsonQueryResults.schema.fields != null ?
            convertToFields(<json[]>jsonQueryResults.schema.fields) : [];
    }
    queryResults.jobComplete = jsonQueryResults.jobComplete != null ?
        getBoolean(jsonQueryResults.jobComplete.toString()) : false;
    queryResults.tableData = convertToTableData(jsonQueryResults);
    if (jsonQueryResults.errors is json[]) {
        queryResults.errors = jsonQueryResults.errors != null ? convertToErrors(<json[]>jsonQueryResults.errors) : [];
    }
    return queryResults;
}
