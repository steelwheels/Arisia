{
  table: TableData {
    storage: string "storage"
    path:    string "root"
    index:   number 0
  }
  init0: init %{
	console.print("index: " + root.table.index + "\n") ;
  %}
  quit_button: Button {
    title: string "Quit"
    pressed: event() %{
      leaveView(1) ;
    %}
  }
}

