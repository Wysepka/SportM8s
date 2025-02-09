import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportm8s/core/services/storage_service.dart';
import '../../../../core/services/auth_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final storageService = await ref.read(storageServiceInitializerProvider.future);
              await storageService.debugResetAllAgreements(ref);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All agreements reset')),
                );
              }
            },
            tooltip: 'Debug: Reset Agreements',
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            tooltip: 'Debug: Clear Session',
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to SportM8s!'),
      ),
    );
  }
} 