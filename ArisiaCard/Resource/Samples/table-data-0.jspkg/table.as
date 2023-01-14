{
  table: TableData {
    storage: string "storage"
    path:    string "root"
    index:   number 0
  }
  init0: init %{
    console.print("index: " + root.table.count + "\n") ;
    //console.print("c0:    " + root.table.record.c0 + "\n") ;
  %}
  quit_button: Button {
    title: string "Quit"
    pressed: event() %{
      leaveView(1) ;
    %}
  }
}

