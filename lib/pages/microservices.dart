import 'package:flutter/material.dart';

/*class MicroServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Set an appropriate height for the services section
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildServiceIcon(
            context,
            label: 'Konkt Discounts',
            icon: Icons.local_offer,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonktDiscountsScreen()),
            ),
          ),
          _buildServiceIcon(
            context,
            label: 'Konkt Market',
            icon: Icons.store,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonktMarketScreen()),
            ),
          ),
          _buildServiceIcon(
            context,
            label: 'Konkt Jobs',
            icon: Icons.work,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonktJobsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context,
      {required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Empty screens for each service
class KonktDiscountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Discounts'),
      ),
      body: Center(
        child: Text('Welcome to Konkt Discounts!'),
      ),
    );
  }
}

class KonktMarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Market'),
      ),
      body: Center(
        child: Text('Welcome to Konkt Market!'),
      ),
    );
  }
}

class KonktJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konkt Jobs'),
      ),
      body: Center(
        child: Text('Welcome to Konkt Jobs!'),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';

import 'konktservices.dart';

class MicroServicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Set an appropriate height for the services section
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildServiceIcon(
            context,
            label: 'Services',
            icon: Icons.build, // Use an appropriate icon
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonktServicesScreen()), // Existing screen
            ),
          ),
          _buildServiceIcon(
            context,
            label: 'Discounts',
            icon: Icons.local_offer,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonktDiscountsScreen()),
            ),
          ),
          _buildServiceIcon(
            context,
            label: 'Market',
            icon: Icons.store,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonktMarketScreen()),
            ),
          ),
          _buildServiceIcon(
            context,
            label: 'Jobs',
            icon: Icons.work,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonktJobsScreen()),
            ),
          ),

          _buildServiceIcon(
            context,
            label: 'Startup',
            icon: Icons.business, // Use an appropriate icon
            color: Colors.lightGreen,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StartupScreen()), // Existing screen
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context,
      {required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Existing screens for demonstration purposes
class KonktDiscountsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discounts'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              'assets/images/discount.jpg',
              fit: BoxFit.contain, // Keeps the image within the screen bounds
            ),
          ),

        ],
      ),
    );
  }
}

class KonktMarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              'assets/images/market.jpg',
              fit: BoxFit.contain, // Keeps the image within the screen bounds
            ),
          ),

        ],
      ),
    );
  }
}

class KonktJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              'assets/images/jobs.jpg',
              fit: BoxFit.contain, // Keeps the image within the screen bounds
            ),
          ),

        ],
      ),
    );
  }
}
/*class StartupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/startup.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              'Welcome to Startup! Coming Soon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/



class StartupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Image.asset(
              'assets/images/startup.jpg',
              fit: BoxFit.contain, // Keeps the image within the screen bounds
            ),
          ),
         /* Center(
            child: Text(
              'Welcome to Startup! Coming Soon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),*/
        ],
      ),
    );
  }
}

