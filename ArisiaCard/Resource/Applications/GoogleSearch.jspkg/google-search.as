{
  title_label: Label {
    text: string "Google Search Helper"
  }
  ok_button: Button {
    title: string "OK"
    pressed: event() %{
      openURL("https://www.google.com/") ;
    %}
  }
}

