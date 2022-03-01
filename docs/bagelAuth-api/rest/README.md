# REST API

Master URI: `https://auth.bageldb.com/api/public`

Authorization: Added as authorization headers `Authorization: Bearer <<API_TOKEN>>`

## Create User

- Method: POST
- Endpoint: `/user`
- Request Body:



```json
{ "email": "example@test.com", "password": "123456" }

```
- Expected Response: 201 - Created
- Response Body:



```json
{
  "access_token": "",
  "refresh_token": "",
  "user_id": ""
}

```
## Login User

- Method: POST
- Endpoint: `/user/verify`
- Request Body:



```json
{ "email": "example@test.com", "password": "123456" }

```
- Expected Response: 200 - OK
- Response Body:



```json
{
  "access_token": "",
  "refresh_token": "",
  "user_id": ""
}

```
## Refresh User

Method: POST

Endpoint: `/user/token`

Request Body:



```js
`grant_type=refresh_token&refresh_token=${RefreshToken}&client_id=project-client`;

```
Expected Response: 200 - OK

## Get User Meta Info

Method: GET
Endpoint: `/user`

Expected Response: 20O - OK

- Response Body:



```json
{}

```
## User Admin - Reset Password

API Token must have User Admin permissions

- Method: POST
- Endpoint: `/user/updatePassword`
- Request Body:



```json
{ "email": "example@test.com", "password": "ThisIsTheUpdatedPassword" }

```
- Expected Response: 200 - OK
