module.exports = class SortableTable
  name: 'sortable-table'

  create: ->
    @dragging = null
    @dom.addListener 'mousemove', document, (e) => @onMove(e)
    @dom.addListener 'mouseup', document, => @endDragging()
    @dom.addListener 'blur', window, => @endDragging(true)

  onRowDown: (e) ->
    @dragStart e, cloneRow, setTop, breakTop, '.row', finishRow, e.target.parentNode

  onColDown: (e) ->
    @dragStart e, cloneCol, setLeft, breakLeft, '.col', finishCol, e.target

  onMove: (e) ->
    return unless @dragging
    {parent, last, breakFn} = @dragging
    loc = @dragging.setFn e

    i = 0
    children = parent.querySelectorAll @dragging.selector
    i++ while loc > breakFn(
      if i < last then children[i] else children[i + 1]
    )
    unless i == last
      unless ref = children[if i < last then i else i + 1]
        ref = children[children.length - 1].nextSibling
      parent.insertBefore @dragging.clone, ref
    @dragging.last = i

  endDragging: (cancel) ->
    return unless @dragging
    @dragging.finish cancel
    document.body.removeChild @dragging.container
    @dragging = null

  dragStart: (e, cloneFn, setFn, breakFn, selector, finish, el) ->
    return if e.button != 0
    e.preventDefault?()
    container = document.createElement 'table'
    container.style.position = 'absolute'
    parent = el.parentNode
    rect = el.getBoundingClientRect()
    nodeOffset = targetIndex(parent.querySelector selector)
    index = targetIndex(el) - nodeOffset
    clone = cloneFn container, el, rect, parent, nodeOffset, index
    offsetLeft = rect.left - e.clientX
    offsetTop = rect.top - e.clientY
    @dragging = {component: this, el, parent, clone, nodeOffset, index, last: index, setFn, breakFn, selector, offsetLeft, offsetTop, finish, container}
    setLeft.call @dragging, e
    setTop.call @dragging, e
    document.body.appendChild container

targetIndex = (el) ->
  for child, i in el.parentNode.childNodes
    return i if child == el

setLeft = (e) ->
  loc = e.clientX
  @container.style.left = (loc + window.pageXOffset + @offsetLeft) + 'px'
  return loc

setTop = (e) ->
  loc = e.clientY
  @container.style.top = (loc + window.pageYOffset + @offsetTop) + 'px'
  return loc

breakLeft = (el) ->
  return unless el
  rect = el.getBoundingClientRect()
  rect.width / 2 + rect.left

breakTop = (el) ->
  return unless el
  rect = el.getBoundingClientRect()
  rect.height / 2 + rect.top

cloneRow = (container, el, rect, parent) ->
  spacerHtml = '<tr>'
  for child in el.children
    spacerHtml += "<td style=width:#{child.offsetWidth}px;height:0;padding:0>"
  clone = el.cloneNode(false)
  clone.removeAttribute 'id'
  clone.style.height = rect.height + 'px'
  container.innerHTML = clone.innerHTML = spacerHtml
  parent.insertBefore clone, el
  container.firstChild.appendChild el
  return clone

cloneCol = (container, el, rect, parent, nodeOffset, index) ->
  rows = parent.parentNode.children
  spacerHtml = ''
  for row in rows
    spacerHtml += "<tr class=#{row.className} style=height:#{row.offsetHeight}px;width:0;padding:0>"
  container.innerHTML = spacerHtml
  clone = el.cloneNode(false)
  clone.removeAttribute 'id'
  clone.setAttribute 'rowspan', rows.length
  clone.style.padding = 0
  clone.style.width = rect.width + 'px'
  nodeIndex = index + nodeOffset
  parent.insertBefore clone, parent.childNodes[nodeIndex + 1]
  cloneRows = container.firstChild.children
  for row, i in rows
    cloneRows[i].appendChild row.childNodes[nodeIndex]
  return clone

finishRow = (cancel) ->
  # Put things back where they started
  @parent.removeChild @clone
  @parent.insertBefore @el, @parent.childNodes[@index + @nodeOffset]
  # Actually do the move
  @component.emit 'rowMove', @index, @last  unless cancel

finishCol = (cancel) ->
  # Put things back where they started
  @parent.removeChild @clone
  rows = @parent.parentNode.children
  cloneRows = @container.firstChild.children
  nodeIndex = @index + @nodeOffset
  for row, i in rows
    row.insertBefore cloneRows[i].firstChild, row.childNodes[nodeIndex]
  # Actually do the move
  @component.emit 'colMove', @index, @last  unless cancel
