
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:el_poke/controllers/pokemon_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() {
  /// [ProviderScope] required for riverpod state management
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// [TextEditingController] using hooks
    final controller = useTextEditingController();
    final requestStatus = ref.watch(pokemonProvider);
    useEffect(() {
      /// Fetch the initial pokemon information (random pokemon).
      Future.delayed(Duration.zero, () {
        ref.read(pokemonProvider.notifier).fetchRandom();
      });
    }, []);

    return MaterialApp(
      title: 'El poke API de KVM',
      home: Scaffold(
        body: Column(
          children: [
            /// [TextField] and [ElevatedButton] to input pokemon id to fetch
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText:
                    'Ingresa o borra el numero de pokemon que quieres ver (num: del 1 al 898)',
              ),
            ),
            ElevatedButton(
              onPressed: () => ref
                  .read(
                    pokemonProvider.notifier,
                  )
                  .fetch(
                    controller.text,
                  ),
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Da clic para enseñarte el pokemon!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Color.fromARGB(255, 221, 25, 58))),
                ),
              ),
            ),

            /// Map each [RequestStatus] to a different UI
            requestStatus.when(
              initial: () => Center(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text('Cargando tu pokemon, aguantaaaaaaa'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
              error: (error) => Text(error),
              success: (pokemon) => Card(
                child: Column(
                  children: [
                    Image.network(
                      pokemon.sprites.front_default,
                      width: 200,
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 24,
                      ),
                      child: Text(
                        pokemon.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
