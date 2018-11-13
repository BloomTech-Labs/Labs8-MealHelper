const express = require('express');
const recipes = require('./recipesModel.js');
const router = express.Router();

//////////////////////////////////
////Refactor all routes//////////
//////////////////////////////////
router.get('/', (req, res) => {
  recipes
    .find()
    .then(recipe => {
      res.status(200).json(recipe);
    })
    .catch(err => res.status(500).json(err));
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const recipe = await recipes.findById(id);

    if (recipe) {
      res.status(200).json(recipe);
    } else {
      res.status(404).json({ message: 'Recipe not found' });
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

router.post('/', (req, res) => {
  const recipe = req.body;

  recipes
    .add(user)
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

  recipes
    .update(id, changes)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No recipe information found to update' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

router.delete('/:id', (req, res) => {
  const { id } = req.params;

  recipes
    .remove(id)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No weather records found to delete' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

module.exports = router;