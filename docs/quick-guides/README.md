# Quick Guides

## Creating an API Token

In order to access data or to work with Bagel Users, via an API endpoint, you must first create an API Token.

To create an API Token, follow the following steps:

1. Sign in to [BagelDB](https://app.bageldb.com)
1. Once signed in, navigate to the project that you would like to create the token for.
1. Once in the project, click on the settings link at the bottom of the side navigation bar.
1. In settings under the Api Tokens header, click `+ New API Token`.
1. You will now be able to select the different permissions to assign to the token.
1. Click `Generate Api Token`
1. The token will be generated and appear on the page, copy this token and store in a secure location. You will not be
   able to view the token again from with in BagelDB.

**TREAT THIS TOKEN AS YOU WOULD A PASSWORD**

## Getting Started with Bagel Auth

To enable Bagel Auth, you must first create a User Group in the BagelDB admin.
1. Once inside a project, select the User icon on the side navigation and open up User Groups. There you can create a new user group, for example you may create a group called `Users`.
1. You can now add rules to the user group, selecting the collections that the rule will apply to, the actions that the rules allows on the selected collections and finally whether the rule is an associated only rule.
1. Once, all rules have been added and then user group is created, it's time to start adding users. Users can only be added via the API, first create an new API Token, with the User Group assigned to it.
1. Now use this API Token together with the API to create new users.
