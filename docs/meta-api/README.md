# Meta API

The Meta API allows you to retrieve the schema for a collection

## Get Schema

It is possible to retrieve the schema of a collection. This enables implementing things like dynamic forms or other
dynamic pages, which rely on the schema to display different page components. Schema will be retrieved for the parent
collection, and will contain the schema for all nested collections inside the parent collection.

<CodeGroup>
<CodeGroupItem title="JS">


```js
let {data: schema} = await db.schema("chat").get()

```
</CodeGroupItem>
</CodeGroup>

Expected Response



```json
[
  {
    "name": "Metadata",
    "id": "_metadata",
    "slug": "_metadata",
    "type": 100
  },
  {
    "name": "Name",
    "id": "601184f23dabaf9fa421e43c",
    "slug": "name",
    "type": 1,
    "required": false,
    "unique": false,
    "primaryField": false
  }
]

```### Type Value Mapping

	PlainTextType    = 1
	RichTextType     = 2
	NumberType       = 3
	PhoneNumberType  = 4
	ImageRefType     = 5
	ItemRefType      = 6
	OptionType       = 7
	BooleanType      = 8
	LinkType         = 9
	DateType         = 10
	ImageRefSetType  = 11
	NestedCollection = 12
	GeoPointType     = 13