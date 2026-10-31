
import 'package:flutter/material.dart';

void main() {
  runApp(const Lab1App());
}

class Lab1App extends StatelessWidget {
  const Lab1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ЛР 1'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Task 1:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                task1(),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),

                const Text(
                  'Task 2:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                task2(),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),

                const Text(
                  'Task 3:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                task3(),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),

                const Text(
                  'Task 4:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                task4(),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),

                const Text(
                  'Task 5:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                task5(),
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),

                const Text(
                  'Task 6:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                task6(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 1. Заголовок — крупный жирный текст чёрного цвета
Widget task1() {
  return const Text(
    'Мой первый заголовок',
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}

// 2. Подпись — небольшой белый курсивный текст
// на тёмно-сером фоне с закруглёнными углами
Widget task2() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text(
      'Это небольшая подпись под заголовком',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      ),
    ),
  );
}

// 3. Иконка — синяя звезда
Widget task3() {
  return const Icon(
    Icons.star,
    color: Colors.blue,
    size: 40,
  );
}

// 4. Кнопка избранного — красное сердце без фона
Widget task4() {
  return IconButton(
    iconSize: 40,
    color: Colors.red,
    onPressed: () {
      print('Вы добавили в избранное');
    },
    icon: const Icon(Icons.favorite),
  );
}

// 5. Кнопка «Подробнее» с обводкой
Widget task5() {
  return OutlinedButton(
    onPressed: () {
      print('Узнать детали');
    },
    child: const Text('Подробнее'),
  );
}

// 6. Изображение в стиле Polaroid
Widget task6() {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.black,
        width: 2,
      ),
    ),
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
      child: Image.network(
        'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
        width: 180,
        height: 130,
        fit: BoxFit.cover,
      ),
    ),
  );
}
