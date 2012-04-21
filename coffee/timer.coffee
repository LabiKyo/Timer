class window.Timer
  constructor: (time, on_update) -> # in milliseconds
    #console.info 'new timer:', time
    _.extend @, window.Backbone.Events # make it eventable
    @init(time)

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

  # timer function
  init: (time) =>
    if time and typeof time is 'number'
      @init_time = @time = time
      @trigger 'update'
      @trigger 'init'

  reset: () =>
    if @id? # stop current timer
      clearInterval(@id)
    @time = @init_time
    @trigger 'reset'
    @trigger 'update'

  start: =>
    #console.info 'start'
    if @time > 0
      @id = setInterval(@_count_down, @_interval)
      @trigger 'start'

  stop: =>
    #console.info 'stop'
    if @id
      clearInterval(@id)
      @id = undefined
      @trigger 'stop'

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
