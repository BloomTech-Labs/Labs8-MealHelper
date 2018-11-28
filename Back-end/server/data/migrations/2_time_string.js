
exports.up = function(knex, Promise) {
  return knex.schema.table('alarms', function(a) {
    a.dropColumn('time');
    a.string('alarm').notNullable;
  })
};

exports.down = function(knex, Promise) {
  return knex.schema.table('alarms', function (a) {
    a.dropColumn('alarm');
    a.integer('time').notNullable;
  })
};
