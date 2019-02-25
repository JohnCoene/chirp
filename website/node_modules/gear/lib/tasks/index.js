var Tasks = {
  write: require('./write').write,
  tasks: require('./tasks').tasks,
  stamp: require('./stamp').stamp,
  replace: require('./replace').replace,
  concat: require('./concat').concat
};

function addTasks(o) {
  Object.keys(o).map(function(k) {
    Tasks[k] = o[k];
  });
}

addTasks(require('./core'));
addTasks(require('./read'));

module.exports = Tasks;
