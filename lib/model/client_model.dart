class Client{

//los atributos del cliente
    int id;
    String name;
    String phone;

//creamos el constructor de la clase

Client ({this.id, this.name, this.phone});

//para poder insertar en la base de datos necesitamos crearnos un map
Map<String, dynamic> toMap() => {
  "id":id,
  "name":name,
  "phone": phone,
}; //finalizamos el map

//metodo para recibir los datos, pasamos el map a un json
factory Client.fromMap(Map<String, dynamic> json) => new Client(
  id: json["id"],
  name: json["name"],
  phone: json["phone"],
);




}