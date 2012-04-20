window.timers =
  current_running: ->
    console.log 'current running'
    unless window.timers.current?
      return false
    current = window.timers.current
    switch current.type
      when '1'
        current.$toggle.hasClass('active')
      when '2'
        '' # TODO
      when '3'
        '' # TODO

  stop_current: ->
    console.log 'stop current'
    current = window.timers.current
    switch current.type
      when '1'
        current.$toggle.click()
      when '2'
        '' # TODO
      when '3'
        '' # TODO

  save_current: (timer, type, first_side) =>
    console.log 'save current'
    current = window.timers.current = timer
    current.type = type
    current.side = first_side

get_label_from = ($btn) ->
  $btn.closest('.tab-pane').get(0).id

get_timer_from = ($btn) ->
  label = get_label_from($btn)
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
  switch timers.current.type
    when '1'
      on_toggle_one(e)
    when '2'
      on_toggle_one(e)
    when '3'
      on_toggle_three(e)

on_toggle_one = (e) ->
  e.preventDefault()
  $target = $(e.target)
  if $target.hasClass('disabled') # timeout
    return
  timer = get_timer_from($target)
  if $target.hasClass('active')
    timer.stop()
    $target.html('<i class="icon-play"></i> 开始')
  else
    timer.start()
    $target.html('<i class="icon-pause"></i> 暂停')
  $target.toggleClass('active')

on_toggle_three = (e) ->
  e.preventDefault()
  $target = $(e.target)
  if $target.hasClass('disabled') # timeout
    return
  timer = get_timer_from($target)
  side = timers.current.side
  if $target.hasClass('active')
    timer[side].stop()
    $target.html('<i class="icon-play"></i> 开始')
  else
    timer[side].start()
    $target.html('<i class="icon-pause"></i> 暂停')
  $target.toggleClass('active')

on_next = (e) -> # next button
  #console.log 'on next'
  e.preventDefault()
  $target = $(e.target)
  label = get_label_from($target)
  selector = "ul.nav.nav-tabs li a[href=##{label}]"
  $next = $(selector).parent().nextAll('[class!=nav-header]').first().find('a')
  if $next.length
    $next.click()

on_previous = (e) -> # previous button
  #console.log 'on previous'
  e.preventDefault()
  $target = $(e.target)
  label = get_label_from($target)
  selector = "ul.nav.nav-tabs li a[href=##{label}]"
  $next = $(selector).parent().prevAll('[class!=nav-header]').first().find('a')
  if $next.length
    $next.click()

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

return_on_show_one = (init_time, label) ->
  #console.log 'return on show', init_time, label
  (e) ->
    #console.log 'on show', 'timers.current', timers.current, init_time, label
    if timers.current? and timers.current.$toggle.hasClass('active')
      timers.current.$toggle.click()
    timers[label] ?= new Timer init_time
    timer = timers[label]
    timers.save_current timer, '1'
    _(timer).extend
      label: label
      $el: $("##{label} .timer")
      $progress: $("##{label} .progress .bar")
      $toggle: $("##{label} .btn.toggle")
    timer
      .on('update', on_update)
      .trigger 'update' # trigger once to init view

return_on_show_two = (init_time, label) ->
  #console.log 'return on show', init_time, label
  (e) ->
    #console.log 'on show', 'timers.current', timers.current, init_time, label
    if timers.current_running()
      timers.current.$toggle.click()
    timers[label] ?= new Timer init_time
    timer = timers[label]
    timers.save_current timer, '2'
    _(timer).extend
      label: label
      $el: $("##{label} .timer")
      $progress: $("##{label} .progress .bar")
      $toggle: $("##{label} .btn.toggle")
    timer
      .on('update', on_update)
      .trigger 'update' # trigger once to init view

return_on_show_three = (init_time_pos, init_time_con, label, first_side) ->
  #console.log 'return on show', init_time, label
  (e) ->
    console.log 'on show', 'timers.current', timers.current, init_time_pos, init_time_con, label, first_side
    if timers.current_running()
      timers.stop_current()
    timers[label] ?=
      pos: new Timer init_time_pos
      con: new Timer init_time_con
    timer = timers[label]
    timers.save_current timer, '3', first_side
    _(timer.pos).extend
      label: label
      $el: $("##{label} .timer.pos")
      $progress: $("##{label} .progress.pos .bar")
      $toggle: $("##{label} .btn.toggle")
      $change: $("##{label} .btn.change")
    _(timer.con).extend
      label: label
      $el: $("##{label} .timer.con")
      $progress: $("##{label} .progress.con .bar")
      $toggle: $("##{label} .btn.toggle")
      $change: $("##{label} .btn.change")
    ###
    _(timer).extend
      label: label
      $el_pos: $("##{label} .timer.pos")
      $el_con: $("##{label} .timer.con")
      $progress_pos: $("##{label} .progress.pos .bar")
      $progress_con: $("##{label} .progress.con .bar")
      $toggle: $("##{label} .btn.toggle")
      $change: $("##{label} .btn.change")
    ###
    timer.pos
      .on('update', on_update)
      .trigger 'update' # trigger once to init view
    timer.con
      .on('update', on_update)
      .trigger 'update' #trigger once to init view

default_options_one =
  $container: $('.main-pane')
  previous: true
  next: true

init_view_one = (options = default_options_one) ->
  options = _.extend(_.clone(default_options_one), options)
  unless options.label? and options.title?
    return false
  template = _.template($('#tab-pane-type-one').html())
  options.$container.append template(options)
  $("a[href=##{options.label}]").on 'show', return_on_show_one(options.init_time, options.label)

default_options_two =
  $container: $('.main-pane')
  previous: true
  next: true

init_view_two = (options = default_options_two) ->
  options = _.extend(_.clone(default_options_two), options)
  unless options.label? and options.title?
    return false
  template = _.template($('#tab-pane-type-two').html())
  options.$container.append template(options)
  $("a[href=##{options.label}]").on 'show', return_on_show_two(options.init_time, options.label)

default_options_three =
  $container: $('.main-pane')
  previous: true
  next: true

init_view_three = (options = default_options_three) ->
  options = _.extend(_.clone(default_options_three), options)
  unless options.label? and options.title? and options.first_side?
    return false
  template = _.template($('#tab-pane-type-three').html())
  options.$container.append template(options)
  $("a[href=##{options.label}]").on 'show', return_on_show_three(options.init_time_pos, options.init_time_con, options.label, options.first_side)

$ ->
  # binding
  $('body')
    .on('click', '.btn.toggle', on_toggle)
    .on('click', '.btn.reset', on_reset)
    .on('click', '.btn.next', on_next)
    .on('click', '.btn.previous', on_previous)

  # init view
  init_view_one
    title: '正方一辩破题立论'
    label: 'pos-1-1'
    previous: false
    init_time: 3 * 60 * 1000 # 3 min

  init_view_one
    title: '反方二辩盘问正方一辩'
    label: 'con-1-2'
    init_time: 2 * 60 * 1000 # 2 min

  init_view_one
    title: '反方一辩破题立论'
    label: 'con-1-1'
    init_time: 3 * 60 * 1000 # 3 min

  init_view_one
    title: '正方二辩盘问反方一辩'
    label: 'pos-1-2'
    init_time: 2 * 60 * 1000 # 2 min

  init_view_two
    title: '正方三辩攻辩反方一、二、四辩'
    label: 'pos-2-1'
    init_time_pos: 60 * 1000 # 1 min
    single_time_pos: 20 * 1000 # 20 second
    init_time_con: 1.5 * 60 * 1000 # 1.5 min
    single_time_con: 30 * 1000 # 30 second
    first_side: 'pos'

  init_view_two
    title: '反方三辩攻辩正方一、二、四辩'
    label: 'con-2-1'
    init_time_con: 60 * 1000 # 1 min
    single_time_con: 20 * 1000 # 20 second
    init_time_pos: 1.5 * 60 * 1000 # 1.5 min
    single_time_pos: 30 * 1000 # 30 second
    first_side: 'con'

  init_view_three
    title: '自由辩论'
    label: '3'
    init_time_pos: 5 * 60 * 1000 # 5 min
    init_time_con: 5 * 60 * 1000 # 5 min
    first_side: 'pos'

  init_view_one
    title: '正方三辩攻辩小结'
    label: 'pos-2-2'
    init_time: 1.5 * 60 * 1000 # 1.5 min

  init_view_one
    title: '反方三辩攻辩小结'
    label: 'con-2-2'
    init_time: 1.5 * 60 * 1000 # 1.5 min

  init_view_one
    title: '正方四辩总结陈词'
    label: 'pos-4'
    init_time: 4 * 60 * 1000 # 4 min

  init_view_one
    title: '反方四辩总结陈词'
    label: 'con-4'
    init_time: 4 * 60 * 1000 # 4 min
    next: false

  # init nav tabs
  $('a[href=#pos-1-1]').click()
