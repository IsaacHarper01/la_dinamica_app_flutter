import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:la_dinamica_app/backend/results.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

Future<void> uploadPaymentsFromCsv()async{
  final rows = data.split('\n');
  safePrint('Filas leídas del CSV: ${rows.length}');
  final aws = DataStoreReadService();
  final aws2 = DataStoreService();
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
    safePrint('Finished Column $i');
    }
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
      date: TemporalDate(DateTime.parse(columns[3])),
      client_id: columns[4],
      prof_id: columns[5],
      student: mapStudents[columns[2]],
      status: true
    ); 
    safePrint('Finished Column $i');
    }
}

Map<String, Map<String, dynamic>> adaptMapGrades(Map<String, Map<String, dynamic>> grades,) { // recive Map<Metric, Map<StudentID, Grade>>
        final Map<String, Map<String, dynamic>> result = {};

        for (final entry in grades.entries) {
          final metric = entry.key;
          final studentMap = entry.value;

          for (final studentEntry in studentMap.entries) {
            final student = studentEntry.key;
            final grade = studentEntry.value;

            result.putIfAbsent(student, () => {});
            result[student]![metric] = grade;
          }
        }
        return result; // return Map<StudentID, Map<MetricID, Grade>>
      }

Future<void> uploadStudentsGradesFromCsv(String tenantId)async{
  final aws = DataStoreService();
  final aws2 = DataStoreReadService();
  final students = await aws2.getAllStudents();
  final evalID = "2998469a-2c88-4665-9f69-56b31d059a35";
  final date = "2026-03-28";
  final allEval = await aws2.getEvaluations(tenantId);
  final grades = {};
  safePrint("GRADES CONVERTED: $grades");
  Map<String, Evaluations> mapEvals = {};
    for(var eval in allEval!){
      mapEvals[eval.id] = eval;
    }

  Map<String, Student> mapStudents = {};
    for(var student in students){
      mapStudents[student.id] = student;
    }

  for(var student in grades.keys){
      if(mapStudents[student] != null){
        safePrint("STUDENT: ${mapStudents[student]!.name}");  
        await aws.saveStudentExamResults(
          student: mapStudents[student]!, 
          eval: mapEvals[evalID]!, 
          grades: jsonEncode(grades[student]), 
          tenantId: tenantId, 
          date: DateTime.parse(date)
          );
      }

    }
  }


        