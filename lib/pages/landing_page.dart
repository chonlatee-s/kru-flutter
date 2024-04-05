import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 149, 243, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo.png',
                  width: 150,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ครูผู้ช่วย',
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 37,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ร่วมสร้างสังคมแห่งการแบ่งปัน',
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 250, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'กำลังดาวน์โหลดข้อมูล',
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
