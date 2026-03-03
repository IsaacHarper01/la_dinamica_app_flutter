import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/backend/results.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

Future<void> uploadPaymentsFromCsv()async{
  final rows = data.split('\n');
  safePrint('Filas leídas del CSV: ${rows.length}');
  final aws = DataStoreReadService();
  final plans = await aws.getallPlans();
  Map<String, LocalPlan> mapPlans = {};
  for(var plan in plans){
    mapPlans[plan.id] = plan;
  }
  for (var i = 1; i < rows.length; i++ ){
    final  columns = rows[i].split(',');  
    final newPay = Payment(
      id: columns[0],
      composite_key: columns[1]+columns[6],
      user_id: int.parse(columns[3]),
      amount: double.parse(columns[4]),
      clases: int.parse(columns[5]),
      date: TemporalDate(DateTime.parse(columns[6])),
      client_id: columns[7],
      prof_id: columns[8],
      debt: columns[9]=='true' ? true : false,

      plan: mapPlans[columns[1]],
    );
    await Amplify.DataStore.save(newPay);
    safePrint('Finished Column $i');
    }
  Future<void> uploadAttendanceFromCsv()async{
    final rows = data2.split('\n');
    safePrint('Filas leídas del CSV: ${rows.length}');
    final aws = DataStoreReadService();
    final students = await aws.getAllStudents();
    Map<String, Student> mapStudents = {};
    for(var student in students){
      mapStudents[student.name!] = student;
    }
    for (var i = 1; i < rows.length; i++ ){
    final  columns = rows[i].split(',');
    final newAttendance = Attendance(
      id: columns[0],
      user_id: mapStudents[2]!.name!+columns[3],
      date: TemporalDate(DateTime.parse(columns[3])),
      client_id: columns[4],
      prof_id: columns[5],
      student: mapStudents[columns[2]],
    ); 
    await Amplify.DataStore.save(newAttendance);
    safePrint('Finished Column $i');
    }
  }
}