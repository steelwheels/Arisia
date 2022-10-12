{
  s: number %{ return 1 + 2 ;  %}

  init0: init %{
    console.print("s = " + root.s + "\n") ;
  %}
}

