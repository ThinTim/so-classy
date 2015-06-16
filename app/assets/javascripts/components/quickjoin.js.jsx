window.QuickJoin = React.createClass({ 
  displayName: 'QuickJoin',
  handleClick: function(evt) {
    var self = this,
        request;

    evt.stopPropagation();
    evt.preventDefault();

    if(self.state.isLoading) return;

    self.setState({
      isLoading: true
    });

    if(self.state.isMember) {
      request = self.leave();
    } else {
      request = self.join();
    }

    request.finally(function() {
      if(self.isMounted()) {
        self.setState({
          isLoading: false
        })
      }
    });
  },
  handleMouseEnter: function() {
    var self = this;

    self.setState({
      isHovering: true
    });
  },
  handleMouseLeave: function() {
    var self = this;

    self.setState({
      isHovering: false
    });
  },
  join: function() {
    var self = this;

    return server.send('POST', self.props.joinUrl, null).then(function(response) {
      if (self.isMounted()) {
        self.setState({
          isMember: true,
          memberCount: response.length
        });
      }
    });
  },
  leave: function() {
    var self = this;

    self.setState({
      isLoading: true
    });

    return server.send('POST', self.props.leaveUrl, null).then(function(response) {
      if (self.isMounted()) {
        self.setState({
          isMember: false,
          memberCount: response.length
        });
      }
    });
  },
  getInitialState: function() {
    var self = this;

    return {
      isLoading: false,
      isHovering: false,
      isMember: self.props.isInitiallyMember,
      memberCount: self.props.initialMemberCount
    }
  },
  render: function() {
    var self = this,
        cx = React.addons.classSet,
        classes,
        content;

    classes = cx({
      'quickjoin': true,
      'quickjoin-member': self.state.isMember,
    });

    if(self.state.isLoading) {
      content = 'Updating...'
    } else if(self.state.isHovering) {
      content = self.state.isMember ? 'Leave' : 'Join';
    } else {
      content = self.state.memberCount + ' ' + (self.state.memberCount === 1 ? self.props.collectionName : self.props.collectionName + 's');
    }

    return (<span 
      className={classes}
      onMouseEnter={self.handleMouseEnter} 
      onMouseLeave={self.handleMouseLeave}
      onClick={self.handleClick}>
      
      {content}

      </span>);
  }
});