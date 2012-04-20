class window.Timer
  constructor: (time, on_update) -> # in milliseconds
    #console.log 'new timer:', time
    @on 'update', on_update
    @reset(time)

  # === private ========================================

  _interval: 97 # in milliseconds

  _count_down: =>
    @time -= @_interval + 3 # for delay
    @trigger 'update'
    if @time <= 0
      @stop()

  _to_time_string: (i) =>
    s = i.toString()
    s = '0' + s if s.length is 1 # fill 0 if only 1 digit
    s

  # === public ========================================

  # proxy for event handler
  on: (events, handler) =>
    #console.log 'on'
    $(@).on events, handler
    @

  off: () =>
    #console.log 'off'
    $(@).off events, handler
    @

  trigger: (events) =>
    #console.log 'trigger', events
    $(@).trigger events
    @

  # timer function
  reset: (time) =>
    if @id? # stop current timer
      clearInterval(@id)
    if time and typeof time is 'number'
      @init_time = @time = time
      @trigger 'update'

  start: =>
    console.log 'start'
    if @time > 0
      @id = setInterval(@_count_down, @_interval)
      #@trigger 'start.timer'

  stop: =>
    console.log 'on stop'
    if @id
      clearInterval(@id)
      @id = undefined
      #@trigger 'stop.timer'

  # helper
  to_string: =>
    h = @hour()
    time = "#{@minute()}:#{@second()}"
    time = "#{h}:" + time if h
    time

  second: =>
    @_to_time_string(~~(@time / 1000 % 60))

  minute: =>
    @_to_time_string(~~((@time / 1000 % 3600) / 60))

  hour: =>
    ~~(@time / 3600000)

  is_counting: =>
    @id?
