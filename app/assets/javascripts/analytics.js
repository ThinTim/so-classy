/*
 * The turbolinks gem subverts normal pageloads to improve performance.
 * We need to detect the 'fake' page changes and send them to google manually.
 */
$(document).on('page:change', function() {
  if(window._gaq) {
    _gaq.push ['_trackPageview']
  } else if (window.pageTracker) {
    pageTracker._trackPageview()  
  }
}