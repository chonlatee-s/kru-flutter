import 'package:flutter/material.dart';
import 'package:kru/store/app_store.dart';
import 'package:url_launcher/url_launcher.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  // นิยามสีตามธีมหลัก
  static const Color brandGold = Color(0xFFB9976C);
  static const Color brandNavy = Color(0xFF2D2F31);
  static const Color bgColor = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();
    getJobs(); // ดึงข้อมูลงานจาก Store
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: brandNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ตำแหน่งงานว่าง',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: brandNavy,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: jobsChanged,
        builder: (context, child) {
          if (jobs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 50), 
            itemCount: jobs.length,
            itemBuilder: (BuildContext context, int index) {
              final job = jobs[index];
              return _buildJobCard(job);
            },
          );
        },
      ),
    );
  }

  // --- Widget สำหรับรายการงานแต่ละช่อง ---
  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => launchUrl(Uri.parse('${job['link']}')),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ไอคอนแสดงประเภทงาน (จำลอง)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: brandGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school_outlined, color: brandGold, size: 28),
              ),
              const SizedBox(width: 16),
              
              // รายละเอียดงาน
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${job['school']}',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: brandNavy,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        _convertDateTH(job['date_end']),
                      ],
                    ),
                  ],
                ),
              ),
              
              // ปุ่มกดดูรายละเอียด
              const Center(
                child: Icon(Icons.chevron_right, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget กรณีไม่มีข้อมูล ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'ไม่พบข้อมูลงานในขณะนี้',
            style: TextStyle(fontFamily: 'Kanit', color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- ฟังก์ชันแปลงวันที่ ---
  Widget _convertDateTH(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return const SizedBox();
    try {
      List<String> d = dateTime.split("-");
      // รับมือกรณี format วันที่ผิดพลาด
      if (d.length < 3) return const Text('ไม่ระบุวันที่');
      
      return Text(
        'ปิดรับ: ${d[2]}/${d[1]}/${int.parse(d[0]) + 543}',
        style: const TextStyle(
          fontFamily: 'Kanit',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE67E22), // สีส้มเพื่อสื่อถึง Deadline
        ),
      );
    } catch (e) {
      return const Text('วันที่ไม่ถูกต้อง');
    }
  }
}