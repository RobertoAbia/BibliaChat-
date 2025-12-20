import 'package:flutter/material.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      StudyPlan(
        id: '1',
        name: 'Fe Cuando Familia Está Lejos',
        description: 'Para migrantes separados de familiares',
        days: 7,
        icon: '🏠',
      ),
      StudyPlan(
        id: '2',
        name: 'Trabajo y Provisión Divina',
        description: 'Cuando el trabajo escasea',
        days: 5,
        icon: '💼',
      ),
      StudyPlan(
        id: '3',
        name: 'Soltería Enraizada en Cristo',
        description: 'Vivir la soltería con propósito',
        days: 7,
        icon: '💝',
      ),
      StudyPlan(
        id: '4',
        name: 'Resiste la Ansiedad con Fe',
        description: 'Encontrar paz en tiempos difíciles',
        days: 5,
        icon: '🕊️',
      ),
      StudyPlan(
        id: '5',
        name: 'Gratitud en Medio del Caos',
        description: 'Cultivar gratitud en tiempos difíciles',
        days: 5,
        icon: '🙏',
      ),
      StudyPlan(
        id: '6',
        name: 'Discípulo en Dos Idiomas',
        description: 'Fe entre dos mundos',
        days: 7,
        icon: '🌎',
      ),
      StudyPlan(
        id: '7',
        name: 'Sanidad del Corazón Inmigrante',
        description: 'Sanar heridas del camino',
        days: 7,
        icon: '❤️‍🩹',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudiar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Plan (if any)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu Plan Activo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('🏠', style: TextStyle(fontSize: 32)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fe Cuando Familia Está Lejos',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Día 3 de 7',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: 3 / 7,
                            backgroundColor: Colors.grey[200],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Continuar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // All Plans
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planes de Estudio',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Planes diseñados para hispanohablantes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Text(
                      plan.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(plan.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan.description),
                        const SizedBox(height: 4),
                        Text(
                          '${plan.days} días',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to plan detail
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class StudyPlan {
  final String id;
  final String name;
  final String description;
  final int days;
  final String icon;

  StudyPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.days,
    required this.icon,
  });
}
