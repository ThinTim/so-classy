window.QuickJoin = React.createClass({ 
  displayName: 'QuickJoin',
  handleClick: function(evt) {
    var request;

    evt.stopPropagation();
    evt.preventDefault();

    if(this.state.isLoading) return;

    this.setState({
      isLoading: true
    });

    if(this.state.isMember) {
      request = this.leave();
    } else {
      request = this.join();
    }

    request.finally(() => {
      if(this.isMounted()) {
        this.setState({
          isLoading: false
        })
      }
    });
  },
  handleMouseEnter: function() {
    this.setState({
      isHovering: true
    });
  },
  handleMouseLeave: function() {
    this.setState({
      isHovering: false
    });
  },
  join: function() {
    return server.send('POST', this.props.joinUrl, null).then((response) => {
      if (this.isMounted()) {
        this.setState({
          isMember: true,
          memberCount: response.length
        });
      }
    });
  },
  leave: function() {
    this.setState({
      isLoading: true
    });

    return server.send('POST', this.props.leaveUrl, null).then((response) => {
      if (this.isMounted()) {
        this.setState({
          isMember: false,
          memberCount: response.length
        });
      }
    });
  },
  getInitialState: function() {
    return {
      isLoading: false,
      isHovering: false,
      isMember: this.props.isInitiallyMember,
      memberCount: this.props.initialMemberCount
    }
  },
  render: function() {
    var classes,
        content;

    classes = classNames({
      'quickjoin': true,
      'quickjoin-member': this.state.isMember,
    });

    if(this.state.isLoading) {
      content = 'Updating...'
    } else if(this.state.isHovering) {
      content = this.state.isMember ? 'Leave' : 'Join';
    } else {
      content = this.state.memberCount + ' ' + (this.state.memberCount === 1 ? this.props.collectionName : this.props.collectionName + 's');
    }

    return (<span 
      className={classes}
      onMouseEnter={this.handleMouseEnter} 
      onMouseLeave={this.handleMouseLeave}
      onClick={this.handleClick}>
      
      {content}

      </span>);
  }
});