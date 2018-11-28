
exports.up = function(knex, Promise) {
  return knex.schema.table('alarms', function(a) {
    a.string('label');
    a.renameColumn('beginTime', 'time');
    a.dropColumns('endTime', 'beginLimit', 'endLimit', 'repeats');
});
};

exports.down = function(knex, Promise) {
  return knex.schema.table('alarms', function(a) {
    a.dropColumn('label');
    a.renameColumn('time', 'beginTime');
    a.integer("endTime").notNullable();
    a.integer("beginLimit").notNullable();
    a.integer("endLimit").notNullable();
    a.integer("repeats").notNullable();
  })
};
