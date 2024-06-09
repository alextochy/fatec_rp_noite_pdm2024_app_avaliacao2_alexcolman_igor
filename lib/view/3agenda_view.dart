import 'package:flutter/material.dart';

class AgendaView extends StatelessWidget {
  const AgendaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: [
            IconButtonWidget(
              icon: Icons.event_note_outlined,
              label: 'Notas',
              onTap: () {
                // Adicione a ação desejada aqui
              },
            ),
            IconButtonWidget(
              icon: Icons.alarm_on_outlined,
              label: 'Alarmes',
              onTap: () {
                // Adicione a ação desejada aqui
              },
            ),
            IconButtonWidget(
              icon: Icons.timer_outlined,
              label: 'Timer',
              onTap: () {
                // Adicione a ação desejada aqui
              },
            ),
            IconButtonWidget(
              icon: Icons.schedule_outlined,
              label: 'Horário',
              onTap: () {
                // Adicione a ação desejada aqui
              },
            ),
          ],
        ),
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const IconButtonWidget({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50.0, color: Colors.blueAccent),
          SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
