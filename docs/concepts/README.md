# Concepts

## Field Types

BagelDB offers a rich set of versatile field types. Our aim is to have enough types to meet all requirements, however not to go overboard so as to confuse you with which one to use.

### Plain Text
Form: `"name":"John"`

### Numbers
Form: `"age":12`

When inserting or updating a number field, the server performs a check allowing Strings to be converted to a number if all characters are numeric, besides for the decimal point

### Rich Text
Form: `"content":"<b>Lorem impsum</b>"`

Choosing a rich text field enables the rich text editor, allowing Content editors to create html via a [wysiwyg](https://en.wikipedia.org/wiki/WYSIWYG) editor.

### Options
Form: `"gender":{"_id":"wy3jndskjnskd", "value":"Female"}`

Option fields allow you to set predefined values that must be used with the field. Adding values for an option field is done through the collection settings. Once a value has been added via the collection settings, an id will be assigned to the value, this id must be used when updating an option field.

### GeoPoint
Form `"location":{"lat":1,"lng":23}"`

GeoPoint can be used to store location by latitude and longitude. A GeoPoint can be queried whether a point is within X radius (meters) from a GeoPoint.

The values lat and lng, are a number type. BagelDB will accept a string, on create and update and convert it to a number if it can, otherwise it will return an error.

### Item Reference
Form: ` "users": [{"itemRefID":"<item ID>", "value":"<Primary Field value>"}]`

Item Reference fields offer the opportunity to reference items in other collections. This can be useful in situations such as a blog requiring categories.

A rich set of functionality is attached to item reference fields. It is possible to query items by the items that it references, for example a blog post could be filtered by its categories. Another feature is the ability to retrieve the entire referenced item when fetching the item, through what is called a `everything` request. When making a everything call the form is as follows:


```json
{
  "cartItems": [
    {
      "itemRefID": "<item ID>",
      "value": "corn",
      "item": {
        "_id": "",
        "name": "Corn",
        "price": 12.22
      }
    }
  ]
}

```
When referencing a collection which has a nested collection in its schema, it is possible to use the nested collection as a secondary reference. For example, if there is a collection for `categories` and the collection has a nested collection for `subCategory`. The Item Reference field, would have a primary reference to `catagories` and then`subCatagory`. The resultant form would be as follows:


```json
{
  "category": [{
    "itemRefID": "<category item id>",
    "value": "<category primary field value>",
    "subCategory": [{
      "itemRefID": "<subCategory item id>"
    }]
  }]
}

```
### Image or Image Gallery
Form: `"profilePic": {"altText":"Johnnies Pic","imageURL:"<LINK TO IMAGE>"}`

While the field is called an Image field, it is possible to upload a file. There is a restriction that the file must be under 10mb. If an image is uploaded that is larger than 10mb, BagelDB will try to compress the image to under 10mb.

### DateTime
Form: `"birthdate":"1996-12-19T16:39:57Z"`
Conforms to [RFC-3339](https://tools.ietf.org/html/rfc3339)

### Nested Collections

BagelDB offers the ability to nest collections inside each other. For example, you may desire to have an object with the following structure:


```json
books = [{
  "name": "Harry Potter",
  "chapters": [
      {
         "title": "Chapter 1",
          "contents": "<p>Once upon a time.....</p>"
      }
    ]
}]

```
It's possible to update individual nested items, as well as get the root item with all its children.

In general nested collections offer the same functionality as top-level collections, for example webhooks can be triggered by nested collections.

#### NestedID

A nested collection in referenced by its parent item and then its nested ID. The nested ID is a dot (.) separated list of collection slug and itemID. For example, in the collection Books, a chapter would have the nested ID `chapters.232323`. The API makes use of the nested ID to get the nested items and to update them.

When the nested ID ends with an itemID, it is referring to a specific nested item. When it ends in a nested collection id, it refers to the entire nested collection.

## Reserved Keys
There are few keys which are reserved for BagelDB use:

 - Item ID `_id`
 - Last Updated `_lastUpdatedDate`
 - Created Date `_createdDate`
 - Order `_order`

## Webhooks

Webhooks allow BagelDB to alert another service of an update to an item. There are three possible webhooks, Create, Update and Delete.

All webhooks receive the same request body:


```json
{
  "collectionID": "<collectionID>",
  "itemID": "<itemID>",
  "nestedID": "<nestedID>",
  "trigger": "<update/create/delete>",
  "item" : {

  }
}

```
When the item is an item from a nested collection, the `itemID` is the `_id` of the parent item and the `nestedID` is the id to get to the nestedItem.
i.e


```json
{
    "collectionID": "books",
    "itemID": "sererzd2343d3",
    "nestedID": "chapters.3434343"
}

```
## Live Data

BagelDB offers the ability to listen to collection events, currently `create` and `update` events are supported.

Listening makes use of [Server Side Events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events) technology. As this is uni-directional communication, the server closes out the connection periodically, which the client must than reopen with a new request with the previous requestID, in order to make sure no messages are missed.

The message payload is a stringified json, with the following structure, with the item being the item once the create or update has been completed:


```json
{
  "collectionID": "<collectionID>",
  "itemID": "<itemID>",
  "nestedID": "<nestedID>",
  "trigger": "<update/create>",
  "item" : {

  }
}

```
Event listening occurs at the collection level and is currently not possible to listen to individual items. It is possible to listen to a nested collection, once again the entire nested collection level and not on an individual nested item. It is not currently possible to use filtering with listening.

:::tip Note:
While every effort is made to make sure that the events are received in the same order that they are completed, there are rare occurrences when they may be received in a different order when there are numerous events occurring on a collection
:::

## Bagel Auth

Bagel Auth offers user authentication which is deeply integrated into BagelDB. This allows you to offer authentication, together with authorization in your application, without having to worry at all about backend code.

Bagel Auth is composed of two parts, the first is ***Bagel Users***, and the second is ***User Groups***.

A Bagel User represent a user in your application and must always belong to at least one User Group, as this is where the user inherits their permissions. A user is primarily made up of a user identifier, for example username, email or mobile number, and a password. The user identifier must be unique across the entire project.

A User Group is a way of grouping different types of users, and then assigning that user group different permissions, comprised of a set of rules. A rule is made up of collections and operations i.e Create, Update, Delete and Read, that can be performed on the collections. As an example, you may have Authors and Viewers, as two different user groups, where Authors can create and update blog posts, but the Viewers will only get permission to read blog posts. In this example however an Author should only be able to update articles that are theirs. To deal with this, a user group rule has the ability to add ***Associated Only***. When a rule is ***Associated Only***, the user will only have permissions to read items that they have been previously associated with, they will only be able to update items that they have been previously associated with and when they create an item they will be associated with the created item.

 When working with nested collections, User Group rules cascade down. Meaning if a rule is for a collection, then the rule is applied to all nested collections inside that collection. If the rule is only selected on a nested collection, then the rule will not be applied to the parent collection. For example, if there is a collection called Books, with a nested collection field called Chapters, if the rule is Read on Books than the User Group can also read Chapters but if the rule is only Read on Chapters than the User Group does not have permissions to read Books.
