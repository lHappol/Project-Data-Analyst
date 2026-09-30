 Business Objective — NYC Yellow Taxi Analysis

 Overview

โครงการนี้มุ่งวิเคราะห์ข้อมูลการเดินทางของรถแท็กซี่ NYC Yellow Taxi
ปี 2022–2024 (ประมาณ 115.7 ล้านเที่ยว) เพื่อทำความเข้าใจพฤติกรรมผู้โดยสาร
รูปแบบรายได้ และความต้องการใช้บริการ โดยใช้ PostgreSQL จัดการข้อมูลขนาดใหญ่
และ Power BI แสดงผลเป็น Dashboard เชิงโต้ตอบ

 Business Questions

| คำถาม | แหล่งข้อมูล |
|---|---|---|
| 1 | ปริมาณเที่ยวและรายได้เปลี่ยนแปลงตามเดือน/ปีอย่างไร | agg_monthly |
| 2 | ช่วงเวลาใดของวันมี Demand สูงสุด | agg_hourly |
| 3 | วันใดของสัปดาห์มีเที่ยวมากที่สุด | agg_weekday |
| 4 | โซนใดมีการจรับผู้โดยสารหนาแน่นที่สุด (Top 100) | agg_top_zones |
| 5 | กลุ่มระยะทางใดคิดเป็นสัดส่วนมากที่สุด และค่าโดยสารเฉลี่ยต่างกันอย่างไร | agg_distance_bins |
| 6 | ผู้โดยสารชำระเงินด้วยวิธีใดมากที่สุด | agg_payment |

 Expected Benefits

- **Fleet Planning:** จัดสรรรถตามช่วงเวลา/โซนยอดนิยม ลดเวลาวิ่งเปล่า
- **Revenue Insight:** ติดตามเทรนด์รายได้รายเดือนและมูลค่าเฉลี่ยต่อเที่ยว
- **Pricing Strategy:** วิเคราะห์ระยะทาง vs. รายได้ เพื่อวางนโยบายค่าโดยสาร
- **Customer Behavior:** เข้าใจวิธีชำระเงินเพื่อออกแบบโปรโมชัน

 Key Metrics (KPIs)

| KPI | นิยาม |
|---|---|
| Total Trips | จำนวนเที่ยวรวม |
| Total Revenue | รายได้รวม (total_amount) |
| Avg Fare per Trip | ค่าโดยสารเฉลี่ยต่อเที่ยว |
| Avg Trip Distance | ระยะทางเฉลี่ยต่อเที่ยว |
| Peak Hours / Peak Days | ช่วงเวลาและวันที่ Demand สูงสุด |

 Scope

- ข้อมูล: NYC TLC Trip Record Data (Yellow Taxi), ม.ค. 2022 – ธ.ค. 2024
- เครื่องมือ: PostgreSQL (ETL + Aggregation), Power BI (Visualization)
- ขนาดข้อมูล: ~118 ล้านแถวดิบ → ~115.7 ล้านแถวหลังคัดกรอง (~2.1% filtered)

 Data Limitations

- ข้อมูลปี 2021 ไม่ครบถ้วนจากแหล่งต้นทาง จึงจำกัดขอบเขตการวิเคราะห์เฉพาะปี 2022–2024
- payment_type = 0 (~6.7 ล้านแถว) คือ missing category ไม่ใช่ invalid data
  จึงจัดกลุ่มเป็น "Unknown" แทนการลบ เพื่อรักษาข้อมูล
