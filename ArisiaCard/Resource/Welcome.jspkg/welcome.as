{
  alignment: Alignment center
  logo: Image {
    name:  string  "arisia_icon"
  }
  icons_table: Collection {
    collection:   string[] ["run_icon", "pref_icon"]
    columnNumber: number   3
    pressed: event(section: number, item: number) %{
      switch(item){
        case 0:
	  /* run */
          let url = openPanel("Select application",
					FileType.file, ["jspkg"]) ;
          if(url != null){
	    if(FileManager.isReadable(url)){
              console.log("Readable path = " + (url.path ?? "null")) ;
	    } else {
              console.log("Not readable") ;
	    }
          }
        break ;
        case 1:
	  /* preference */
        break ;
      }
    %}
  }
}

