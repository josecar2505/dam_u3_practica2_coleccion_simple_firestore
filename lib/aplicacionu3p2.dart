import 'package:dam_u3_practica2/serviciosremotos.dart';
import 'package:flutter/material.dart';

class AppU3P2 extends StatefulWidget {
  const AppU3P2({super.key});

  @override
  State<AppU3P2> createState() => _AppU3P2State();
}

class _AppU3P2State extends State<AppU3P2> {
  String idAux = "";
  int _index = 0;
  double total = 0.0, nuevoTotal = 0.0;
  Color hoy = Colors.white;
  List productos = ["Kro-peek Cachorro Premium", "Kro-peek Adulto Premium", "Krokee Rico", "Kro-peek Cachorro Esencial"];
  List productos2 = ["Kro-peek Cachorro Premium", "Kro-peek Adulto Premium", "Krokee Rico", "Kro-peek Cachorro Esencial"];
  String productoSeleccionado = "", productoSeleccionadoAct = "";
  String precioProducto = "", precioProductoAct = "";

  //Para el insertar
  final nombre = TextEditingController();
  final direccion = TextEditingController();
  final telefono = TextEditingController();
  final concepto = TextEditingController();
  final f_entrega = TextEditingController();
  final cantidad = TextEditingController();
  final precioU = TextEditingController();

  //Para el actualizar
  final f_entregaact = TextEditingController();
  final nombreact = TextEditingController();
  final direccionact = TextEditingController();
  final telefonoact = TextEditingController();
  final cantidadact = TextEditingController();
  final conceptoact = TextEditingController();
  final precioUact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FORRAJERA BARAJAS"),
        centerTitle: true,
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.pets_sharp)
                  ),
                  SizedBox(height: 20,),
                  Text("Kroo-Peek", style: TextStyle(color: Colors.white, fontSize: 20),)
                ],
              ),
              decoration: BoxDecoration(color: Colors.indigoAccent),
            ),
            _item(Icons.today, "Entregas hoy", 0),
            _item(Icons.list_alt_sharp, "Registro de pedidos", 1),
            _item(Icons.add_box_outlined, "Nuevo pedido", 2),
          ],
        ),
      ),
    );
  }

  Widget dinamico() {
    if (_index == 1) {return mostrar();}
    if (_index == 2) {return insertar();}
    if (_index == 0) {return mostrarHoy();}
    return Center();
  }

  Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: () {
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [
          Expanded(child: Icon(icono)),
          Expanded(
            child: Text(texto),
            flex: 2,
          )
        ],
      ),
    );
  }

  Widget mostrarHoy() {
    return FutureBuilder(
      future: DB.entregasHoy(),
      builder: (context, listaJSON) {
        if (listaJSON.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("PEDIDOS EL DÍA DE HOY",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: listaJSON.data?.length,
                    itemBuilder: (context, indice) {
                     final cantidad = listaJSON.data?[indice]['cantidad'] as int? ?? 0;

                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${listaJSON.data?[indice]['fecha']}",
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              Text("Entregar en: ${listaJSON.data?[indice]['direccion']}",
                                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                              Text("${listaJSON.data?[indice]['nombre']}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue,),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Producto: ${listaJSON.data?[indice]['concepto']}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange),
                              ),
                              Text(
                                "Total a pagar:  \$${listaJSON.data?[indice]['total'].toStringAsFixed(2)}", // Formato de moneda
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cant:",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${cantidad}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.warning_amber_outlined, color: Colors.red,),
                                            SizedBox(width: 8,),
                                            Text("Comprobar eliminación.", style: TextStyle(color: Colors.red),)
                                          ],
                                        ),
                                      ),
                                      content: Text("¿Estas seguro que deseas eliminar el registro?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                DB.eliminar(listaJSON.data?[indice]['id']).then((value) {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SE ELIMINÓ CORRECTAMENTE")));
                                                });
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Si")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No")),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.delete),
                          ),
                          onTap: () {
                            setState(() {
                              idAux = listaJSON.data?[indice]['id'];
                              f_entregaact.text = listaJSON.data?[indice]['fecha'];
                              nombreact.text = listaJSON.data?[indice]['nombre'];
                              direccionact.text = listaJSON.data?[indice]['direccion'];
                              telefonoact.text =  listaJSON.data?[indice]['telefono'];
                              cantidadact.text = listaJSON.data![indice]['cantidad'].toString();
                              productoSeleccionadoAct =listaJSON.data?[indice]['concepto'];
                              precioUact.text = listaJSON.data![indice]['precioU'].toString();
                              nuevoTotal = listaJSON.data![indice]['total'];
                              actualizarProducto();
                            });
                          },
                        ),
                      );
                    },
                  )
              )
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget mostrar() {
    return FutureBuilder(
      // Supongamos que DB.mostrarTodos() devuelve un Future con la lista de datos
      future: DB.mostrarTodos(),
      builder: (context, listaJSON) {
        if (listaJSON.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("HISTORIAL DE PEDIDOS",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black,),
                  ),
                ),
              ),
              Expanded(child: ListView.builder(
                itemCount: listaJSON.data?.length,
                itemBuilder: (context, indice) {
                  final cantidad = listaJSON.data?[indice]['cantidad'] as int? ?? 0;
                  final fechaEntrega =  listaJSON.data?[indice]['fecha'];
                  final seEntregaHoy = fechaEntrega == DateTime.now().toString().split(" ")[0];
                  final hoy = seEntregaHoy ? Colors.limeAccent : Colors.white;
                  return Card(
                    color: hoy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                       // tileColor: hoy,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${listaJSON.data?[indice]['fecha']}",
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                            textAlign: TextAlign.right,
                          ),
                          Text("Entregar en: ${listaJSON.data?[indice]['direccion']}",
                            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                          Text("${listaJSON.data?[indice]['nombre']}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue,),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Producto: ${listaJSON.data?[indice]['concepto']}",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                          ),
                          Text("Total a pagar:  \$${listaJSON.data?[indice]['total'].toStringAsFixed(2)}", // Formato de moneda
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Cant:",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          SizedBox(height: 4),
                          Text("${cantidad}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.warning_amber_outlined, color: Colors.red,),
                                        SizedBox(width: 8,),
                                        Text("Comprobar eliminación.", style: TextStyle(color: Colors.red),)
                                      ],
                                    ),
                                  ),
                                  content: Text("¿Estas seguro que deseas eliminar el registro?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            DB.eliminar(listaJSON.data?[indice]['id']).then((value) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SE ELIMINÓ CORRECTAMENTE")));
                                            });
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Si")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("No")),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.delete),
                      ),
                      onTap: () {
                        setState(() {
                          idAux = listaJSON.data?[indice]['id'];
                          f_entregaact.text = listaJSON.data?[indice]['fecha'];
                          nombreact.text = listaJSON.data?[indice]['nombre'];
                          direccionact.text = listaJSON.data?[indice]['direccion'];
                          telefonoact.text = listaJSON.data?[indice]['telefono'];
                          cantidadact.text = listaJSON.data![indice]['cantidad'].toString();
                          productoSeleccionadoAct =listaJSON.data?[indice]['concepto'];
                          precioUact.text = listaJSON.data![indice]['precioU'].toString();
                          nuevoTotal = listaJSON.data![indice]['total'];
                          actualizarProducto();
                        });
                      },
                    ),
                  );
                },
              ))
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget insertar() {
    cantidad.text = cantidad.text;
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Center(
          child: Text("N U E V O   P E D I D O",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: nombre,
          decoration: InputDecoration(icon: Icon(Icons.person), labelText: "Nombre:"),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: direccion,
          decoration: InputDecoration(
              icon: Icon(Icons.location_on), labelText: "Dirección:"),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: telefono,
          decoration: InputDecoration(
              icon: Icon(Icons.phone_android), labelText: "Teléfono"),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 15,
        ),
        DropdownButtonFormField(
          value: productos.first,
          items: productos.map((e) {
            return DropdownMenuItem(
              child: Text(e),
              value: e,
            );
          }).toList(),
          onChanged: (item) {
            setState(() {
              productoSeleccionado = item.toString();
              if (productoSeleccionado == productos[0]) {
                precioProducto = "420";
              }
              if (productoSeleccionado == productos[1]) {
                precioProducto = "515";
              }
              if (productoSeleccionado == productos[2]) {
                precioProducto = "510";
              }
              if (productoSeleccionado == productos[3]) {
                precioProducto = "470";
              }

              precioU.text = precioProducto;
              int cant = int.parse(cantidad.text);
              double preUnit = double.parse(precioU.text);
              total = cant * preUnit;
            });
          },
          decoration: InputDecoration(
            labelText: "Selecciona un producto",
            // Añade un icono al inicio del DropdownButtonFormField
            icon: Icon(Icons.shopping_cart),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: f_entrega,
          decoration: InputDecoration(
              //filled: true,
              icon: Icon(Icons.calendar_today),
              labelText: "Fecha de entrega:"),
          textAlign: TextAlign.center,
          readOnly: true,
          onTap: () {
            _selectDate(f_entrega);
          },
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: cantidad,
                decoration: InputDecoration(
                    labelText: "Cantidad:", icon: Icon(Icons.numbers_outlined)),
                onChanged: (value) {
                  setState(() {
                    int cant = int.parse(cantidad.text);
                    double preUnit = double.parse(precioU.text);
                    total = cant * preUnit;
                  });
                },
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: precioU,
                decoration: InputDecoration(
                    icon: Icon(Icons.price_change_outlined),
                    labelText: "Precio Unitario",
                    hintText: precioProducto),
                keyboardType: TextInputType.number,
                enabled: false,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Center(
          child: Text(
            "Total: $total",
            style: TextStyle(
                fontSize: 20, backgroundColor: Colors.lightBlueAccent),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () {
              int cant = int.parse(cantidad.text);
              double preUnit = double.parse(precioU.text);
              total = cant * preUnit;

              var JsonTemporal = {
                'nombre': nombre.text,
                'direccion': direccion.text,
                'telefono': telefono.text,
                'concepto': productoSeleccionado,
                'cantidad': int.parse(cantidad.text),
                'precioU': int.parse(precioU.text),
                'fecha': f_entrega.text,
                'total': total
              };
              DB.insertar(JsonTemporal).then((value) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("EL PEDIDO SE AGREGÓ CON ÉXITO")));
                  nombre.text = "";
                  direccion.text = "";
                  telefono.text = "";
                  concepto.text = "";
                  cantidad.text = "";
                  precioU.text = "";
                  total = 0;
                });
              });
            },
            child: Text("REGISTRAR"))
      ],
    );
  }

  void actualizarProducto() {
    nuevoTotal = nuevoTotal;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "ACTUALIZAR PEDIDO",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nombreact,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Nombre:",
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: direccionact,
                  decoration: InputDecoration(
                    icon: Icon(Icons.location_on),
                    labelText: "Dirección:",
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: telefonoact,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone_android),
                    labelText: "Teléfono",
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  value: productoSeleccionadoAct,
                  items: productos2.map((e) {
                    return DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (item) {
                    setState(() {
                      productoSeleccionadoAct = item.toString();
                      if (productoSeleccionadoAct == productos2[0]) {
                        precioProductoAct = "420";
                      }
                      if (productoSeleccionadoAct == productos2[1]) {
                        precioProductoAct = "515";
                      }
                      if (productoSeleccionadoAct == productos2[2]) {
                        precioProductoAct = "510";
                      }
                      if (productoSeleccionadoAct == productos2[3]) {
                        precioProductoAct = "470";
                      }

                      precioUact.text = precioProductoAct;
                      int cant = int.parse(cantidadact.text);
                      double preUnit = double.parse(precioUact.text);
                      nuevoTotal = cant * preUnit;
                      print("El nuevo total es: $nuevoTotal");
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Selecciona un producto",
                    icon: Icon(Icons.shopping_cart),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: f_entregaact,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Fecha de entrega:",
                  ),
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: () {
                    _selectDate(f_entregaact);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cantidadact,
                        decoration: InputDecoration(
                          labelText: "Cantidad:",
                          icon: Icon(Icons.numbers_outlined),
                        ),
                        onChanged: (value) {
                          setState(() {
                            int cant = int.parse(cantidadact.text);
                            double preUnit = double.parse(precioUact.text);
                            nuevoTotal = cant * preUnit;
                          });
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: precioUact,
                        decoration: InputDecoration(
                          icon: Icon(Icons.price_change_outlined),
                          labelText: "Precio Unitario",
                          hintText: precioProductoAct,
                        ),
                        keyboardType: TextInputType.number,
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        var JsonTemporal = {
                          'id': idAux,
                          'nombre': nombreact.text,
                          'direccion': direccionact.text,
                          'telefono': telefonoact.text,
                          'concepto': productoSeleccionadoAct,
                          'cantidad': int.parse(cantidadact.text),
                          'precioU': int.parse(precioUact.text),
                          'fecha': f_entregaact.text,
                          'total': nuevoTotal
                        };
                        DB.actualizar(JsonTemporal).then((value) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("EL PEDIDO SE ACTUALIZÓ CON ÉXITO")));
                            nombreact.text = "";
                            direccionact.text = "";
                            telefonoact.text = "";
                            conceptoact.text = "";
                            cantidadact.text = "";
                            f_entregaact.text = "";
                            precioU.text = "";
                            nuevoTotal = 0;
                          });
                          Navigator.pop(context);
                        });
                      },
                      child: Text("ACTUALIZAR"),
                    ),
                    SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Text("CANCELAR"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(TextEditingController controlador) async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        controlador.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
