---
title: "Web API Errors"
date: 2021-10-22T08:32:38+05:30
draft: false
---

Many software systems communicate using Web APIs on top of HTTP. The communication is mostly in the form of a client-server interaction. The client sends a request and the server responds with a response. There are well defined HTTP status codes to indicate the status of the API response. The most common ones being - `200 OK`, `400 BAD REQUEST`, `404 NOT FOUND`, `500 INTERNAL SERVER ERROR` etc. And then there is `418 I'M A TEAPOT`.

From the [RFC 7231](https://datatracker.ietf.org/doc/html/rfc7231#section-6):
```
The first digit of the status-code defines the class of response.
   The last two digits do not have any categorization role.  There are
   five values for the first digit:

   o  1xx (Informational): The request was received, continuing process

   o  2xx (Successful): The request was successfully received,
      understood, and accepted

   o  3xx (Redirection): Further action needs to be taken in order to
      complete the request

   o  4xx (Client Error): The request contains bad syntax or cannot be
      fulfilled

   o  5xx (Server Error): The server failed to fulfill an apparently
      valid request
```

There are various scenarios that can happen in a HTTP exchange between a client and a server. For a full list and description of the HTTP status codes, we can check at [RFC 7231 Section 6.1](https://datatracker.ietf.org/doc/html/rfc7231#section-6.1) or at the MDN(Mozilla Developer Network) page [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) for brief descriptions. The IANA(Internet Assigned Numbers Authority) maintains a list of the status codes as well- [Hypertext Transfer Protocol (HTTP) Status Code Registry](https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml).

Whenever there is an error during an API request processing, we can use the 4xx or the 5xx class of status codes depending on the context. Let's take an example where there is an issue in the request payload. Let's assume the payload is a JSON like -
```JSON
{
    "id": "12345678ab",
    "categories": ["category1", "category2"]
}
```
Let's say the `id` field must be of length 10 and must comprised of the digits 0-9 and it must start with a non-zero digit. Based on this conditions the above JSON is in invalid request. If we look at the possible status codes that can be returned for the response we have to consider the 4xx class of response, since the issue is with the request from the client. Therefore we can return a `400 BAD REQUEST`.

Adding to the specifications of the request, let's say the `categories` field must be an array. Now consider the below API request -
```JSON
{
    "id": "12345678ab",
    "categories": "category1,category2"
}
```
This request is an invalid one for two reasons. First the `id` field's value contains alphabets. Second the `categories` field is a string instead of an array. Let's consider another variation - 
```JSON
{
    "id": "1234567890",
    "categories": "category1,category2"
}
```
Obviously, it is an invalid request.

When we return a status code of `400 BAD REQUEST`, it doesn't have a context on what was the actual cause of the error. We need a way to provide more detailed description about the errors, which can not be satisfied by just using the HTTP status code.

When we develop an API we can list out the possible error scenarios. Each error can be given a HTTP status code and a custom error code, as well as a description of the error. For a request there can be multiple errors. We can include the list of errors in the API response. For example -

|HTTP code | Error code | Description |
|---|---|---|
|400|EF_001| Invalid id field|
|400|EF_002| Invalid categories field|
|415|EB_004| Unknown content type| 

Or we can go with more descriptive codes like -

|HTTP code | Error code | Description |
|---|---|---|
|400|INVALID_ID| Invalid id field|
|400|INVALID_CATEGORIES| Invalid categories field|
|415|UNKNOWN_CONTENT_TYPE| Unknown content type|
|400|UKNOWN_CATEGORY|One of the categories is not recognized|

```HTTP
HTTP/2.0 400 BAD REQUEST
Date: Mon, 25 Oct 2021 09:28:04 GMT
Content-Type: application/json
Content-Length: 350

{
    "errors":[
        {
            "code": "UNKOWN_CATEGORY",
            "message": "Category category3 is unknown",
            "details": "invalid category received"
        },
        {
            "code": "INVALID_ID",
            "message": "Received id containing alphabets",
            "details": "invalid id received"
        }
    ]
}
```

# 🏮