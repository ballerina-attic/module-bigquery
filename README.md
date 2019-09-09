[![Build Status](https://travis-ci.org/wso2-ballerina/module-bigquery.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-bigquery)

# Ballerina BigQuery Connector

The Ballerina BigQuery connector provides the capability to access and run queries on BigQuery through the BiQquery REST API.

The following sections provide you with information on how to use the Ballerina BigQuery Connector.

- [Compatibility](#compatibility)
- [Getting Started](#getting-started)
- [Sample](#sample)

## Compatibility

| Ballerina Language Version  | BigQuery API Version |
|:---------------------------:|:--------------------:|
|  1.0.0                    |   V2                 |

## Getting Started

### Prerequisites
Download and install the Ballerina [distribution](https://ballerina.io/downloads/).

### Working with BigQuery Connector
All the remote functions return valid responses or errors. If the remote function successfully completes, then the requested resource is returned. If not, an 'error' is returned.

Create a BigQuery Client endpoint to use the BigQuery Connector.
```ballerina
bigquery2:BigQueryConfiguration bigQueryConfig = {
    oauthClientConfig: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            refreshUrl: bigquery2:REFRESH_URL,
            refreshToken: config:getAsString("REFRESH_TOKEN"),
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET")
        }
    }
};

bigquery2:Client bigQueryClient = new(bigQueryConfig);
```
Then the endpoint remote function can be invoked using `var response = bigQueryClient->functionName(arguments)`. For example, **listProjects** function can be invoked as **var projectList = bigQueryClient->listProjects()**.

## Sample
```ballerina
import ballerina/config;
import ballerina/http;
import ballerina/io;
import wso2/bigquery2;

// Create the BigQuery configuration.
bigquery2:BigQueryConfiguration bigQueryConfig = {
    oauthClientConfig: {
        accessToken: config:getAsString("ACCESS_TOKEN"),
        refreshConfig: {
            refreshUrl: bigquery2:REFRESH_URL,
            refreshToken: config:getAsString("REFRESH_TOKEN"),
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET")
        }
    }
};

// Create the BigQuery client.
bigquery2:Client bigQueryClient = new(bigQueryConfig);

public function main() {

    // Invoke the listProjects remote function to list the projects.
    var listProjectsResponse = bigQueryClient->listProjects();
    if (listProjectsResponse is bigquery2:ProjectList) {
        io:print("Projects: ", listProjectsResponse);
    } else {
        // Print the error.
        io:println("Error: ", listProjectsResponse);
    }
}
```

## Contributing to Ballerina BigQuery Connector
Clone the repository by running the following command:
`git clone https://github.com/wso2-ballerina/module-bigquery.git`