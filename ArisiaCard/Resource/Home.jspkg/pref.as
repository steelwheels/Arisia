{
  title: Label {
    text: string  "Preference"
  }
  //doc: Label {
  //  text: string  %{ return FileManager.documentDirectory.path ; %}
  //}
  install: Label {
    text: string  "Install"
  }
  install_button: Button {
    title: string  "Install sample scripts"
    pressed: event() %{
      let resdir = FileManager.resourceDirectory ;
      if(resdir != null){
	let srcdir = resdir.appending("Samples") ;
        let docdir = FileManager.documentDirectory ;
	let dstdir = docdir.appending("Samples") ;
        if(srcdir != null && dstdir != null){
          if(!FileManager.copy(srcdir, dstdir)){
	    console.log("srcdir: " + srcdir.path) ;
	    console.log("dstdir: " + dstdir.path) ;
            console.error("Failed to copy sample directory\n") ;
	  }
        }
      } else {
        console.log("no resource directory") ;
      }
    %}
  }
  buttons: Box {
    axis: Axis horizontal

    ok_button: Button {
        title: string "OK"
        pressed: event() %{
         leaveView(0) ;
        %}
    }
    cancel_button: Button {
        title: string "Cancel"
        pressed: event() %{
         leaveView(1) ;
        %}
    }
  }

}

