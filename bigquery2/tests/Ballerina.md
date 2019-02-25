## Compatibility

| Ballerina Language Version  | Bigquery API Version |
| ----------------------------| -------------------------------|
|  0.990.3                    |   V2                           |

### Prerequisites

1. Create a project and create an app for this project by visiting [Bigquery](https://console.developers.google.com/).
2. Obtain the following parameters
    * Client Id
    * Client Secret
    * Redirect URI
    * Access Token
    * Refresh Token

    **IMPORTANT** This access token and refresh token can be used to make API requests on your own
    account's behalf. Do not share your access token, client  secret with anyone.

See the [topic on OAuth2Webserver](https://developers.google.com/identity/protocols/OAuth2WebServer) for more information on obtaining OAuth2 credentials.

## Running Samples
You can use the `tests.bal` file to test all the connector remote functions by following the steps below:
1. Create a ballerina.conf file in the module-bigquery directory.
2. Obtain the client Id, client secret, access token, and refresh token as mentioned above and add those values in the ballerina.conf file.
    ```
    ACCESS_TOKEN="your_access_token"
    CLIENT_ID="your_client_id"
    CLIENT_SECRET="your_client_secret"
    REFRESH_TOKEN="your_refresh_token"
    ```
3. Navigate to the folder `module-bigquery`.
4. Run the following commands to execute the tests.
    ```
    ballerina init
    ballerina test bigquery2 --config ballerina.conf
    ```