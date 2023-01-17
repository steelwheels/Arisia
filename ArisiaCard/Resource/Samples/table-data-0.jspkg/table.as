{
  table: TableData {
    storage: string "storage"
    path:    string "root"
    index:   number 0
  }
  quit_button: Button {
    title: string "Quit"
    pressed: event() %{
      console.print("count: " + root.table.count + "\n") ;
      //console.print("c0:    " + root.table.record(0).c0 + "\n") ;
      leaveView(1) ;
    %}
  }
}

