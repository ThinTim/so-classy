window.utils = (function(module, _) {
  module.asyncUpdate = function asyncUpdate(observable, beginUpdate) {
    if(_.isArray(observable)) {
      _.forEach(observable, function(o) { o(true); })
    } else {
      observable(true)
    }

    beginUpdate().finally(function() {
      if(_.isArray(observable)) {
        _.forEach(observables, function(o) { o(false); })
      } else {
        observable(false)
      }
    }).done();
  }

  return module;
}(window.utils || {}, _))