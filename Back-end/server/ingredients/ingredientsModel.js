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
  return db('ingredients');
}

function findById(id) {
  return db('ingredients')
    .where({ id })
    .first();
}

function add(ingredient) {
  return db('ingredients')
    .insert(ingredient)
    .into('ingredients');
}

function update(id, changes) {
  return db('ingredients')
    .where({ id })
    .update(changes);
}

function remove(id) {
  return db('ingredients')
    .where({ id })
    .del();
}
