module.exports = class DraggableTable
  view: __filename.replace /\..+$/, ''
  init: ->

  create: ->

  onRowMove: (from, to) ->
    console.log from
    console.log to

  onColMove: (from, to) ->
    console.log from
    console.log to