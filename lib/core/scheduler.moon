class Scheduler
  new: =>
    @list = {}

  delayed: (time, event) =>
    entry = {
      :event
      :time
    }

    table.insert @list, entry

  differed: (event) =>
    entry = {
      :event
      time: 0
    }

    table.insert @list, entry

  process: (dt) =>
    temp = {}

    for i, entry in ipairs @list
      if entry.time <= 0
        entry.event!
        table.insert temp, i

      entry.time -= dt

    table.sort temp

    for i, idx in ipairs temp
      table.remove @list, idx - i + 1

{
  :Scheduler
}
