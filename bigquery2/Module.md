Connects to Bigquery from Ballerina.

# Module Overview

The Bigquery connector allows you to access and run queries on the Bigquery through the Bigquery REST API.

**Bigquery Operations**

The `wso2/bigquery2` module contains operations that retrieve projects, tables, and datasets. And also it allows you to run the queries.

## Compatibility

|                             |       Version               |
|:---------------------------:|:---------------------------:|
| Ballerina Language          | 0.990.3                     |
| Bigquery API Version        | V2                          |

## Sample

Import the `wso2/bigquery2` module into the Ballerina project.

```ballerina
import wso2/bigquery2;
```

Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for BasicAuth and OAuth 2.0. Bigquery uses OAuth 2.0 to authenticate and authorize requests. The Bigquery connector can be minimally instantiated in the HTTP client config using the access token or the client ID, client secret, and refresh token.


### Obtaining Tokens to Run the Sample

1. Visit Google API Console, click Create Project, and follow the wizard to create a new project.
2. Go to Credentials -> OAuth consent screen, enter a product name to be shown to users, and click Save.
3. On the Credentials tab, click Create credentials and select OAuth client ID.
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use OAuth 2.0 playground to receive the authorization code and obtain the access token and refresh token).
5. Click Create. Your client ID and client secret appear.
6. In a separate browser window or tab, visit OAuth 2.0 playground, select the required Bigquery scopes, and then click Authorize APIs.
7. When you receive your authorization code, click Exchange authorization code for tokens to obtain the refresh token and access token.

You can now enter the credentials in the HTTP client config:
```ballerina

bigquery2:BigqueryConfiguration bigqueryConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            config: {
                accessToken: testAccessToken,
                clientId: testClientId,
                clientSecret: testClientSecret,
                refreshToken: testRefreshToken,
                refreshUrl: REFRESH_URL
            }
        }
    }
};

bigquery2:Client bigqueryClient = new(bigqueryConfig);
```


The `listProjects` remote function lists all projects to which current user have been granted any project role.
```ballerina
// List projects.
var listProjectResponse = bigqueryClient->listProjects();
```

The response from `listProjects` is a `ProjectList` object if the request was successful or an `error` on failure.

```ballerina
    if (listProjectResponse is bigquery2:ProjectList) {
        io:print("Projects: ", listProjectResponse);
    } else {
        // Print the error.
        io:println("Error: ", listProjectResponse);
    }
```


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
            config: {
                accessToken: config:getAsString("ACCESS_TOKEN"),
                clientId: config:getAsString("CLIENT_ID"),
                clientSecret: config:getAsString("CLIENT_SECRET"),
                refreshToken: config:getAsString("REFRESH_TOKEN"),
                refreshUrl: REFRESH_URL
            }
        }
    }
};

// Create the Bigquery client.
bigquery2:Client bigqueryClient = new(bigqueryConfig);

public function main() {

    // Invoke the listProjects remote function to list the projects.
    var listProjectsResponse = bigqueryClient->listProjects();
    if (listProjectsResponse is bigquery2:ProjectList) {
        io:println("Projects: ", listProjectsResponse);
    } else {
        io:println("Error: ", listProjectsResponse);
    }

    // Get query result.
    var queryResults = bigqueryClient->getQueryResults("bigqueryproject-1121", "job_YtVh7jROzMs_KkTwJE5ggmM7WuEi");
    if (queryResults is bigquery2:QueryResults) {
        io:println("Query Result: ", queryResults);
    } else {
        io:println("Error: ", queryResults);
    }
}
```