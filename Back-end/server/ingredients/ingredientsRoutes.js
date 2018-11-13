const express = require('express');
const ingredients = require('./ingredientsModel.js');
const router = express.Router();

//////////////////////////////////
////Refactor all routes//////////
//////////////////////////////////
router.get('/', (req, res) => {
  ingredients
    .find()
    .then(ingredients => {
      res.status(200).json(ingredients);
    })
    .catch(err => res.status(500).json(err));
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const ingredient = await ingredients.findById(id);

    if (ingredient) {
      res.status(200).json(ingredient);
    } else {
      res.status(404).json({ message: 'Ingredient not found' });
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

router.post('/', (req, res) => {
  const user = req.body;

  ingredients
    .add(ingredient)
    .then(ids => {
      res.status(201).json(ids[0]);
    })
    .catch(err => {
      res.status(500).json(err);
    });
});

router.put('/:id', (req, res) => {
  const { id } = req.params;
  const changes = req.body;

  ingredients
    .update(id, changes)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No user records found to update' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

router.delete('/:id', (req, res) => {
  const { id } = req.params;

  ingredients
    .remove(id)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No user records found to delete' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

module.exports = router;