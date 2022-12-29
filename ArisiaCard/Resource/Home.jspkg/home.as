{
  alignment: Alignment center
  logo: Image {
    name:  string  "arisia_icon"
  }
  icons_table: Collection {
    collection:   string[] ["play", "gearshape"]
    columnNumber: number   3
    pressed: event(section: number, item: number) %{
      switch(item){
        case 0:
	  /* run */
          let url = openPanel("Select application",
					FileType.file, ["jspkg"]) ;
          if(url != null){
	    if(FileManager.isReadable(url)){
	      run(url, [], _stdin, _stdout, _stderr) ;
	    } else {
              console.log("Not readable") ;
	    }
          }
        break ;
        case 1:
	  /* preference */
	  enterView("preference", null) ;
        break ;
      }
    %}
  }
}

