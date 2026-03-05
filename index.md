---
layout: default
title: "Home"
---

<section class="hero">
  <div class="container hero-inner fade-in">
    <img class="avatar" src="{{ "/assets/heart.jpeg" | relative_url }}" alt="Heart profile">
    <h1 class="hero-title">Heart</h1>
    <p class="hero-lead">
      ผมเป็นวิศวกรซอฟต์แวร์ที่ชอบเล่าเรื่องเทคโนโลยีให้เข้าใจง่าย
      มีความชำนาญด้าน Rust, Backend Architecture, และการออกแบบระบบที่ปลอดภัยและขยายได้
    </p>
    <div class="hero-cta">
      <a class="btn primary" href="#projects">ดูผลงาน</a>
      <a class="btn" href="#content">อ่านคอนเทนต์</a>
    </div>
  </div>
</section>

<section class="section" id="about">
  <div class="container">
    <div class="section-title">เกี่ยวกับฉัน</div>
    <p class="section-sub">
      ผมสนใจงานที่ต้องบาลานซ์ระหว่างคุณภาพโค้ด ความเร็วในการส่งมอบ และผลลัพธ์ทางธุรกิจ
      โดยโฟกัสกับงานระบบหลังบ้าน การออกแบบโดเมน และการทำให้โค้ดปลอดภัยตั้งแต่ระดับคอมไพล์
    </p>
    <div class="about-grid">
      <div class="about-card">
        <div class="tag">Rust</div>
        <p>ออกแบบ type-safe API และระบบที่เน้นความถูกต้องตั้งแต่ compile time</p>
      </div>
      <div class="about-card">
        <div class="tag">Backend</div>
        <p>พัฒนา service ที่ maintain ได้ง่าย รองรับการเติบโต และสื่อสารกับทีมได้ชัดเจน</p>
      </div>
      <div class="about-card">
        <div class="tag">Architecture</div>
        <p>ออกแบบโครงสร้างระบบให้สมดุลระหว่างความยืดหยุ่น ความเร็ว และความเสถียร</p>
      </div>
    </div>
  </div>
</section>

<section class="section" id="projects">
  <div class="container">
    <div class="section-title">ผลงาน</div>
    <p class="section-sub">บริษัทที่กำลังโฟกัส: pams.ai</p>
    <div class="project-grid">
      <article class="project-card">
        <div class="tag">Company</div>
        <div class="project-title">pams.ai</div>
        <p class="section-sub">
          แพลตฟอร์ม AI ที่มุ่งเน้นการใช้งานจริงในธุรกิจ พร้อมแนวทางพัฒนาระบบที่ยืดหยุ่นและต่อยอดได้
        </p>
      </article>
    </div>
  </div>
</section>

<section class="section" id="content">
  <div class="container">
    <div class="section-title">Content</div>
    <p class="section-sub">เมนูบทความ</p>
    <div class="writing-list">
      {% if site.posts.size > 0 %}
        {% for post in site.posts %}
          <a class="writing-item" href="{{ post.url | relative_url }}">
            <strong>{{ post.title }}</strong>
            <span>{{ post.date | date: "%d %b %Y" }}</span>
          </a>
        {% endfor %}
      {% else %}
        <div class="writing-item">ยังไม่มีบทความ</div>
      {% endif %}
    </div>
  </div>
</section>
