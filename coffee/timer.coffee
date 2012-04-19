class window.Timer
  constructor: (time) -> # in milliseconds
    @reset(time)

  # private

  _interval: 97 # in milliseconds

  _handler: $('#handler')

  _count_down: =>
    @time -= @_interval + 3 # for delay
    @_handler.trigger('update')
    if @time <= 0
      @stop()

  _to_time_string: (i) =>
    s = i.toString()
    s = '0' + s if s.length is 1 # fill 0 if only 1 digit
    s

  # public

  on: (events, handler) =>
    @_handler.on(events, handler)

  off: (events, handler) =>
    @_handler.off(events, handler)

  reset: (time) =>
    if time and typeof time is 'number'
      @time = time

  start: =>
    if @time > 0
      @id = setInterval(@_count_down, @_interval)
      @_handler.trigger('start')

  stop: =>
    if @id
      clearInterval(@id)
      @id = undefined
      @_handler.trigger('stop')

  toString: =>
    h = @hour()
    time = "#{@minute()}:#{@second()}"
    time = "#{h}:" + time if h
    time

  # helper

  second: =>
    @_to_time_string(~~(@time / 1000 % 60))

  minute: =>
    @_to_time_string(~~((@time / 1000 % 3600) / 60))

  hour: =>
    ~~(@time / 3600000)

  is_counting: =>
    @id?
