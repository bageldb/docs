# Bagel Auth API <span class="badge tip" style="vertical-align: top;">BETA</span>

Bagel Auth is currently in **beta**.

See [here](../quick-guides#getting-started-with-bagel-auth) for creating an API token, installing and initialising the BagelDB client library.
::: tip Note
Bagel Auth with the JS library is designed to be used on a browser, except for the update password function which will only run using NodeJS.
:::

## User Creation

On user creation, the user will automatically logged-in and any further BagelDB call will be made with their permissions.

<CodeGroup>
<CodeGroupItem title="JS">

```js
let userID = await db.users().create(email, password).catch((err) => console.log(err))
```
</CodeGroupItem>
</CodeGroup>

## User Login

On user login the user id is returned if successful and any further BagelDB call will be made with their permissions. There is no need to refresh the user's tokens as this will happen automatically when using the JS library.

<CodeGroup>
<CodeGroupItem title="JS">


```js
let userID = await db.users().validate(email, password).catch((err) => console.log(err))

```
</CodeGroupItem>
</CodeGroup>

## User Logout

<CodeGroup>
<CodeGroupItem title="JS">


```js
db.users().logout()

```
</CodeGroupItem>
</CodeGroup>


## User Info
To get info about the user, such as last logged in date.

<CodeGroup>
<CodeGroupItem title="JS">


```js
db.users().getUser()

```
</CodeGroupItem>
</CodeGroup>

The expected response is:



```json
{ "userID": "dc3e732d-8da4-48aa-abf8-c1c711b21114", "email": "test@example.com", "createdDate": "2020-12-21T12:53:41.021Z", "lastLoggedIn": "2020-12-21T12:53:41.021Z", "userGroups": [ "bvg70k223akg008f9tl0" ] }

```
### Attaching User to an Item
Bagel Users can be attached to items in BagelDB. This allows the usage of the associated items feature, meaning that a user will only be able to retrieve and update an item that they have been associated with.

For docs on using the libraries for viewing and editing users attached to an item, check out the content api docs [here](../content-api)

## User Admin
In order to enable user admin features, it is possible to add User Admin to an API Token. This token should not be used from a Client but rather in a server. It is not possible to assign user groups to a token which has user admin privileges.

### Update Password
Using this function in the browser will throw an error.

<CodeGroup>
<CodeGroupItem title="JS">


```js
db.users().updatePassword("test@gmail.com", "NewPasswordThatShouldBeStrong")

```
</CodeGroupItem>
</CodeGroup>


<!-- <script lang="ts">


export default {
    mounted() {
        if (document.getElementById('betaBadge')) return;
        const header = document.querySelector('[aria-label$=BETA]');
        // console.log(header)
        header.innerHTML = header.innerHTML.replace('BETA','<span id="betaBadge" class="badge tip" style="vertical-align: top;">BETA</span>');
    }
}
</script> -->
