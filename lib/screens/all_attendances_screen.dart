import 'package:flutter/material.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';

class StudentAttendancesScreen extends StatefulWidget {
  final String tenantId;
  final Student student;

  const StudentAttendancesScreen({
    super.key,
    required this.tenantId,
    required this.student,
  });

  @override
  State<StudentAttendancesScreen> createState() =>
      _StudentAttendancesScreenState();
}

class _StudentAttendancesScreenState extends State<StudentAttendancesScreen> {
  late DateTime startDate;
  late DateTime endDate;
  late Future<List<Attendance>> attendanceFuture;

  @override
  void initState() {
    super.initState();
    final today = DateUtils.dateOnly(DateTime.now());
    startDate = DateTime(today.year, today.month);
    endDate = today;
    attendanceFuture = _fetchAttendances();
  }

  Future<List<Attendance>> _fetchAttendances() async {
    final attendances = await DataStoreReadService().getAttendanceRange(
      startDate,
      endDate,
      widget.tenantId,
    );
    return attendances
        .where((attendance) => attendance.student.id == widget.student.id)
        .toList()
      ..sort(
        (first, second) =>
            second.date.getDateTime().compareTo(first.date.getDateTime()),
      );
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: isStartDate ? DateTime(1950) : startDate,
      lastDate: isStartDate ? endDate : DateUtils.dateOnly(DateTime.now()),
    );
    if (pickedDate == null || !mounted) return;

    setState(() {
      if (isStartDate) {
        startDate = DateUtils.dateOnly(pickedDate);
      } else {
        endDate = DateUtils.dateOnly(pickedDate);
      }
      attendanceFuture = _fetchAttendances();
    });
  }

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencias de ${widget.student.name ?? 'alumno'}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(isStartDate: true),
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Desde ${_formatDate(startDate)}'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('a'),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(isStartDate: false),
                    icon: const Icon(Icons.event),
                    label: Text('Hasta ${_formatDate(endDate)}'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Attendance>>(
              future: attendanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No se pudieron cargar las asistencias.'),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              attendanceFuture = _fetchAttendances();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final attendances = snapshot.data ?? [];
                if (attendances.isEmpty) {
                  return const Center(
                    child: Text('No hay asistencias en este periodo.'),
                  );
                }

                return ListView.separated(
                  itemCount: attendances.length,
                  separatorBuilder:
                      (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final attendance = attendances[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.check_circle_outline),
                      ),
                      title: Text(_formatDate(attendance.date.getDateTime())),
                      subtitle: Text(
                        'Asistencia registrada${attendance.prof_id == null ? '' : ' por ${attendance.prof_id}'}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
