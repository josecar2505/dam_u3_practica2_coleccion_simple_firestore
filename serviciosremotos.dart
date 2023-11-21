import 'package:cloud_firestore/cloud_firestore.dart';


var baseremota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String, dynamic> pedido) async{
    return await baseremota.collection("pedido").add(pedido);
  }

  static Future<List> mostrarTodos() async{
    List temp = [];
    var query = await baseremota.collection("pedido").orderBy('fecha').get();

    query.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id': element.id
      });

      temp.add(dato);
    });

    return temp;
  }

  static Future<List> entregasHoy() async{
    List temp = [];
    String fechaHoy = DateTime.now().toString().split(" ")[0];
    var query = await baseremota.collection("pedido").where('fecha', isEqualTo: fechaHoy).get();

    query.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id': element.id
      });

      temp.add(dato);
    });

    return temp;
  }


  static Future eliminar(String id) async {
    return await baseremota.collection("pedido").doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> pedido) async {
    String id = pedido['id']; //Obtener el id de persona en formato JSON
    pedido.remove('id'); //Quitar el id de persona

    return await baseremota.collection("pedido").doc(id).update(pedido);
  }
}