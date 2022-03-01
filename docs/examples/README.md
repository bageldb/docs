# Examples

## NodeJS

#### Case:
Each time a user submits an application, a score must be calculated using their age and income. A web-form directly adds an item to the collection, which in turn triggers a `Create` webhook. The webhook function as defined below, calculates the score and than updates the item.

#### Example Code:


```js
const BagelDB = require("@bageldb/bagel-db");

const bagelDBClient = new BagelDB("YOUR_TOKEN");

exports.calculateScore = function(req, res) {
	let score = 0;
	let { itemID, item } = req.body;
	let { age, income } = item;

	if (age < 21) {
		score += 10;
	} else {
		score += 5;
	}

	score += (income / 100) * 1.4;

	return bagelDBClient.collection("usersScore").item(itemID).put({score: score}).then((response) => {
		res.status(200).send()
	})
};


```