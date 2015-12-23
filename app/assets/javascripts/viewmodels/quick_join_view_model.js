function QuickJoinViewModel(collectionName, collection, joinFunction, leaveFunction) {
  var self = this;

  self.isMember = collection.includesCurrentUser;
  self.isUpdating = collection.isUpdating;
  self.isHovering = ko.observable(false);

  self.startHovering = function() {
    self.isHovering(true);
  };

  self.stopHovering = function() {
    self.isHovering(false);
  };

  self.doQuickAction = function() {
    if(self.isUpdating()) return;

    if(self.isMember()) leaveFunction();
    else joinFunction();
  };

  self.memberText = ko.pureComputed(function() {
    if(collection().length === 1) {
      return collection().length + ' ' + collectionName
    } else {
      return collection().length + ' ' + collectionName + 's'
    }
  });
}