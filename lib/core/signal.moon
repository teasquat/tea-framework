class Signal
  new: (@scheduler) =>
    @list = {}

    @_in_emit   = false
    @_to_remove = {}

  connect: (event, one_shot = false, differed = false) =>
    entry = {
      :event
      :one_shot
      :differed
    }

    if differed and not @scheduler
      error "Why would you differate a function without a scheduler?"

    table.insert @list, entry

  disconnect: (event) =>
    for i, entry in ipairs @list
      if entry.event == event
        unless @_in_emit
          table.remove @list, i
        else
          table.insert @_to_remove, i
        return

  __call: (...) =>
    @_in_emit = true

    for idx, entry in ipairs @list
      unless entry.differed
        entry.event ...
      else
        event = entry.event
        args  = {...}

        @scheduler\differed ->
          event unpack args

      if entry.one_shot
        table.insert @_to_remove, idx

    table.sort @_to_remove

    for i, idx in ipairs @_to_remove
      table.remove @list, idx - i + 1

    @_to_remove = {}
    @_in_emit   = false

{
  :Signal
}
