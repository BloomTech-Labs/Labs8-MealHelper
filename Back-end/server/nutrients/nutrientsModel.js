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
  return db('nutrients');
}

function findById(id) {
  return db('nutrients')
    .where({ id })
    .first();
}

function add(nutrient) {
  return db('nutrients')
    .insert(nutrient)
    .into('nutrients');
}

function update(id, changes) {
  return db('nutrients')
    .where({ id })
    .update(changes);
}

function remove(id) {
  return db('nutrients')
    .where({ id })
    .del();
}
