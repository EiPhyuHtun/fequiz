import 'package:mysql1/mysql1.dart';

class Mysql{
  static String host='192.168.99.91',
  user='root',
  db='fequiz_db';
  static int port= 3306 ;
  
  Mysql();

   Future<MySqlConnection> getConnection() async{
    print("get connection....");
    var settings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        db: db
        );
        print("Connect...");
        print('Connecting to host: ${settings.host}, port: ${settings.port}');

        var conn = await MySqlConnection.connect(settings);
    return conn; 
   }

}