#= require q

window.server = {
  send: (method, url, data) ->
    Q($.ajax({
        method,
        url,
        data
      }))
}