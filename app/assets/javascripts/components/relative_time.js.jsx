window.RelativeTime = React.createClass({ 
  displayName: 'RelativeTime',
  render: function() {
    var self = this;

    var content = moment(self.props.iso8601).fromNow();

    return (<text>{ content }</text>);
  }
});