Connects to Bigquery from Ballerina.

# Module Overview

The BigQuery connector provides the capability to access and run queries on BigQuery through the BigQuery REST API.

## BigQuery Operations

The `wso2/bigquery2` module contains operations to retrieve projects, tables, and datasets. It also allows you to run the queries.

## Compatibility

| Ballerina Language Version  | BigQuery API Version |
|:---------------------------:|:--------------------:|
|  1.0.0                    |   V2                 |

## Sample

Import the `wso2/bigquery2` module into the Ballerina project.

```ballerina
import wso2/bigquery2;
```

Instantiate the connector by giving authentication details in the HTTP client config. The BigQuery client config has built-in support for OAuth 2.0. BigQuery uses OAuth 2.0 to authenticate and authorize requests. The BigQuery connector can be minimally instantiated in the BigQuery client config using the access token or the client ID, client secret, and refresh token.


### Obtaining Tokens to Run the Sample

1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
2. Go to **Credentials** -> **OAuth Consent Screen**, enter a product name to be shown to users, and click **Save**.
3. On the **Credentials** tab, click **Create Credentials** and select **OAuth Client ID**.
4. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use [OAuth 2.0 Playground](https://developers.google.com/oauthplayground) to receive the authorization code and obtain the access token and refresh token).
5. Click **Create**. Your Client ID and Client Secret appear.
6. In a separate browser window or tab, visit [OAuth 2.0 Playground](https://developers.google.com/oauthplayground), select the required BigQuery scopes, and then click **Authorize APIs**.
7. When you receive your authorization code, click **Exchange authorization code for tokens** for tokens to obtain the refresh token and access token.

You can now enter the credentials in the BigQuery client config:
```ballerina

bigquery2:BigQueryConfiguration bigqueryConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            config: {
                grantType: http:DIRECT_TOKEN,
                config: {
                    accessToken: config:getAsString("ACCESS_TOKEN"),
                    refreshConfig: {
                        refreshUrl: bigquery2:REFRESH_URL,
                        refreshToken: config:getAsString("REFRESH_TOKEN"),
                        clientId: config:getAsString("CLIENT_ID"),
                        clientSecret: config:getAsString("CLIENT_SECRET")
                    }
                }
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


### Example:
```ballerina
import ballerina/config;
import ballerina/http;
import ballerina/io;
import wso2/bigquery2;

// Create the Bigquery configuration.
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
        io:println("Projects: ", listProjectsResponse);
    } else {
        io:println("Error: ", listProjectsResponse);
    }

    // Get query result.
    var queryResults = bigQueryClient->getQueryResults("bigqueryproject-1121", "job_YtVh7jROzMs_KkTwJE5ggmM7WuEi");
    if (queryResults is bigquery2:QueryResults) {
        io:println("Query Result: ", queryResults);
    } else {
        io:println("Error: ", queryResults);
    }
}
```