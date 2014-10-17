d-draggable-table
=================
Derby draggable table component. Based on derby sink.

## Usage

#### Install
```
npm install d-draggable-table
```

### App index
```coffee
app.component require('./d-draggable-table/components/sortable-table')
app.component require('./d-draggable-table')
```

### Styles
```coffee
@import ../components/d-draggable-table/index.sass
```

### Data format
```coffee
defaultData = [ 
  { cells: [1, 'a', '2', 'helo',   '1'] },
  { cells: [3, 'b', '1', 'world',  '3'] },
  { cells: [2, 'd', '3', 'test',   'a'] },
  { cells: [4, 'c', '4', 'string', 'c'] } 
]

```

### WIthin template

```jade
view(name='d-draggable-table')
```
You can pass table and headers data parameters to the component as follows:
```jade
view(name='d-draggable-table', table='{{_page.data}}', headers='{{_page.headers}}')
```
