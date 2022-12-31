/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/pref-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box() as root_BoxIF ;
/* define type for all properties */
root._definePropertyType("title", "o(Label)") ;
root._definePropertyType("doc", "o(Label)") ;
root._definePropertyType("buttons", "o(Box)") ;
root._definePropertyType("frameName", "s") ;
root._definePropertyType("alignment", "e(Alignment)") ;
root._definePropertyType("propertyNames", "a(s)") ;
root._definePropertyType("axis", "e(Axis)") ;
root._definePropertyType("distribution", "e(Distribution)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment","axis","buttons","distribution","doc","frameName","propertyNames","title"]) ;
{
  /* allocate function for frame: Label */
  let title = _alloc_Label() as root_title_LabelIF ;
  /* define type for all properties */
  title._definePropertyType("text", "s") ;
  title._definePropertyType("number", "n") ;
  title._definePropertyType("propertyNames", "a(s)") ;
  title._definePropertyType("frameName", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(title, ["frameName","number","propertyNames","text"]) ;
  /* assign user declared properties */
  title.text = "Preference";
  root.title = title ;
}
{
  /* allocate function for frame: Label */
  let doc = _alloc_Label() as root_doc_LabelIF ;
  /* define type for all properties */
  doc._definePropertyType("text", "s") ;
  doc._definePropertyType("number", "n") ;
  doc._definePropertyType("propertyNames", "a(s)") ;
  doc._definePropertyType("frameName", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(doc, ["frameName","number","propertyNames","text"]) ;
  /* assign user declared properties */
  doc.text = (function() {
   return FileManager.documentDirectory.path ; 
  })();
  root.doc = doc ;
}
{
  /* allocate function for frame: Box */
  let buttons = _alloc_Box() as root_buttons_BoxIF ;
  /* define type for all properties */
  buttons._definePropertyType("axis", "e(Axis)") ;
  buttons._definePropertyType("ok_button", "o(Button)") ;
  buttons._definePropertyType("cancel_button", "o(Button)") ;
  buttons._definePropertyType("frameName", "s") ;
  buttons._definePropertyType("alignment", "e(Alignment)") ;
  buttons._definePropertyType("propertyNames", "a(s)") ;
  buttons._definePropertyType("distribution", "e(Distribution)") ;
  /* define getter/setter for all properties */
  _definePropertyIF(buttons, ["alignment","axis","cancel_button","distribution","frameName","ok_button","propertyNames"]) ;
  /* assign user declared properties */
  buttons.axis = Axis.horizontal;
  {
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button() as root_buttons_ok_button_ButtonIF ;
    /* define type for all properties */
    ok_button._definePropertyType("title", "s") ;
    ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])") ;
    ok_button._definePropertyType("isEnabled", "b") ;
    ok_button._definePropertyType("frameName", "s") ;
    ok_button._definePropertyType("propertyNames", "a(s)") ;
    /* define getter/setter for all properties */
    _definePropertyIF(ok_button, ["frameName","isEnabled","pressed","propertyNames","title"]) ;
    /* assign user declared properties */
    ok_button.title = "OK";
    ok_button.pressed = function(self: FrameIF): void {
             leaveView(0) ;
            };
    buttons.ok_button = ok_button ;
  }
  {
    /* allocate function for frame: Button */
    let cancel_button = _alloc_Button() as root_buttons_cancel_button_ButtonIF ;
    /* define type for all properties */
    cancel_button._definePropertyType("title", "s") ;
    cancel_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])") ;
    cancel_button._definePropertyType("isEnabled", "b") ;
    cancel_button._definePropertyType("frameName", "s") ;
    cancel_button._definePropertyType("propertyNames", "a(s)") ;
    /* define getter/setter for all properties */
    _definePropertyIF(cancel_button, ["frameName","isEnabled","pressed","propertyNames","title"]) ;
    /* assign user declared properties */
    cancel_button.title = "Cancel";
    cancel_button.pressed = function(self: FrameIF): void {
             leaveView(1) ;
            };
    buttons.cancel_button = cancel_button ;
  }
  root.buttons = buttons ;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root ;
