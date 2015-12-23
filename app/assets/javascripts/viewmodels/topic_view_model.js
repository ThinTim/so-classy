function TopicViewModel(topic) {
  var self = this;

  self.name = topic.name;
  self.description = topic.description;
  self.owner = topic.owner;
  self.routes = topic.routes;

  // MEMBERS

  self.membersVisible = ko.observable(false);
  self.toggleMembersVisible = function() { self.membersVisible(!self.membersVisible()); }
  self.memberCount = ko.observable(topic.member_count);

  // TEACHERS

  self.teachers = ko.observable(topic.teachers);
  self.teachers.includesCurrentUser = ko.observable(topic.isTeaching);
  self.teachers.isUpdating = ko.observable(false);

  self.teach = function() {
    utils.asyncUpdate(self.teachers.isUpdating, function() {
      return server.send('POST', topic.routes.teach, null).then(function(response) {
        self.teachers(response.teachers);
        self.memberCount(response.member_count);
        self.teachers.includesCurrentUser(true);
      });
    });
  };

  self.stopTeaching = function() {
    utils.asyncUpdate(self.teachers.isUpdating, function() {
      return server.send('POST', topic.routes.stopTeaching, null).then(function(response) {
        self.teachers(response.teachers);
        self.memberCount(response.member_count);
        self.teachers.includesCurrentUser(false);
      });
    });
  };

  // STUDENTS

  self.students = ko.observable(topic.students);
  self.students.includesCurrentUser = ko.observable(topic.isLearning);
  self.students.isUpdating = ko.observable(false);

  self.learn = function() {
    utils.asyncUpdate(self.students.isUpdating, function() {
      return server.send('POST', topic.routes.learn, null).then(function(response) {
        self.students(response.students);
        self.memberCount(response.member_count);
        self.students.includesCurrentUser(true);
      });
    });
  };

  self.stopLearning = function() {
    utils.asyncUpdate(self.students.isUpdating, function() {
      return server.send('POST', topic.routes.stopLearning, null).then(function(response) {
        self.students(response.students);
        self.memberCount(response.member_count);
        self.students.includesCurrentUser(false);
      });
    });
  };

  // COMMENTS

  self.comments = ko.observable(topic.comments);
  self.comments.isUpdating = ko.observable(false);

  self.newComment = {
    body: ko.observable(''),
    sendEmail: ko.observable(false)
  };

  self.createComment = function() {
    var data = {
      comment: {
        body: self.newComment.body(),
        sendEmail: self.newComment.sendEmail()
      }
    };

    self.newComment.body('');

    utils.asyncUpdate(self.comments.isUpdating, function() {
      return server.send('POST', self.routes.comments, data).then(function(response) {
        self.comments(response);
      });
    });
  };

  self.deleteComment = function(comment) {
    utils.asyncUpdate(self.comments.isUpdating, function() {
      return server.send('POST', comment.routes.destroy, { '_method':'delete' }).then(function(response) {
        self.comments(response);
      });
    });
  }
}