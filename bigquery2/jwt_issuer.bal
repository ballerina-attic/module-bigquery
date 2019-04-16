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

import ballerina/auth;
import ballerina/crypto;
import ballerina/encoding;

# Issue a JWT token.
#
# + header - JwtHeader object
# + payload - JwtPayload object
# + config - JWTIssuerConfig object
#
# + return - JWT token string or an error if token validation fails
function issue(auth:JwtHeader header, auth:JwtPayload payload, auth:JWTIssuerConfig config)
              returns string|error {
    string jwtHeader = check createHeader(header);
    string jwtPayload = check createPayload(payload);
    string jwtAssertion = jwtHeader + "." + jwtPayload;

    crypto:KeyStore keyStore = {
        path: config.keyStore.path,
        password: config.keyStore.password
    };
    var privateKey = check crypto:decodePrivateKey(keyStore = keyStore, keyAlias = config.keyAlias,
        keyPassword = config.keyPassword);
    string signature = "";
    if (header.alg == "RS256") {
        signature = encodeBase64Url(check crypto:signRsaSha256(jwtAssertion.toByteArray("UTF-8"), privateKey));
    } else if (header.alg == "RS384") {
        signature = encodeBase64Url(check crypto:signRsaSha384(jwtAssertion.toByteArray("UTF-8"), privateKey));
    } else if (header.alg == "RS512") {
        signature = encodeBase64Url(check crypto:signRsaSha512(jwtAssertion.toByteArray("UTF-8"), privateKey));
    } else {
        error jwtError = error(BIGQUERY_ERROR_CODE, { message: "Unsupported JWS algorithm" });
        return jwtError;
    }

    return (jwtAssertion + "." + signature);
}

# Construct JWT Header.
#
# + header - JwtHeader object
#
# + return - Encoded JWT Header or an error if token validation fails
function createHeader(auth:JwtHeader header) returns string|error {
    json headerJson = {};
    if (!validateMandatoryJwtHeaderFields(header)) {
        error jwtError = error(BIGQUERY_ERROR_CODE, { message: "Mandatory field signing algorithm(alg) is empty." });
        return jwtError;
    }
    headerJson[ALG] = header.alg;
    headerJson[TYP] = header.typ;

    string headerValInString = headerJson.toString();
    string encodedPayload = encoding:encodeBase64(headerValInString.toByteArray("UTF-8"));
    return encodedPayload;
}

# Construct JWT Payload.
#
# + payload - JwtPayload object
#
# + return - Encoded JWT Payload or an error if token validation fails
function createPayload(auth:JwtPayload payload) returns string|error {
    json payloadJson = {};
    if (!validateMandatoryFields(payload)) {
        error jwtError = error(BIGQUERY_ERROR_CODE,
        { message: "Mandatory fields(Issuer, Subject, Expiration time or Audience) are empty." });
        return jwtError;
    }
    payloadJson[SUB] = payload.sub;
    payloadJson[ISS] = payload.iss;
    payloadJson[EXP] = payload.exp;
    var iat = payload["iat"];
    if (iat is int) {
        payloadJson[IAT] = iat;
    }
    var jti = payload["jti"];
    if (jti is string) {
        payloadJson[JTI] = jti;
    }
    var aud = payload.aud;
    var length = aud.length();
    if (length == 1) {
        payloadJson[AUD] = aud[0];
    } else if (length > 1) {
        payloadJson[AUD] = convertStringArrayToJson(aud);
    }
    var customClaims = payload["customClaims"];
    if (customClaims is map<any>) {
        payloadJson = addMapToJson(payloadJson, customClaims);
    }
    string payloadInString = payloadJson.toString();
    return encoding:encodeBase64(payloadInString.toByteArray("UTF-8"));
}