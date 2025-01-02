library default_connector;

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ConnectorConfig {
  final String region;
  final String connector;
  final String project;

  ConnectorConfig(this.region, this.connector, this.project);
}

class FirebaseDataConnect {
  final ConnectorConfig config;
  final String sdkType;
  final FirebaseFirestore _firestore;

  FirebaseDataConnect._({
    required this.config,
    required this.sdkType,
  }) : _firestore = FirebaseFirestore.instance;

  static FirebaseDataConnect instanceFor({
    required ConnectorConfig connectorConfig,
    required String sdkType,
  }) {
    return FirebaseDataConnect._(
      config: connectorConfig,
      sdkType: sdkType,
    );
  }

  // Add methods to interact with Firestore
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Future<DocumentSnapshot> getDocument(String collection, String documentId) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }

  Stream<QuerySnapshot> streamCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }
}

class CallerSDKType {
  static const String generated = 'generated';
}

class DefaultConnector {
  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'sportm8s',
  );

  DefaultConnector({required this.dataConnect});
  
  static DefaultConnector get instance {
    return DefaultConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,
        sdkType: CallerSDKType.generated,
      ),
    );
  }

  final FirebaseDataConnect dataConnect;
}

