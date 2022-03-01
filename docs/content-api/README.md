---
pageClass: api-docs-class
---

# Content API

## Getting Started

### Installing

<CodeGroup>
<CodeGroupItem title="JS">

```bash
npm i @bageldb/bagel-db
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```bash
 1. Add BagelDB to your pubspec.yaml file:
        bagel_db:
 2. Run the command:
        flutter pub get
```
</CodeGroupItem>
</CodeGroup>

### Importing

<CodeGroup>
<CodeGroupItem title="JS">

```javascript
import Bagel from '@bageldb/bagel-db'

// or

const Bagel = require('@bageldb/bagel-db')
```


```html
<!-- or for cdn version -->
<script src="https://unpkg.com/@bageldb/bagel-db"></script>
```

</CodeGroupItem>

<CodeGroupItem title="Flutter">

```bash
import 'package:bagel_db/bagel_db.dart';
```
</CodeGroupItem>
</CodeGroup>

### Initialize

<CodeGroup>
<CodeGroupItem title="JS">

```js
let API_TOKEN = "AUTH_TOKEN"
let db = new Bagel(API_TOKEN)
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
String apiToken = "AUTH_TOKEN"
BagelDB db = BagelDB(token: apiToken);
```
</CodeGroupItem>
</CodeGroup>

## Get Collection

Retrieve multiple items from a collection

- By default, this will return the first 100 items in the collection, in order to get a specific set of items see below
  in Pagination
- Nested collection fields will not be retrieved unless they are specifically projected on using the `projectOn` feature (see below)

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").get()
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("articles").get()
```
</CodeGroupItem>
</CodeGroup>

:::tip Note:
<img alt="New Collection Creation" src="/assets/images/New_Collection_wide.png"/> <br/>
**Collection Name** is for internal use only. <br/>
Use the automatically generated **Collection ID** (case sensitive)
:::

For a nested collection, `item()` and `collection()` can be chained till the correct collection and item is reached

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("books").item("sds232323d").collection("reviews").get()
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("articles").item("sds232323d").collection("reviews").get()
```
</CodeGroupItem>
</CodeGroup>

### Pagination

BagelDB has built in pagination, you can set the number of items per page and the page you would like to retreive

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").perPage(50).page(2).get()

```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("articles").perPage(50).pageNumber(2).get()

```
</CodeGroupItem>
</CodeGroup>

### Projection

It is possible to `project on` and `project off` for all fields in an item, enabling you to retrieve only exactly what is required in
the response body

- It is not possible to mix both projectOn and projectOff
- Metadata field will always be retrieved unless explicitly projectedOff i.e _id, _lastUpdateDate and _createdDate

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").projectOn("title,name").get()
<--- OR ---->
db.collection("articles").projectOff("title,name").get()
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart

```
</CodeGroupItem>
</CodeGroup>

### Querying

Multiple forms of querying are available:

- Equals Operator "="
- Not Equals Operator "!="
- Greater Than Operator ">"
- Less Than Operator "<"
- Regex Operator "regex"
- GeoPoint Within Operator "within"

Method: query(key, operator, value)

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("books").query("name", "=", "Of Mice and Men").get()

db.collection("books").query("bookName","!=", "Of Mice and Men").get()

```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("books").query("name", "=", "Of Mice and Men").get()

db.collection("books").query("bookName","!=", "Of Mice and Men").get()
```
</CodeGroupItem>
</CodeGroup>

#### Special Cases:

`Item Reference` field

An itemRef field expects to get a field name, operator, and comma separated values of one or more of the ids of the
relevant referenced items. It will return one of any of the values provided


<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("books").query("author.itemRefID", "=", "5e89a0a573c14625b8850a05,5ed9a0a573c14625ry830v52").get()

```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("books").query("author.itemRefID", "=", "5e89a0a573c14625b8850a05,5ed9a0a573c14625ry830v52").get()

```
</CodeGroupItem>
</CodeGroup>


The expected return for the above query are the list of books by either author ids provided. It will also return the
books where the author is only one of many authors of that book.

The same applies for not operation `:!=:` where the expected return is to get all the items, that do not have any of the
references provided

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("books").query("author.itemRefID","!=","5e89a0a573c14625b8850a05,5ed9a0a573c14625ry830v52").get()
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("books").query("author.itemRefID","!=","5e89a0a573c14625b8850a05,5ed9a0a573c14625ry830v52").get()
```
</CodeGroupItem>
</CodeGroup>

The expected response for the above query is all the books that do not contain any of the id's of the provided values.
It will not return even where there are other authors to that book.

`GeoPoint` field

A Geo Point field can be queried if it lies within X radius from another Geo Point.

For example, to query for any hotel within 800 meters of the point 31.75494235983889, 35.214322441328519, the following would be used:

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("hotels").query("location", BagelDB.WITHIN , BagelDB.GeoPointQuery(31.75494235983886, 35.214322441328534, 800)).get()
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
```
</CodeGroupItem>
</CodeGroup>


## Get a Single Item

Retrieve a single item

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").item("5e89a0a573c14625b8850a05").get()
//or for a nested item
db.collection("books").item("sds232323d").collection("reviews").item("232323323").get()
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("articles").item("5e89a0a573c14625b8850a05").get()
```
</CodeGroupItem>
</CodeGroup>

## Create Item

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").post({YOUR_OBJECT})
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("articles").post({YOUR_OBJECT})
```
</CodeGroupItem>
</CodeGroup>

:::tip Note:
<img alt="New Field Creation" src="/assets/images/New_Field.png"/> <br/>
**Name** is for internal use only. <br/>
Use the automatically generated **Slug** (case sensitive)
:::

expected response


```json
{
  "id": "ITEM_ID"
}
```

### Set Item ID

When creating an item the `_id` will be set for you by the server. If you require to set the `_id` of the item, use
the `set` method:

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").item("YOUR_ITEM_ID").set({OBJECT_CHANGES})
```
</CodeGroupItem>
</CodeGroup>

If the `_id` is not unique the server will throw an error

## Update Item

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").item("ITEM_ID").put({OBJECT_CHANGES})
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
db.collection("articles").item("ITEM_ID").put({OBJECT_CHANGES})
```
</CodeGroupItem>
</CodeGroup>

expected response


```json
{
  "id": "ITEM_ID"
}
```
### Update Reference Field

It is possible to also update a specific reference field

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").item("ITEM_ID").append("FIELD_SLUG", "ITEM_REF_ID")
```
</CodeGroupItem>
</CodeGroup>

It is also possible to remove one item reference from a reference field

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("articles").item("ITEM_ID").unset("FIELD_SLUG", "ITEM_REF_ID")
```
</CodeGroupItem>
</CodeGroup>

## Delete Item

Will delete the entire item for good.


```js
db.collection("articles").item("ITEM_ID").delete()
```
## Uploading asset

Method Signature: `uploadImage(imageSlug, {selectedImage, imageLink, altText})`

selectedImage expects a file stream ```i.e fs.createReadStream(filename)```
OR a blob

imageLink can be a link to a file stored somewhere on the web

The method checks if imageLink exists and if not will use selectedImage

The request is sent via a FormData request.

<CodeGroup>
<CodeGroupItem title="JS">

```js
let image = {
    selectedImage: fs.createReadStream('/foo/bar.jpg'),
    altText: "johnny"
};
db.collection("users").item("3423432").uploadImage("profilePic", image);


//OR

let image = {
    imageLink: "https://example.com/image.jpg",
    altText: "johnny"
};
db.collection("users").item("3423432").uploadImage("profilePic", image);

//OR

let image = {
    imageLink: "https://example.com/image.jpg",
    altText: "johnny"
};
db.collection("users").item("3423432").uploadImage("profilePic", image);

```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
File image = File('/Users/userName/Desktop/photo-test.jpeg');
db.collection("users").item("3423432").uploadImage("profilePic", image)
```
</CodeGroupItem>
</CodeGroup>

## Live Data

See [live concepts](../concepts/#live-data) for more details about how live data works, and the form of the message received.

In the JS library, the `listen` method takes two call-backs. The first is the `onMessage` function, which `listen` calls when it received a new message, inserting a [Message Event](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent). From there you can use the message event as required extracting out the message data. The data will be under `event.data` in a stringified json format.
The second callback is the `onError` callback; when the listener encounters an error it calls the `onError` callback with error.

Listen ***only*** returns events that occurred after the listen has been called. In order to get items that have occurred before the listen is called, a separate `get` request is required.

If it appears that listening is not connecting, check that the API token has read access on the collection being listened to.

<CodeGroup>
<CodeGroupItem title="JS">

```js
let messages = []
let onMessageEvent = (event) => {
    let eventData = JSON.parse(event.data)
    let messageItem = eventData.item
    messages.push(messageItem)
}
db.collection("messages").listen(onMessageEvent)
```
</CodeGroupItem>

<CodeGroupItem title="Flutter">

```dart
    db.collection("messages").listen((event) => {
         print(event)
     });
```
</CodeGroupItem>
</CodeGroup>

## Bagel User with Items

### View Bagel Users
To view the bagel users associated with an item.

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("books").item("ITEM_ID").users()
```
</CodeGroupItem>
</CodeGroup>

Expected Response


```json
[{"userID": "213-3213c-123c123-1232133"}]
```
### Add a Bagel User
In order to add the api token must have User Admin permissions, it is suggested to only use this token server side
To add a Bagel User to an item

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("books").item("ITEM_ID").addUser("USER_ID")
```
</CodeGroupItem>
</CodeGroup>

### Remove a Bagel User
In order to remove the api token must have User Admin permissions, it is suggested to only use this token server side

To remove a Bagel User from an item

<CodeGroup>
<CodeGroupItem title="JS">

```js
db.collection("books").item("ITEM_ID").removeUser("USER_ID")
```
</CodeGroupItem>
</CodeGroup>
