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
  return db('alarms');
}

function findById(id) {
  return db('alarms')
    .where({ id })
    .first();
}

function add(alarm) {
  return db('alarms')
    .insert(alarm)
    .into('alarms');
}

function update(id, changes) {
  return db('alarms')
    .where({ id })
    .update(changes);
}

function remove(id) {
  return db('alarms')
    .where({ id })
    .del();
}
