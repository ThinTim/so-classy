window.QuickJoin = React.createClass({ 
  displayName: 'QuickJoin',
  clickHandler: function(evt) {
    evt.stopPropagation();
    evt.preventDefault();

    if(this.state.isMember) {
      this.leave();
    } else {
      this.join();
    }
  },
  mouseEnterHandler: function() {
    this.setState({
      isMember: this.state.isMember,
      memberCount: this.state.memberCount,
      isHovering: true
    });
  },
  mouseLeaveHandler: function() {
    this.setState({
      isMember: this.state.isMember,
      memberCount: this.state.memberCount,
      isHovering: false
    });
  },
  join: function() {
    var request = server.send('POST', this.props.joinUrl, null).then(function(response) {
      if (this.isMounted()) {
        this.setState({
          isMember: true,
          memberCount: response.length
        });
      }
    }.bind(this));
  },
  leave: function() {
    server.send('POST', this.props.leaveUrl, null).then(function(response) {
      if (this.isMounted()) {
        this.setState({
          isMember: false,
          memberCount: response.length
        });
      }
    }.bind(this));
  },
  getInitialState: function() {
    return {
      isMember: this.props.isInitiallyMember,
      memberCount: this.props.initialMemberCount
    }
  },
  render: function() {
    var cx = React.addons.classSet;

    var classes = cx({
      'quickjoin': true,
      'quickjoin-member': this.state.isMember,
    });

    var content;

    if(this.state.isHovering) {
      content = this.state.isMember ? 'Leave' : 'Join';
    } else {
      content = this.state.memberCount + ' ' + (this.state.memberCount === 1 ? this.props.collectionName : this.props.collectionName + 's');
    }

    return (<span 
      className={classes} 
      onMouseEnter={this.mouseEnterHandler} 
      onMouseLeave={this.mouseLeaveHandler} 
      onClick={this.clickHandler}>
      
      {content}

      </span>);
  }
});