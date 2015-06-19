ko.components.register('teach-button', {
  viewModel: {
    createViewModel: function(params, info) { 
      return new QuickJoinViewModel(params.collectionName, params.collection, params.joinFunction, params.leaveFunction);
    }
  },
  template: '<div class="btn btn-lg btn-block" data-bind="css: { \'btn-primary\': !isMember(), \'btn-secondary\': isMember() }, click: doQuickAction">' +
            '<!-- ko if: isUpdating -->' +
            '    Updating...' +
            '<!-- /ko -->' +
            '<!-- ko ifnot: isUpdating -->' +
            '    <span data-bind="text: (isMember() ? \'Stop Teaching\' : \'Volunteer to Teach\')"></span>' +
            '<!-- /ko -->' +
            '</div>'
})