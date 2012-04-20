window.timers = {}
get_timer_from = ($btn) ->
  label =$btn.closest('.tab-pane').get(0).id
  window.timers[label]

on_reset = (e) -> # reset button
  e.preventDefault()
  $target = $(e.target)
  unless confirm '确定要重置时间么？'
    return

  timer = get_timer_from($target)
  timer.reset(timer.init_time)


on_toggle = (e) -> # toggle button
  #console.log 'on toggle'
  e.preventDefault()
  $target = $(e.target)
  if $target.hasClass('disabled') # timeout
    return
  timer = get_timer_from($target)
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
  # binding
  $('body')
    .on('click', '.btn.toggle', on_toggle)
    .on('click', '.btn.reset', on_reset)

  $('a[href=#pos-1-1]').on 'show', return_on_show(3 * 60 * 1000, 'pos-1-1')

  # init nav tabs
  $('a[href=#pos-1-1]').click()
