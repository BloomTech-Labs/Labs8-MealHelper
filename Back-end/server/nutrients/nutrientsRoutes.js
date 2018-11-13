const express = require('express');
const nutrients = require('./nutrientsModel.js');
const router = express.Router();

//////////////////////////////////
////Refactor all routes//////////
//////////////////////////////////
router.get('/', (req, res) => {
    nutrients
    .find()
    .then(nutrients => {
      res.status(200).json(nutrients);
    })
    .catch(err => res.status(500).json(err));
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const nutrient = await nutrients.findById(id);

    if (nutrient) {
      res.status(200).json(nutrient);
    } else {
      res.status(404).json({ message: 'Nutrient not found' });
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

router.post('/', (req, res) => {
  const nutrient = req.body;

  nutrients
    .add(nutrient)
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

  nutrients
    .update(id, changes)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No nutrient records found to update' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

router.delete('/:id', (req, res) => {
  const { id } = req.params;

  nutrients
    .remove(id)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No nutrient records found to delete' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

module.exports = router;