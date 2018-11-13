const express = require('express');
const weather = require('./weatherModel.js');
const router = express.Router();

//////////////////////////////////
////Refactor all routes//////////
//////////////////////////////////
router.get('/', (req, res) => {
  users
    .find()
    .then(weather => {
      res.status(200).json(weather);
    })
    .catch(err => res.status(500).json(err));
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const weather = await weather.findById(id);

    if (weather) {
      res.status(200).json(weather);
    } else {
      res.status(404).json({ message: 'Request not found' });
    }
  } catch (error) {
    res.status(500).json(error);
  }
});

router.post('/', (req, res) => {
  const weather = req.body;

  weather
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

  weather
    .update(id, changes)
    .then(count => {
      if (!count || count < 1) {
        res.status(404).json({ message: 'No weather information found to update' });
      } else {
        res.status(200).json(count);
      }
    })
    .catch(err => res.status(500).json(err));
});

router.delete('/:id', (req, res) => {
  const { id } = req.params;

  weather
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