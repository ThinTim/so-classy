ko.components.register('relative-time', {
  viewModel: function(params) {
    this.content = moment(params.iso8601).fromNow();
  },
  template: '<span data-bind="text: content">'
})