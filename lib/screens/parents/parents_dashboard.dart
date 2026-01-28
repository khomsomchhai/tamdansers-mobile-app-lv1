import 'package:flutter/material.dart';
class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _studentCard(),
                    const SizedBox(height: 16),
                    _sectionTitle("Quick Actions", action: "View All"),
                    const SizedBox(height: 10),
                    _quickActions(),
                    const SizedBox(height: 16),
                    _sectionTitle("Recent Activity"),
                    const SizedBox(height: 10),
                    _recentActivity(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  // ---------------- UI PARTS ----------------

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2E7CF6),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Wednesday, 24 May",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 6),
                Text(
                  "Good Morning,\nMr. Soth!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _circleIcon(Icons.notifications_none),
          const SizedBox(width: 10),
          const CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  Widget _studentCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.school)),
              title: const Text("Dara Chan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text("Grade 5A • ID: #29384"),
                  SizedBox(height: 4),
                  Text("✔ CHECKED IN • 7:45 AM",
                      style: TextStyle(color: Colors.green)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:  [
                _stat("98%", "ATTENDANCE"),
                _stat("A", "AVG. GRADE"),
                _stat("Good", "BEHAVIOR"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children:  [
        _actionTile("Attendance", Icons.date_range, Colors.blue),
        _actionTile("Homework", Icons.menu_book, Colors.orange),
        _actionTile("Results", Icons.bar_chart, Colors.green),
        _actionTile("News", Icons.campaign, Colors.purple),
      ],
    );
  }

  Widget _recentActivity() {
    return Card(
      child: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text("Math Quiz result available"),
            subtitle: Text("Dara scored 18/20"),
            trailing: Text("2h"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("School Closed Tomorrow"),
            subtitle: Text("Public holiday"),
            trailing: Text("Yesterday"),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------

  static Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  static Widget _actionTile(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const Spacer(),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget _circleIcon(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.white24,
      child: Icon(icon, color: Colors.white),
    );
  }

  static Widget _sectionTitle(String text, {String? action}) {
    return Row(
      children: [
        Text(text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const Spacer(),
        if (action != null)
          Text(action,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold)),
      ],
    );
  }

  static Widget _bottomNav() {
    return  BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Messages"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
