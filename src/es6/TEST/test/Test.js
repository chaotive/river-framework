export class Test {
  constructor() {
    this.sv = 1
    console.log("hola")
    pepe()
  }

  pepe(val){
    console.log("pepe")
    return val + 1
  }
}

export class Test2 {
  static m() {
    return 2
  }
  paf(){
    console.log("hola")
  }
}