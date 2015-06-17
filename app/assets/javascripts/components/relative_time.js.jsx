window.RelativeTime = React.createClass({ 
  displayName: 'RelativeTime',
  render: function() {
    var content = moment(this.props.iso8601).fromNow();

    return (<text>{ content }</text>);
  }
});