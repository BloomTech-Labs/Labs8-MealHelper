const express = require('express');
const mealLists = require('./mealListModel.js');
const router = express.Router();

//////////////////////////////////
////Refactor all routes//////////
//////////////////////////////////
router.get('/', (req, res) => {
    mealLists
    .find()
    .then(mealLists => {
      res.status(200).json(mealLists);
    })
    .catch(err => res.status(500).json(err));
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const mealList = await mealLists.findById(id);

    if (mealList) {
      res.status(200).json(mealList);
    } else {
      res.status(404).json({ message: 'MealList not found' });
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

router.post('/', (req, res) => {
  const mealList = req.body;

  mealLists
    .add(mealList)
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

  mealLists
    .update(id, changes)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No meal list records found to update' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

router.delete('/:id', (req, res) => {
  const { id } = req.params;

  mealLists
    .remove(id)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No meal list records found to delete' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

module.exports = router;