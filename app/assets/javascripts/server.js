//= require q

window.server = {
  send: function(method, url, data) {
    return Q($.ajax({
        dataType: 'json',
        method: method,
        url: url,
        data: data
      }));
  }
}