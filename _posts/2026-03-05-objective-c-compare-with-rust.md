---
layout: post
title: 'Objective-C และแนวคิดเรื่อง Memory Lifetime ในแบบของ Rust'
date: 2026-03-05 11:30:00 +0700
categories: memory management
---

# Objective-C และแนวคิดเรื่อง Memory Lifetime

## ต้นแบบความคิดบางส่วนของ Rust?

หนึ่งในภาษาที่ผม “แอบเดา” ว่าอาจมีอิทธิพลต่อแนวคิดเรื่อง **Memory Lifetime** ของ Rust อยู่บ้าง  
คือภาษา **Objective-C**

Objective-C เป็นภาษาที่ **ไม่มี Garbage Collector (GC)**  
แต่ใช้ระบบ **reference counting** แทน

---

# Reference Counting ใน Objective-C

ใน Objective-C การจัดการหน่วยความจำใช้แนวคิด

```objc

retain / release

```

หลักการง่ายมาก

- `retain` → เพิ่ม reference count
- `release` → ลด reference count

ตัวอย่างเชิงแนวคิด

```

retain   → +1
retain   → +1
release  → -1
release  → -1

```

เมื่อ reference count กลายเป็น

```

0

```

object นั้นจะถูกทำลายทันที

---

# Syntax ของ Objective-C

Syntax จะมีลักษณะเฉพาะแบบนี้

```objc
[a retain]
```

จริง ๆ แล้วนี่คือการ **เรียก method**

```objc
[a retain]  →  call method retain ของ object a
```

---

# การใช้ retain / release ตาม Scope

ใน Objective-C สมัยก่อน เรามักถูกสอนให้ใช้ retain/release
ให้ **จับคู่กันตาม scope**

ตัวอย่างเชิงแนวคิด

```objc
{
    [a retain]   // ref +1  == 1

    ...

    {
        [a retain]   // ref +1  == 2

        // ทำงานบางอย่าง

        [a release]  // ref -1  == 1
    }

    [a release]  // ref -1  == 0 → a ถูกทำลายตรงนี้
}
```

แนวคิดคือ

```
retain → ใช้ → release
```

และพยายามให้มัน **สมดุลกัน**

---

# ยุคของ ARC (Automatic Reference Counting)

ต่อมา Objective-C ได้เสนอระบบที่ทำสิ่งนี้ **ให้อัตโนมัติ**

สิ่งนี้เรียกว่า

> **ARC (Automatic Reference Counting)**

หลักการคือ

> compiler จะเป็นผู้แทรก `retain` / `release` ให้อัตโนมัติ

compiler จะวิเคราะห์โค้ด แล้วตัดสินว่า

- จุดไหนควร `retain`
- จุดไหนควร `release`

---

# คุ้น ๆ ไหม?

สิ่งนี้มีความคล้ายกับ Rust ในแง่หนึ่ง

compiler ไม่ได้ทำหน้าที่เพียง

```
translate code
```

แต่มันพยายาม

- วิเคราะห์โค้ด
- เข้าใจการใช้งาน
- ช่วยจัดการ resource

พูดอีกแบบคือ

> compiler พยายาม “ฉลาดขึ้น”

ซึ่งเป็นแนวทางเดียวกับที่ Rust เลือกใช้

---

# แต่ Rust ไปไกลกว่า

ความแตกต่างสำคัญคือ

Objective-C ยังยอมให้เกิดสถานการณ์แบบนี้ได้

```
retain หลายครั้ง
release น้อยครั้ง
```

เช่น

```
retain  → +1
retain  → +1
release → -1
```

ผลคือ reference count ไม่เคยเป็น 0

object จะ **ค้างอยู่ในระบบตลอดไป**

สิ่งนี้คือ

```
memory leak
```

ระบบ ARC ช่วยลดปัญหานี้ได้มาก
แต่ยังคงพึ่งพา

```
วินัยของ programmer
```

เป็นหลัก

---

# Rust เลือกแนวทางที่เข้มงวดกว่า

Rust ไม่ยอมให้

```
ownership ซ้ำ
```

โดยไม่มีเงื่อนไข

Rustใช้แนวคิด

```
ownership
borrowing
lifetime
```

และให้ **compiler พิสูจน์ความถูกต้อง**

ตั้งแต่ตอน

```
compile time
```

ก่อนที่โปรแกรมจะรัน

---

# ลองคิดเล่น ๆ

ถ้า Objective-C ไม่อนุญาตให้

```
object เดียว
มี owner มากกว่า 1
```

มันจะเริ่มมีพฤติกรรมที่ **คล้าย Rust มากขึ้นทันที**

แน่นอนว่าโลกจริงซับซ้อนกว่านั้น
แต่แนวคิดพื้นฐานจะเริ่มใกล้กัน

---

# ทำไมการเรียน Memory Model หลายภาษา ถึงสำคัญ

ผมอยากแนะนำให้ลองศึกษาวิธีจัดการ memory ของหลายภาษา

คุณจะเริ่มเห็นว่า
แต่ละภาษาแก้ปัญหาเดียวกัน
แต่ใช้ **แนวทางที่ต่างกัน**

ตัวอย่างเช่น

| ภาษา                | แนวคิด               |
| ------------------- | -------------------- |
| C / C++             | manual memory        |
| Objective-C / Swift | reference counting   |
| Java / Go           | garbage collector    |
| Rust                | ownership + lifetime |

---

# ทำไมบางคนเข้าใจ Rust ได้เร็ว

คนที่เข้าใจ Rust lifetime ได้เร็ว
มักจะเป็นคนที่เคยผ่านอย่างน้อยหนึ่งในนี้

- **C / C++** → เคยเจอ dangling pointer
- **Swift / Objective-C** → เคยเจอ retain cycle / ARC
- **Java / Go** → เข้าใจ GC
- หรือเคย debug memory bug จริง ๆ

คนกลุ่มนี้จะมี

```
mental model ของ memory
```

อยู่แล้ว

พอเห็น Rust พวกเขาจะคิดทันทีว่า

> อ๋อ Rust กำลังพยายามพิสูจน์สิ่งนี้ตั้งแต่ compile time

---

# แต่สำหรับคนที่ไม่เคยผ่านสิ่งเหล่านี้

Lifetime ใน Rust จะดูเหมือน

```
กฎแปลก ๆ ของภาษา
```

เพราะมันบังคับให้ programmer ต้องเข้าใจ

```
memory model
```

ตั้งแต่แรก

---

# ส่งท้าย

Objective-C เป็นหนึ่งในภาษาที่ทำให้เราเห็นว่า

> compiler สามารถช่วยจัดการ memory ได้

แต่ Rust ก้าวไปอีกขั้น

Rustไม่ได้เพียงแค่ช่วยจัดการ memory

Rustทำให้

> ความผิดพลาดของ memory
> ไม่สามารถผ่านการ compile ได้ตั้งแต่แรก
