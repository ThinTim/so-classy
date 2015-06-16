#= require q

window.server = {
  send: (method, url, data) ->
    Q($.ajax({
        dataType: 'json',
        method,
        url,
        data
      }))
}