import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panel de hábitos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const PanelHabitos(),
    );
  }
}

class PanelHabitos extends StatefulWidget {
  const PanelHabitos({super.key});

  @override
  State<PanelHabitos> createState() => _PanelHabitosState();
}

class _PanelHabitosState extends State<PanelHabitos> {
  // ============================================================
  // DATOS FIJOS
  // ============================================================

  final List<String> _habitos = const [
    'Beber 2 L de agua',
    'Leer 20 minutos',
    'Caminar 30 minutos',
    'Estudiar Flutter',
    'Dormir 8 horas',
  ];

  // ============================================================
  // ESTADO
  // ============================================================

  late List<bool> _cumplidos;

  int _meta = 3;

  bool _enfoque = false;

  String _nota = '';

  final TextEditingController _notaCtrl = TextEditingController();

  static const int _metaInicial = 3;

  // ============================================================
  // CICLO DE VIDA
  // ============================================================

  @override
  void initState() {
    super.initState();

    _cumplidos = List<bool>.filled(_habitos.length, false);
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  // ============================================================
  // GETTERS DERIVADOS
  // ============================================================

  int get _totalCumplidos {
    return _cumplidos.where((cumplido) => cumplido).length;
  }

  double get _progreso {
    if (_habitos.isEmpty) {
      return 0;
    }

    return _totalCumplidos / _habitos.length;
  }

  bool get _metaAlcanzada {
    return _totalCumplidos >= _meta;
  }

  String get _mensaje {
    final int porcentaje = (_progreso * 100).round();

    if (porcentaje == 0) {
      return '¡Empecemos!';
    }

    if (porcentaje < 50) {
      return 'Buen inicio';
    }

    if (porcentaje < 100) {
      return '¡Vas muy bien!';
    }

    return '¡Día completado! 🎉';
  }

  // ============================================================
  // ACCIONES
  // ============================================================

  void _alternarHabito(int index) {
    setState(() {
      _cumplidos[index] = !_cumplidos[index];
    });
  }

  void _cambiarMeta(double valor) {
    setState(() {
      _meta = valor.round();
    });
  }

  void _alternarEnfoque(bool valor) {
    setState(() {
      _enfoque = valor;
    });
  }

  void _guardarNota() {
    setState(() {
      _nota = _notaCtrl.text.trim();
    });
  }

  void _reiniciarDia() {
    setState(() {
      _cumplidos = List<bool>.filled(_habitos.length, false);

      _meta = _metaInicial;

      _enfoque = false;

      _nota = '';

      _notaCtrl.clear();
    });
  }

  // ============================================================
  // INTERFAZ
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hábitos — Cumplidos: '
          '$_totalCumplidos / ${_habitos.length}',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ======================================================
          // ENCABEZADO
          // ======================================================

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline, size: 50),

                  const SizedBox(height: 10),

                  Text(
                    'Panel de hábitos del día',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Mantén el seguimiento de tus hábitos '
                    'y alcanza tu meta diaria.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // PROGRESO
          // ======================================================
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progreso del día',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text(
                        '${(_progreso * 100).round()} %',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  LinearProgressIndicator(
                    value: _progreso,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    '$_totalCumplidos de ${_habitos.length} '
                    'hábitos cumplidos',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // MENSAJE MOTIVACIONAL
          // ======================================================
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.emoji_emotions_outlined, size: 40),

                  const SizedBox(height: 10),

                  Text(
                    _mensaje,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // META DEL DÍA
          // ======================================================
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meta del día',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Selecciona cuántos hábitos quieres '
                    'cumplir hoy.',
                  ),

                  const SizedBox(height: 8),

                  Slider(
                    value: _meta.toDouble(),
                    min: 1,
                    max: _habitos.length.toDouble(),
                    divisions: _habitos.length - 1,
                    label: '$_meta',
                    onChanged: _cambiarMeta,
                  ),

                  Text(
                    'Meta: $_meta hábitos',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  if (_metaAlcanzada)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Chip(
                        avatar: Icon(Icons.check),
                        label: Text('Meta alcanzada'),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // MODO ENFOQUE
          // ======================================================
          Card(
            child: SwitchListTile(
              title: const Text('Modo enfoque'),
              subtitle: const Text('Ocultar hábitos que ya completaste'),
              secondary: const Icon(Icons.center_focus_strong),
              value: _enfoque,
              onChanged: _alternarEnfoque,
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // LISTA DE HÁBITOS
          // ======================================================
          Text(
            'Hábitos de hoy',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          ...List.generate(_habitos.length, (index) {
            // En modo enfoque no mostramos los hábitos
            // que ya fueron completados.
            if (_enfoque && _cumplidos[index]) {
              return const SizedBox.shrink();
            }

            return Card(
              child: CheckboxListTile(
                value: _cumplidos[index],
                onChanged: (_) {
                  _alternarHabito(index);
                },
                title: Text(_habitos[index]),
                secondary: Icon(
                  _cumplidos[index]
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            );
          }),

          const SizedBox(height: 24),

          // ======================================================
          // NOTA DEL DÍA
          // ======================================================
          Text(
            'Nota del día',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _notaCtrl,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Escribe una nota',
              hintText: '¿Cómo fue tu día?',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit_note),
            ),
            onSubmitted: (_) {
              _guardarNota();
            },
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _guardarNota,
              icon: const Icon(Icons.save),
              label: const Text('Guardar nota'),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // NOTA GUARDADA
          // ======================================================
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sticky_note_2_outlined),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nota guardada',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 6),

                        Text(_nota.isEmpty ? 'Sin nota' : _nota),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ======================================================
          // REINICIAR DÍA
          // ======================================================
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _reiniciarDia,
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar día'),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
