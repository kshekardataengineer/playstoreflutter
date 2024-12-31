/*basic connection  no graph*/
import 'package:flutter/material.dart';

class ConnectionPathScreen extends StatelessWidget {
  final List<String> connections;

  ConnectionPathScreen({required this.connections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connection Path')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: connections.isEmpty
            ? Center(child: Text('No connections found.'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connection Path:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            for (int i = 0; i < connections.length; i++)
              Text('level ${i + 1}. ${connections[i]}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}



/* experiment with graph flutter graph library issue
import 'package:flutter/material.dart';
import 'package:flutter_graph/flutter_graph.dart';

class ConnectionPathScreen extends StatelessWidget {
  final List<String> connections;

  ConnectionPathScreen({required this.connections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connection Path')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: connections.isEmpty
            ? Center(child: Text('No connections found.'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connection Path:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: Graph(
                nodes: connections.map((name) => GraphNode(name)).toList(),
                edges: _createEdges(connections),
                nodeBuilder: (context, node) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(node.value, style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GraphEdge> _createEdges(List<String> connections) {
    List<GraphEdge> edges = [];
    for (int i = 0; i < connections.length - 1; i++) {
      edges.add(GraphEdge(connections[i], connections[i + 1]));
    }
    return edges;
  }
}

library issue did not test
*/
/*graphview code

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class ConnectionPathScreen extends StatelessWidget {
  final List<String> connections;

  ConnectionPathScreen({required this.connections});

  @override
  Widget build(BuildContext context) {
    // Create a Graph instance
    var graph = Graph();

    // Create nodes for each connection
    Map<String, Node> nodes = {};
    for (var name in connections) {
      nodes[name] = Node.Id(name); // Create a node with an identifier
    }

    // Add edges between consecutive nodes
    for (int i = 0; i < connections.length - 1; i++) {
      graph.addEdge(nodes[connections[i]]!, nodes[connections[i + 1]]!);
    }

    // Define the layout algorithm
    var algorithm = BuchheimWalkerAlgorithm(
      builder: (Node node) {
        // Create the widget for each node
        return SizedBox(
          width: 100,
          height: 50,
          child: Container(
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                node.key!.value, // Use node.key!.value to access the identifier
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text('Connection Path')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: connections.isEmpty
            ? Center(child: Text('No connections found.'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connection Path:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: GraphView(
                graph: graph,
                algorithm: algorithm,
                paint: Paint()
                  ..color = Colors.black
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
