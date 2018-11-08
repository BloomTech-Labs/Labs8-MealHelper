const express = require('express');
const users = require('./usersModel.js');
const router = express.Router();

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

//////////////////////////////////
////Refactor all routes//////////
//////////////////////////////////

router.get('/', (req, res) => {
  users
    .find()
    .then(users => {
      res.status(200).json(users);
    })
    .catch(err => res.status(500).json(err));
});

// router.get('/:id', async (req, res) => {
//     console.log(req.body);
//   try {
//     const { id } = req.params;

//     const user = await users.findById(id);

//     if (user) {
//       res.status(200).json(user);
//     } else {
//       res.status(404).json({ message: 'User not found' });
//     }
//   } catch (error) {
//     res.status(500).json(error);
//   }
// });

// //Register a new user
// router.post('/register', (req, res) => {
//   	//Abstraction of req.body
// 	const { email, password, zip, healthCondition } = req.body;
// 	//Sets the user to a JSON object of what we pulled from req.body
// 	const user = { email, password, zip, healthCondition };
// 	//Hashing the password
// 	const hash = bcrypt.hashSync(user.password, 15);
// 	//Setting the password to our hash
//     user.password = hash;
    
//     users
//     .add(user)
//     .then(user => {
//         //Registers the user and generates a jwt token for them
//         const token = generateToken(user);
//         res.status(201).json(user, { token: token })

//     .catch(err => {
//       res.status(500).json(err);
//     });
// });

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