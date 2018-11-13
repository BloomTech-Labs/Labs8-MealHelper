const express = require('express');
const users = require('./usersModel.js');
const router = express.Router();
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const jwtSecret = "thisisthesecretkeyplzdonttouch";

function generateToken(user) {
	const payload = {
		id: user.id,

		hello: "Hello!"
	};

	const JwtOptions = {
		expiresIn: "2h"
	};

	return jwt.sign(payload, jwtSecret, JwtOptions);
};

//////////////////////////////////////////////////
///Routes////

////Retrieves all users////

router.get('/', (req, res) => {
  users
    .find()
    .then(users => {
      res.status(200).json(users);
    })
    .catch(err => res.status(500).json(err));
});


////Retrieves user of a specific ID////

router.get('/:id', async (req, res) => {
    console.log(req.body);
  try {
    const { id } = req.params;

    const user = await users.findById(id);

    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

////Register a new user////
///Patch this in line 75/////


router.post('/register', (req, res) => {
  	//Abstraction of req.body
	const { email, password, zip, healthCondition } = req.body;
	//Sets the user to a JSON object of what we pulled from req.body
	const user = { email, password, zip, healthCondition };
	//Hashing the password
	const hash = bcrypt.hashSync(user.password, 15);
	//Setting the password to our hash
    user.password = hash;
    
    users
    .add(user)
    .then(user => {
        //Registers the user and generates a jwt token for them
        const token = generateToken(user);
        res.status(201).json(user, { token: token })

    .catch(err => {
      res.status(500).json(err);
    });
    });
});

////Login a new user////

router.post('/login', (req, res) => {
    //Abstraction of req.body
    const { email, password } = req.body;
    //Sets the userLogin to a JSON object of what we pulled from req.body
    const userLogin = { email, password };
    
    console.log(req.body);
  
    users
    .add({ email: userLogin.email })
    .then(user => {
        if (user && bcrypt.compareSync(userLogin.password, user.password)) {
            const token = generateToken(user);

            res
                .status(200)
                .json({ welcome: user.email, token: token, id: user.id });
        } else {
            res
                .status(500)
                .json({ error: "Wrong Email and/or Password, please try again" });
        }
        
    });
  });

//PUT request to change the email or password
router.put("/users/:id", (req, res) => {
	const id = req.body.id;
	const credentials = req.body;
	console.log(credentials.password);
    
    users
		//Finds the user by email
		.where({ email: credentials.email })
		.first()
		.then(user => {
			//Checking old password to verify it is correct
			if (user && bcrypt.compareSync(credentials.password, user.password)) {
				//Hashing the new password to be stored in DB (NOTE: its named newpassword not password)
				const hash = bcrypt.hashSync(credentials.newpassword, 15);
				//Sets the newpassword method to the hash to be stored
				credentials.newpassword = hash;
				db("users")
					.where({ id: id })
					.update({
						//Changing of the credentials
						email: credentials.email,
						//Sets the password of user to the hashed new password
						password: credentials.newpassword,
						zip: credentials.zip,
						healthCondition: credentials.healthCondition
					})
					.then(ids => {
						//Creates a token upon successfullying updating user
						const token = generateToken({ email: credentials.email });
						res.status(200).json({ token: token, id: id });
					})
					.catch(err => {
						console.log(err);
						res.status(500).json({ error: "Could not update User" });
					});
			} else {
				//Else statement goes off if the comparison if old password check does not match
				res
					.status(500)
					.json({ error: "Wrong Email and/or Password, please try again" });
			}
		});
});
// router.put('/:id', (req, res) => {
//   const { id } = req.params;
//   const changes = req.body;

//   users
//     .update(id, changes)
//     .then(count => {
//       if (!count || count < 1) {
//         res.status(404).json({ message: 'No user records found to update' });
//       } else {
//         res.status(200).json(count);
//       }
//     })
//     .catch(err => res.status(500).json(err));
// });

// router.delete('/:id', (req, res) => {
//   const { id } = req.params;

//   users
//     .remove(id)
//     .then(count => {
//       if (!count || count < 1) {
//         res.status(404).json({ message: 'No user records found to delete' });
//       } else {
//         res.status(200).json(count);
//       }
//     })
//     .catch(err => res.status(500).json(err));
// });

module.exports = router;