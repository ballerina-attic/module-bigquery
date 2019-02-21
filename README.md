[![Build Status](https://travis-ci.org/wso2-ballerina/module-bigquery.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-bigquery)

# Ballerina Bigquery Endpoint

The Bigquery connector allows you to access and run queries on Bigquery through the Bigquery REST API.

### Compatibility

| Ballerina Language Version  | Bigquery API Version |
|:---------------------------:|:--------------------:|
|  0.990.3                    |   V2                 |

##### Prerequisites
Download the Ballerina [distribution](https://ballerina.io/downloads/).

## Working with Bigquery Endpoint remote functions
All the remote functions return valid responses or errors. If the remote function successfully completes, then the requested resource is returned. If not, an 'error' is returned.

Create a Bigquery Client endpoint to use the Bigquery Endpoint.
```ballerina
bigquery2:BigqueryConfiguration bigqueryConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            accessToken: testAccessToken,
            clientId: testClientId,
            clientSecret: testClientSecret,
            refreshToken: testRefreshToken
        }
    }
};

bigquery2:Client bigqueryClient = new(bigqueryConfig);
```
Then the endpoint remote function can be invoked using `var response = bigqueryClient->functionName(arguments)`. For example, **listProjects** function can be invoked as **var projectList = bigqueryClient->listProjects()**.

#### Sample
```ballerina
import wso2/bigquery2;

import ballerina/config;
import ballerina/http;
import ballerina/io;

// Create the Bigquery configuration.
bigquery2:BigqueryConfiguration bigqueryConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            accessToken: config:getAsString("ACCESS_TOKEN"),
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};

// Create the Bigquery client.
bigquery2:Client bigqueryClient = new(bigqueryConfig);

public function main() {

    // Invoke listProjects function to list the projects.
    var listProjectResponse = bigqueryClient->listProjects();
    if (listProjectResponse is bigquery2:ProjectList) {
        io:print("Projects: ", listProjectResponse);
    } else {
        // Print the error.
        io:println("Error: ", listProjectResponse);
    }
}
```

##### Contributing to Ballerina Bigquery Endpoint
Clone the repository by running the following command:
`git clone https://github.com/wso2-ballerina/module-bigquery.git`