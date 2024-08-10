import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../image_svg/svg_img.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> futureUnits;

  @override
  void initState() {
    super.initState();
    futureUnits = Future.delayed(Duration(seconds: 2)); // Fake loading API :D
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17192D),
        elevation: 0,
        centerTitle: true,
        title: SvgPicture.string(
          logoSvg,
          color: Colors.white,
          height: 20,
          width: 200,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<void>(
          future: futureUnits,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerLoadingEffect();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: <Widget>[
                  MenuItem(
                    title: 'Jaguar Unit',
                    onTap: () {
                      Navigator.pushNamed(context, '/assets', arguments: 'Jaguar_Unit');
                    },
                  ),
                  MenuItem(
                    title: 'Tobias Unit',
                    onTap: () {
                      Navigator.pushNamed(context, '/assets', arguments: 'Tobias_Unit');
                    },
                  ),
                  MenuItem(
                    title: 'Apex Unit',
                    onTap: () {
                      Navigator.pushNamed(context, '/assets', arguments: 'Apex_Unit');
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ShimmerLoadingEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => ShimmerLoadingItem()),
    );
  }
}

class ShimmerLoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  MenuItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: <Widget>[
            Icon(Icons.dashboard_outlined, color: Colors.white),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
