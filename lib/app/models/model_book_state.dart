class ModelBookState{
  String? key;
  String name(){
    String name = "";
    if(key == "ready") {
      name = "구매예정";
    } else if(key == "reading") {
      name = "읽는중";
    } else if(key == "out") {
      name = "방출";
    }
    return name;
  }

  ModelBookState(this.key);
}