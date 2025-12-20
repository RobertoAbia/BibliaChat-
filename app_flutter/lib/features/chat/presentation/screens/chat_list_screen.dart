import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      ChatTopic(
        key: 'familia_separada',
        title: 'Oración por familia separada',
        icon: '🏠',
        description: 'Para quienes tienen familiares lejos',
      ),
      ChatTopic(
        key: 'desempleo',
        title: 'Fe en desempleo',
        icon: '💼',
        description: 'Cuando el trabajo escasea',
      ),
      ChatTopic(
        key: 'solteria',
        title: 'Soltería cristiana',
        icon: '💝',
        description: 'Vivir la soltería con propósito',
      ),
      ChatTopic(
        key: 'ansiedad_miedo',
        title: 'Ansiedad y miedo',
        icon: '🕊️',
        description: 'Encontrar paz en tiempos difíciles',
      ),
      ChatTopic(
        key: 'identidad_bicultural',
        title: 'Identidad bicultural',
        icon: '🌎',
        description: 'Entre dos mundos y culturas',
      ),
      ChatTopic(
        key: 'reconciliacion',
        title: 'Reconciliación familiar',
        icon: '🤝',
        description: 'Sanar relaciones rotas',
      ),
      ChatTopic(
        key: 'sacramentos',
        title: 'Bautismo / Confirmación',
        icon: '✝️',
        description: 'Preguntas sobre sacramentos',
      ),
      ChatTopic(
        key: 'oracion',
        title: 'Oración personalizada',
        icon: '🙏',
        description: 'Orar juntos sobre tu situación',
      ),
      ChatTopic(
        key: 'preguntas_biblia',
        title: 'Preguntas sobre la Biblia',
        icon: '📖',
        description: 'Dudas y estudios bíblicos',
      ),
      ChatTopic(
        key: 'otro',
        title: 'Otro tema',
        icon: '💬',
        description: 'Cualquier otra cosa en tu corazón',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '¿Sobre qué quieres conversar hoy?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(
                      topic.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(topic.title),
                    subtitle: Text(topic.description),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/chat/${topic.key}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatTopic {
  final String key;
  final String title;
  final String icon;
  final String description;

  ChatTopic({
    required this.key,
    required this.title,
    required this.icon,
    required this.description,
  });
}
