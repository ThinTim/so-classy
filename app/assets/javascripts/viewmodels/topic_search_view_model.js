function TopicSearchViewModel() {
  var self = this;

  self.topics = ko.observable([]);
  self.topics.isUpdating = ko.observable(false);

  self.searchParams = {
    name: ko.observable(''),
    sort: ko.observable({ property: 'popularity', direction: 'descending' })
  }  
  
  self.searchData = ko.pureComputed(function() {
    return { 
      name: self.searchParams.name(), 
      sort: self.searchParams.sort().property, 
      direction: self.searchParams.sort().direction 
    };
  }).extend({ rateLimit: 300, method: "notifyWhenChangesStop" });

  self.searchData.subscribe(function() {
    self.search();
  });

  self.search = function() {
    utils.asyncUpdate(self.topics.isUpdating, function() {
      return server.send('GET', '/topics', self.searchData()).then(function(response) {
        var topicModels = _.map(response, function(topicJson){ return new TopicViewModel(topicJson); });
        self.topics(topicModels);
      });
    });
  }

  self.onEnter = function(d, e) {
    if(e.keyCode == 13) {
      var name = self.searchParams.name();
      window.location = '/topics/new?prefill=' + window.encodeURIComponent(name);
    }
    return true;
  }
}