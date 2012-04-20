on_toggle = (e) -> # toggle button
  #console.log 'on toggle'
  e.preventDefault()
  $target = $(e.target)
  if $target.hasClass('disabled') # timeout
    return
  label = $target.closest('.tab-pane').get(0).id
  timer = window.timers[label]
  if $target.hasClass('active')
    $target.html('开始')
    timer.stop()
  else
    $target.html('暂停')
    timer.start()
  $target.toggleClass('active')

on_update = (e) -> # timer update
  #console.log 'on update'
  @$el.html(@to_string())
  if @time is 0
    @$toggle.click().addClass('disabled')
  else if @time < 25600
    color = '#' + (~~((25600 - @time) / 100)).toString(16) + '0000'
    @$el.css('color', color)
  else
    @$el.css('color', '#000')

  @$progress.width("#{(1 - @time / @init_time) * 100}%")

return_on_show = (init_time, label) ->
  #console.log 'return on show'
  (e) ->
    #console.log 'on show'
    timers[label] ?= new Timer init_time
    timer = timers[label]
    _(timer).extend
      label: label
      $el: $("##{label} .timer")
      $progress: $("##{label} .progress .bar")
      $toggle: $("##{label} .btn.toggle")
    timer
      .on('update', on_update)
      .trigger 'update' # trigger once to init view

$ ->
  window.timers = {}
  $('body').on 'click', '.btn.toggle', on_toggle

  $('a[href=#pos-1-1]').on 'show', return_on_show(3 * 60 * 1000, 'pos-1-1')

  $('a[href=#pos-1-1]').click()
