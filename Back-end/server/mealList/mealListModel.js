const knex = require('knex');

const knexConfig = require('../knexfile.js');
const db = knex(knexConfig.development);

module.exports = {
  find,
  findById,
  add,
  update,
  remove,
};

function find() {
  return db('mealLists');
}

function findById(id) {
  return db('mealLists')
    .where({ id })
    .first();
}

function add(mealList) {
  return db('mealLists')
    .insert(mealList)
    .into('mealLists');
}

function update(id, changes) {
  return db('mealLists')
    .where({ id })
    .update(changes);
}

function remove(id) {
  return db('mealLists')
    .where({ id })
    .del();
}
