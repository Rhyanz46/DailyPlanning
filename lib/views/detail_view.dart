// detail_view.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailView extends StatefulWidget {
  const DetailView({Key? key}) : super(key: key);

  @override
  _DetailView createState() => _DetailView();
}

class _DetailView extends State<DetailView> {
  List<String> dataList = []; // List untuk menyimpan data input
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail View'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'List Data Input',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dataList[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: textEditingController,
              decoration: const InputDecoration(
                labelText: 'Tambahkan Data Baru',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addData();
                  },
                  child: const Text('Tambahkan Data'),
                ),
                ElevatedButton(
                  onPressed: () {
                    addData();
                    goToNextPage();
                  },
                  child: const Text('Selesai'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addData() {
    String newData = textEditingController.text.trim();
    if (newData.isNotEmpty) {
      setState(() {
        dataList.add(newData);
        textEditingController.clear();
      });
    }
  }

  void goToNextPage() {
    // Beralih ke view baru menggunakan GetX
    Get.to(() => NextView(dataList: dataList));
  }
}

class NextView extends StatefulWidget {
  final List<String> dataList;

  const NextView({Key? key, required this.dataList}) : super(key: key);

  @override
  _NextViewState createState() => _NextViewState();
}

class _NextViewState extends State<NextView> {
  List<DayData> editedList = [];

  @override
  void initState() {
    super.initState();
    editedList = widget.dataList.map((data) => DayData(data, {})).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next View'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data yang Diterima:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: editedList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // title: Text(
                    //     '${editedList[index].data} - ${getFormattedTime(
                    //         editedList[index].times)}'),
                    title: Text(editedList[index].data),
                    onTap: () {
                      showEditPopup(index);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan data
                // Contoh: saveData();

                // Mengonversi list data yang disimpan menjadi JSON
                // String jsonData = jsonEncode(editedList.map((dayData) =>
                // {
                //   'data': dayData.data,
                //   'times': dayData.times.map((dayIndex, timeRange) =>
                //   {
                //     'dayIndex': dayIndex,
                //     'startTime': timeRange.startTime?.toString(),
                //     'endTime': timeRange.endTime?.toString(),
                //   }).toList(),
                // }
                // ).toList());

                // Lakukan navigasi ke halaman Overview Data
                Get.to(() => OverviewData(dataList: editedList));
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void showEditPopup(int index) {
    Map<int, TimeRange> selectedDays = Map.from(editedList[index].times);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Mengaktifkan scroll untuk mengatasi bottom overflow
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: TextEditingController(
                                text: editedList[index].data),
                            decoration: const InputDecoration(
                                labelText: 'Data'),
                          ),
                          const SizedBox(height: 10),
                          const Text('Pilih Hari:'),
                          for (int i = 0; i < 7; i++)
                            CheckboxListTile(
                              title: Text(getDayName(i)),
                              value: selectedDays.containsKey(i),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    selectedDays[i] = TimeRange();
                                  } else {
                                    selectedDays.remove(i);
                                  }
                                });
                              },
                            ),
                          const SizedBox(height: 10),
                          for (int dayIndex in selectedDays.keys)
                            Column(
                              children: [
                                Text('Waktu untuk ${getDayName(dayIndex)}:'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                        'Waktu Mulai: ${selectedDays[dayIndex]!
                                            .startTime?.format(context) ??
                                            ''}'),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        TimeOfDay? selectedTime =
                                        await showTimePicker(
                                          context: context,
                                          initialTime: selectedDays[dayIndex]!
                                              .startTime ??
                                              TimeOfDay.now(),
                                        );
                                        if (selectedTime != null) {
                                          setState(() {
                                            selectedDays[dayIndex]!.startTime =
                                                selectedTime;
                                          });
                                        }
                                      },
                                      child: const Text('Pilih Waktu'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                        'Waktu Selesai: ${selectedDays[dayIndex]!
                                            .endTime?.format(context) ?? ''}'),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        TimeOfDay? selectedTime =
                                        await showTimePicker(
                                          context: context,
                                          initialTime:
                                          selectedDays[dayIndex]!.endTime ??
                                              TimeOfDay.now(),
                                        );
                                        if (selectedTime != null) {
                                          setState(() {
                                            selectedDays[dayIndex]!.endTime =
                                                selectedTime;
                                          });
                                        }
                                      },
                                      child: const Text('Pilih Waktu'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                editedList[index].data = editedList[index].data;
                                editedList[index].times =
                                    Map.from(selectedDays);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Simpan'),
                          ),
                        ],
                      ),
                    );
                  },
                )));
      },
    );
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'Minggu';
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      default:
        return '';
    }
  }

  String getFormattedTime(Map<int, TimeRange> times) {
    List<String> formattedTimes = [];
    for (int dayIndex in times.keys) {
      formattedTimes.add(
          '${getDayName(dayIndex)}: ${getFormattedTimeRange(
              times[dayIndex]!)}');
    }
    return formattedTimes.join(', ');
  }

  String getFormattedTimeRange(TimeRange timeRange) {
    return '${timeRange.startTime?.format(context) ?? ''} to ${timeRange.endTime
        ?.format(context) ?? ''}';
  }
}

class TimeRange {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
}

class DayData {
  String data;
  Map<int, TimeRange> times;

  DayData(this.data, this.times);
}

class OverviewData extends StatelessWidget {
  final List<DayData> dataList;

  const OverviewData({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview Data'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data yang Disimpan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Data: ${dataList[index].data}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Waktu: ${getFormattedTime(dataList[index].times)}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getFormattedTime(Map<int, TimeRange> times) {
    List<String> formattedTimes = [];
    for (int dayIndex in times.keys) {
      formattedTimes.add('${getDayName(dayIndex)}: ${getFormattedTimeRange(times[dayIndex]!)}');
    }
    return formattedTimes.join(', ');
  }

  String getFormattedTimeRange(TimeRange timeRange) {
    // return "aaaaa";
    return '${timeRange.startTime ?? ''} to ${timeRange.endTime ?? ''}';
  }

  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'Minggu';
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      default:
        return '';
    }
  }
}
