{
  a: number 1
  b: number 2

  l0: number listner(a: root.a, b: root.b) %{
	let c = a + b ;
	console.print("update: c = " + c + "\n") ;
	return c ;
  %}
}

