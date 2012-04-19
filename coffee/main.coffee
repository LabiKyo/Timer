$ ->
  ###
  window.timer = new Timer 62000
  $el = $('#timer')
  timer
    .on 'update', ->
      $el.html(timer.toString())
    .on 'start', ->
      console.log 'start'
    .on 'stop', ->
      console.log 'stop'
  timer.start()

  $('#start').on 'click', (e) ->
    timer.start()
    e.preventDefault()


  $('#stop').on 'click', (e) ->
    timer.stop()
    e.preventDefault()
  ###
  $('ul.nav.nav-list li:first a').tab('show')
