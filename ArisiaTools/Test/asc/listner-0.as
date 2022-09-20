{
  f0: Frame {
    p0: number 1
  }

  f1: Frame {
    p1: number 2
  }

  f2: Frame {
    l0: number listner(p0: root.f0.p0, p1: root.f1.p1) %{
      return p0 + p1 ;
    %}
  }

  init0: init %{
	console.print("l0 = " + root.f2.l0 + "\n") ;

	root.f0.p0 = 3 ;
	root.f1.p1 = 4 ;
	console.print("l0 = " + root.f2.l0 + "\n") ;
  %}
}

