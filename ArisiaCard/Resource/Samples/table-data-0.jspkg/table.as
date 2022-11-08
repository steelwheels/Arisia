{
  table: TableData {
    storage: string "storage"
    path:    string "root"
//     l_rcoount: Listner(count: self.recordCount) %{
//       console.log("recordCount: " + self.recordCount) ;
//     %}
//     l_fnames: Listner(fnames: self.fieldNames) %{
//       console.log("field-names: " + self.fieldNames) ;
//     %}
  }
  quit_button: Button {
    title: string "Quit"
    pressed: event() %{
      leaveView(1) ;
    %}
  }
}

