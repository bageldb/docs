# Content REST-API

Master URI: `https://api.bagelstudio.co/api/public` Authorization: Added as authorization headers `Authorization: Bearer <<API_TOKEN>>` Version Header: `Accept-Version: v1`

## Get Items

- Method: GET
- Endpoint: ` /collection/<<collectionID>>/items`
- Sample Response

```json
[
  {
    "_id": "a1Sdasds324ad3d"
  }
]
```

#### Query Params

- Pagination:

  - `perPage=Number_Per_Page` Default: 100
  - `pageNumber=Page_Number` Default: 1

- Sort

  - `sort=Field_Slug`
  - `order=ASC or DESC`

- Projection (Note that nested collection fields in a collection will only be returned if projected on)

  - `projectOn=name,age`
  - `projectOff=name,age`

- Querying

  - `query=Field_Slug:Comparator:Value`

  Note: Query must be url encoded

  | Operator | Valid with Fields | Example |
  | --- | --- | --- |
  | = | All Fields expect Geo Point | name:=:John |
  | != | All Fields expect Geo Point | name:!=:John |
  | regex | Plain Text, Rich Text, Number, Link | name:regex:Jo |
  | > | All Fields | age:>:23 |
  | < | All Fields | age:<:10 |
  | within | GeoPoint Only | location:within:<lat,lng,distanceInMeters> i.e location:within:23.222,32.2313,2000 |

For multiple queries they should be joined with a `+` or the URL encoded version `%2B` i.e name:=:John+age:>:12

## Get Item

- Method: GET
- Endpoint: ` /collection/<<collectionID>>/items/<<itemID>>`

- Query Params

  | Key | Value | Action |
  | --- | --- | --- |
  | everything | true | For a reference field, it will return the entire item being referenced. |
  | nestedID | e.g chapters.2323 or chapters | Will retrieve the nested collection or nested collection item rather than the parent item |
  | projectOn | Comma-separated list of field slugs e.g name,age | Will only return the requested field slugs, however metadata fields will always be returned; i.e \_id, \_lastUpdatedDate and \_createdDate |
  | projectOff | Comma-separated list of field slugs e.g name | Will remove the requested field slug from the response |

- Sample Response

```json
{
  "_id": "324cd",
  "_lastUpdatedDate": "2021-01-17T15:33:27.739Z",
  "_createdDate": "2021-01-17T15:33:27.739Z",
  "name": "Johnny"
}
```

## Add Item

- Method: POST
- Endpoint: ` /collection/<<collectionID>>/items`
- Sample Response

```json
{
  "id": "234239432"
}
```

## Add Nested Item

- Method: POST
- Endpoint: `/collection/<<collectionID>>/items/<<itemID>>`

- Query Params

  | Key                 | Value        | Action                                   |
  | ------------------- | ------------ | ---------------------------------------- |
  | nestedID (Required) | e.g chapters | Will add a item to the nested collection |

- Sample Response

```json
{
  "id": "234239432"
}
```

## Update Item or Nested Item

- Method: PUT
- Endpoint: ` /collection/<<collectionID>>/items/<<itemID>>`

- Query Params

| Key | Value | Action |
| --- | --- | --- |
| set | true | Create item if it doesn't exist, using the itemID for the new items ID |
| nestedID | e.g chapters.2323 or chapters | Will update a nested item if the nestedID ends with an itemID or if `set` is `true` it will create a new item with the id |

- Sample Response

```json
{
  "id": "234239432"
}
```

## Update Individual Fields

**_CURRENTLY ONLY SUPPORTS REFERENCE FIELDS_**

### Append Item Reference

- Method: PUT
- Endpoint: `/collection/<<collectionID>>/items/<<itemID>>/field/<<fieldSlug>>`
  - Query Params

| Key      | Value             | Action                                            |
| -------- | ----------------- | ------------------------------------------------- |
| nestedID | e.g chapters.2323 | Will append the item reference to the nested item |

- Request Body:

```json
{
  "value": "REFERENCE ITEM ID"
}
```

### Remove existing item reference

- Method: DELETE
- Endpoint: `/collection/<<collectionID>>/items/<<itemID>>/field/<<fieldSlug>>`
  - Query Params

| Key      | Value             | Action                                            |
| -------- | ----------------- | ------------------------------------------------- |
| nestedID | e.g chapters.2323 | Will append the item reference to the nested item |

- Request Body:

```json
{
  "value": "REFERENCE ITEM ID"
}
```

## Delete Item or Nested Item

- Method: DELETE
- Endpoint: `/collection/<<collectionID>>/items/<<itemID>>`
- Query Params

| Key      | Value             | Action                      |
| -------- | ----------------- | --------------------------- |
| nestedID | e.g chapters.2323 | Will delete the nested item |

## Upload Image or Asset

- Method: PUT
- Request Type: multipart/form-data
- Endpoint: ` /collection/<<collectionID>>/items/<<itemID>>/image?imageSlug=<fieldSlug>`

Form Keys:

- Alt Text for the image: `altText`
- To upload an image from a URL: `imageLink`
- To upload the actual image: `imageFile`

Note: Either imageLink or imageFile must be included but not both
