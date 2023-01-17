interface root_BoxIF extends BoxIF {
  quit_button: root_quit_button_ButtonIF ;
  table: root_table_TableDataIF ;
}
interface root_table_TableDataIF extends TableDataIF {
  index: number ;
  newRecord(): storage_root_RecordIF ;
  path: string ;
  record(p0: number): storage_root_RecordIF ;
  storage: string ;
}
interface root_quit_button_ButtonIF extends ButtonIF {
}
