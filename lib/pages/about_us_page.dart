import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/img/logo_home.png',
                width: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ครูผู้ช่วย',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(183, 153, 108, 1),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            floating: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'เกี่ยวกับเรา',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(252, 252, 252, 1),
                ),
              ),
              background: Image.asset(
                'assets/img/welcome.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Column(
                      children: [
                        const Text(
                          'แอปพลิเคชันนี้สร้างขึ้นมา เพื่อให้ผู้ที่จะสอบครูผู้ช่วย ได้เตรียมความพร้อมในการสอบ ก่อนลงสนามจริง หากพบข้อผิดพลาด หรือมีคำแนะนำ ติดต่อที่ kruchonlatee@gmail.com',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Color.fromRGBO(41, 41, 41, 1),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 50),
                          child: Text(
                            'ทุกคนสามารถเป็นส่วนหนึ่งของการแบ่งปันได้ เช่น แนวข้อสอบ สื่อการสอน หรือแผนการสอน มาร่วมสร้างสังคมแห่งการแบ่งปันไปด้วยกัน ขอบคุณรูปหน้าปกสวย ๆ จาก jannoon028',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(41, 41, 41, 1),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        InkWell(
                          onTap: () => launchUrl(
                            Uri.parse('https://xn--42cm7czac0a7jb0li.com/'),
                          ),
                          child: const Text(
                            'ข้อมูลเพิ่มเติม ครูผู้ช่วย.com',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.blue,
                              fontFamily: 'Kanit',
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'ทำข้อสอบ',
        child: const Icon(
          Icons.edit_note,
          size: 40,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'เกี่ยวกับเรา',
            ),
          ],
          currentIndex: 1,
          onTap: (int index) {
            if (index == 0) context.go('/');
          },
          selectedItemColor: const Color.fromARGB(255, 21, 84, 161),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}
