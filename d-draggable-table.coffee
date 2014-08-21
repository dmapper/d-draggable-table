module.exports = class DraggableTable
  view: __filename.replace /\..+$/, ''
  init: ->
    defaultData = [ { cells: ['hello', 'hello', 'hello', 'hello', 'hello'] },
      { cells: ['world', 'world', 'world', 'world', 'world'] },
      { cells: ['hey', 'hey', 'hey', 'hey', 'hey'] },
      { cells: ['ho', 'ho', 'ho', 'ho', 'ho'] } ]
    @model.setNull('table', defaultData)
    @model.setNull('headers', [1..@model.get('table')[0].cells.length])

  create: ->
    console.log(@model.get('table'))

  onRowMove: (from, to) ->
    @model.move('table', from, to)

  onColMove: (from, to) ->