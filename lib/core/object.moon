import Signal    from require "lib/core/signal"
import Scheduler from require "lib/core/scheduler"

class Object
  new: (t = {}) =>
    @type = "Object"
    @name

    @scheduler = @_opt t.scheduler, Scheduler!
    @signals   = {}

    @getters   = {}
    @setters   = {}

    if t.properties
      for prop in *t.properties
        @property prop[1], prop[2], prop[3]

    if t.signals
      for signals in *t.signals
        @add_signal signal

    _opt: (v, def) =>
      if v == nil
        return def
      v

    property: (name, getter, setter) =>
      @getters[name] = @[getter]
      @setters[name] = @[setter]

    get: (name) =>
      if @getters[name]
        return @getters[name] @
      @[name]

    set: (name, value) =>
      if @setters[name]
        return @setters[name] @, value

      @[name] = value
      value

    add_signal: (name) =>
      unless @signals[name] == nil
        error "Why would you add #{name} more than once?"
      @signals[name] = Signal @scheduler

    connect: (name, event, one_shot = false, differed = false) =>
      if @signals[name] == nil
        error "Why would you connect non-existent signal - #{name}?"

      @signals[name]\connect event, one_shot, differed

    _connect: (name, event, one_shot = false, differed = false) =>
      if @signals[name] == nil
        error "Why would you connect non-existent signal - #{name}?"

      obj = @
      event = (...) ->
        obj[method] obj, ...

      @signals[name]\connect event, one_shot, differed
      event

    disconnect: (name, event) =>
      if @signals[name] == nil
        error "Why would you disconnect non-existent signal - #{name}?"

      @signals[name]\disconnect event

    emit: (name, ...) =>
      if @signals[name] != nil
        error "Why would you emit non-existent signal - #{name}?"

      @signals[name] ...

{
  :Object
}
