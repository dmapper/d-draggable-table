d-draggable-table
=================

## Usage

### App index
```coffee
app.component require('./d-draggable-table/components/sortable-table')
app.component require('./d-draggable-table/d-draggable-table')
```

### Styles
```coffee
@import ../components/d-draggable-table/d-draggable-table.sass
```

### Data format
```coffee
defaultData = [ 
  { cells: ['hello', 'hello', 'hello', 'hello', 'hello'] },
  { cells: ['world', 'world', 'world', 'world', 'world'] },
  { cells: ['hey', 'hey', 'hey', 'hey', 'hey'] },
  { cells: ['ho', 'ho', 'ho', 'ho', 'ho'] } 
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
