{
	s: [key:string]:number {a:10, b:20}

	init0: init %{
		console.print("keys = " + Object.keys(root.s) + "\n") ;
	%}
}

