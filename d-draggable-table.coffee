_ = require 'lodash'


bubbleSort = (list, field, model) ->
    anySwaps = false
    swapPass = ->
        for r in [0..list.length-2]
            if list[r].cells[field] > list[r+1].cells[field]
                anySwaps = true
                model.move('table', r, r+1)

    swapPass()
    while anySwaps
        anySwaps = false
        swapPass()
    list

StringSorter = (algorithm) ->
  sort: (list, field, model) -> algorithm list, field, model

module.exports = class DraggableTable
  view: __filename.replace /\..+$/, ''
  init: ->
    defaultData = [ { cells: [1, 'a', '2', 'helo', '1'] },
      { cells: [3, 'b', '1', 'world', '3'] },
      { cells: [2, 'd', '3', 'test', 'a'] },
      { cells: [4, 'c', '4', 'string', 'c'] } ]
    @model.setNull('table', defaultData)
    @model.setNull('headers', [1..@model.get('table')[0].cells.length])

  create: ->
    console.log(@model.get('table'))

  onRowMove: (from, to) ->
    @model.move('table', from, to)

  onColMove: (from, to) ->

  sort: (field) ->
    field = field|0
    console.log field
    table = @model.get 'table'
    if @model.get('sortBy') is field
      @model.set 'desc', !@model.get('desc')
    else
      @model.set 'desc', false
    sorter = new StringSorter(bubbleSort)
    sorter.sort(table, field, @model)
    table.reverse() if @model.get("desc")
    @model.set 'sortBy', field
    @model.set 'refresh', !@model.get('refresh')