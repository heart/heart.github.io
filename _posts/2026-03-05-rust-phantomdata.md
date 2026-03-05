---
layout: post
title: 'มาเล่าเรื่อง PhantomData ใน Rust'
date: 2026-03-05 11:30:00 +0700
categories: rust type-system
---

# มาเล่าเรื่อง PhantomData ใน Rust

![Rust Logo](/assets/rust_logo.png)

เริ่มจากปัญหาก่อน แล้วค่อย ๆ ไล่ไปทีละขั้น

---

สมมุติว่าเรามีฟังก์ชันแบบนี้

```rust
fn get_user(id: u64) {
    // ดึง user ตาม id
}
```

สังเกตว่าฟังก์ชันนี้มีไว้เพื่อดึง user ตาม id ที่กำหนด

คราวนี้ลองสมมุติว่าเราประกาศตัวแปรแบบนี้

```rust
let userID: u64 = 3333;
let productID: u64 = 1111;
```

เราสามารถเรียกฟังก์ชันแบบนี้ได้

```rust
get_user(productID) // โยน product id เข้าไป ( ทั้งๆที่ควรเป็น userID )
```

ซึ่งคอมไพล์เลอร์จะยอมให้ผ่าน เพราะทั้งคู่เป็น `u64` เหมือนกัน

ในระดับโปรแกรมมันจึงไม่ผิดอะไรเลย
แต่ในระดับ **logic ของระบบ** มันผิดทันที

เพราะเรากำลังเอา **Product ID ไปใช้เป็น User ID**

---

## ลองแยก Type ให้ชัดขึ้น

คราวนี้ลองคิดว่า ถ้าเราอยากแยกประเภทของ ID ให้ชัดเจนขึ้นล่ะ

วิธีหนึ่งที่หลายคนอาจลองก่อนคือสร้าง type ใหม่แบบนี้

```rust
type UserId = u64;
type ProductId = u64;
```

จากนั้นประกาศตัวแปรแบบนี้

```rust
let userID: UserId = 3333;
let productID: ProductId = 1111;
```

ดูเหมือนว่าเราจะแยกประเภทได้แล้ว

แต่ถ้าเราเรียกฟังก์ชันแบบนี้

```rust
get_user(productID) // โยน product id เข้าไป ( ทั้งๆที่ควรเป็น userID )
```

คอมไพล์เลอร์ก็ยังยอมให้ผ่านอยู่ดี

เหตุผลก็คือ

```rust
ProductId = u64
UserId = u64
```

`type` ใน Rust แบบนี้เป็นแค่ **alias**
มันไม่ได้สร้าง type ใหม่จริง ๆ

ดังนั้นสำหรับคอมไพล์เลอร์แล้ว ทุกอย่างยังคงเป็น `u64` อยู่เหมือนเดิม

---

## ใช้ PhantomData เพื่อแยก Domain

ตรงนี้เองที่เราต้องการสิ่งที่ช่วยให้

> type ของข้อมูลแยกกันจริง ๆ ในระดับของ type system

และหนึ่งในวิธีที่ Rust มีให้ก็คือ **PhantomData**

(สปอยล์ไว้ก่อนว่า วิธีนี้เป็น **Zero Cost** หรือมี cost เป็นศูนย์ แต่จะอธิบายตอนท้าย)

---

เราจะเริ่มด้วยการสร้าง struct แบบนี้

```rust
use std::marker::PhantomData;

struct Id<T> {
    value: u64,
    _marker: PhantomData<T>,
}
```

struct นี้มีสองส่วน

```rust
value   → เก็บค่า id จริง
_marker → PhantomData ที่ใช้บอก type system (จริงๆแล้ว ตั้งชื่อว่าอะไรก็ได้)
```

`Id` เป็น generic struct

```rust
Id<T>
```

ทำให้เราสามารถใช้มันซ้ำได้กับหลาย ๆ domain

---

## สร้าง Domain Type

ต่อไปเราประกาศ type ของ domain ต่าง ๆ

```rust
struct Product;
struct User;
```

แล้วสร้าง ID ของแต่ละประเภทแบบนี้

```rust
type ProductId = Id<Product>;
type UserId = Id<User>;
```

ตอนนี้ `ProductId` กับ `UserId` จะกลายเป็น **คนละ type กันจริง ๆ**

จากนั้นเรากำหนดฟังก์ชันแบบนี้

```rust
fn get_user(id: UserId) {
    // ...
}
```

และสมมุติว่าเรามีตัวแปรแบบนี้

```rust
let productID = ProductId {
    value: 1111,
    _marker: PhantomData,
};
```

ถ้าเราพยายามเรียกแบบนี้

```rust
get_user(productID)
```

คอมไพล์เลอร์จะ **ไม่ยอมให้ผ่าน**

เพราะ

```rust
ProductId ≠ UserId
```

ถึงแม้ภายในจะเก็บแค่ `u64` เหมือนกัน

---

## PhantomData ช่วยอะไร

นี่คือประโยชน์ของ **PhantomData**

มันช่วยให้เราสามารถแยกประเภทของข้อมูลตาม domain ได้อย่างชัดเจน
โดยใช้พลังของ **type system**

ทั้งที่จริง ๆ แล้วข้อมูลที่เก็บอยู่ยังเป็น `u64` เท่าเดิม

---

## Zero Cost จริงไหม

คราวนี้กลับมาที่เรื่องที่สปอยล์ไว้ตอนต้น

เรื่องของ **Zero Cost**

`PhantomData` ไม่ได้เพิ่มข้อมูลจริง ๆ เข้าไปใน struct

มันเป็นเพียง marker ที่ใช้ในระดับ **compile time**

เราสามารถพิสูจน์ได้แบบนี้

```rust
use std::mem;

println!("{}", mem::size_of::<Id<User>>());
```

ผลลัพธ์ที่ได้คือ

```rust
8
```

ซึ่งเท่ากับขนาดของ `u64`

แปลว่า

```rust
PhantomData ไม่ได้เพิ่มขนาดของ struct เลย
```

มันมีอยู่เพื่อช่วยให้คอมไพล์เลอร์เข้าใจความสัมพันธ์ของ type เท่านั้น

หลังจาก compile เสร็จแล้ว โปรแกรมที่ได้จะมีขนาดเท่าเดิม
ไม่มี overhead เพิ่มขึ้นแม้แต่น้อย

---

`PhantomData` ไม่เพิ่มขนาดของ struct และหลัง optimize แล้ว การส่ง Id<User> มักจะถูกคอมไพล์ออกมาเหมือนส่ง u64 ตรง ๆ แต่ Id<User> ยังเป็นคนละ type ในระดับ compile time เพื่อให้คอมไพเลอร์กันการใช้ผิด domain”

---

## ส่งท้าย

**PhantomData** เป็นเทคนิคใน Rust ที่ใช้เพิ่มข้อมูลให้กับ **type system**
โดยไม่เพิ่มข้อมูลใน runtime

มันช่วยให้เราสามารถ

- แยกประเภทข้อมูลตาม domain
- ป้องกัน logic bug
- และยังคง performance เท่าเดิม

ทั้งหมดนี้เกิดขึ้นในระดับ **compile time** เท่านั้น

ซึ่งเป็นแนวคิดสำคัญของ Rust ที่เรียกว่า

**Zero-cost abstractions**
