//This file performs some optimisations for touch devices

//= require fastclick

React.initializeTouchEvents(true)

if ('addEventListener' in document) {
  document.addEventListener('DOMContentLoaded', function() { FastClick.attach(document.body) }, false)
}
