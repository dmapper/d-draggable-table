_ = require 'lodash'

defaultData = [
    { cells: [1, 'a', '2', 'helo', '1'] },
    { cells: [3, 'b', '1', 'world', '3'] },
    { cells: [2, 'd', '3', 'test', 'a'] },
    { cells: [4, 'c', '4', 'string', 'c'] }
  ]

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
  view: __dirname
  style: __dirname

  init: ->

  create: ->
    @data = @model.get('data') || defaultData
    @headers = @model.get('headers') || [1..@data[0].cells.length]
    @model.set('table', @data)
    @model.set('headers', @headers)

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