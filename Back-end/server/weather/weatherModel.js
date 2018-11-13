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
  return db('weather');
}

function findById(id) {
  return db('weather')
    .where({ id })
    .first();
}

function add(weather) {
  return db('weather')
    .insert(weather)
    .into('weather');
}

function update(id, changes) {
  return db('weather')
    .where({ id })
    .update(changes);
}

function remove(id) {
  return db('weather')
    .where({ id })
    .del();
}