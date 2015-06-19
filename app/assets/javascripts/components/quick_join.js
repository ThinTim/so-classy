ko.components.register('quick-join', {
  viewModel: {
    createViewModel: function(params, info) { 
      return new QuickJoinViewModel(params.collectionName, params.collection, params.joinFunction, params.leaveFunction);
    }
  },
  template: '<span class="quickjoin" data-bind="css: { \'quickjoin-member\': isMember() }, click: doQuickAction, event: { mouseover: startHovering, mouseout: stopHovering }">' +
            '<!-- ko if: isUpdating -->' +
            '    Updating...' +
            '<!-- /ko -->' +
            '<!-- ko ifnot: isUpdating -->' +
            '    <span data-bind="visible: isHovering(), text: (isMember() ? \'Leave\' : \'Join\')"></span>' +
            '    <span data-bind="visible: !isHovering(), text: memberText"></span>' +
            '<!-- /ko -->' +
            '</span>'
})