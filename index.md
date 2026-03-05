---
layout: default
title: 'Home'
---

<section class="hero">
  <div class="mx-auto grid w-[min(1100px,92%)] animate-fade-in items-center gap-6 py-8 md:grid-cols-[136px_1fr] md:py-16 ">
    <img class="mx-auto h-[136px] w-[136px] rounded-full border-4 border-white object-cover shadow-xl md:mx-0" src="{{ "/assets/heart.jpeg" | relative_url }}" alt="Heart profile">
    <div>
      <h1 class="text-4xl font-bold tracking-tight text-slate-950 md:text-6xl">Heart Narongrit Kanhanoi</h1>
      <p class="mt-4 text-lg text-slate-500">
        ผมเป็นวิศวกรซอฟต์แวร์ที่ชอบเล่าเรื่องเทคโนโลยีให้เข้าใจง่าย
        มีความชำนาญด้าน Front-End, Go, Rust, Backend Architecture, และการออกแบบระบบที่ปลอดภัยและ scale ได้
      </p>
    </div>
  </div>
</section>

<section class="py-6 md:py-8" id="jobs">
  <div class="mx-auto w-[min(1100px,92%)]">
    <h2 class="text-2xl font-semibold tracking-tight text-slate-950">การทำงาน</h2>
    <p class="mt-3 text-slate-500">
      เป็น CTO ที่บริษัท
      <a class="text-sky-600 underline underline-offset-4" href="https://pams.ai" target="_blank" rel="noopener noreferrer">https://pams.ai</a>
    </p>
    <p class="mt-3 text-slate-500">Customer Data Solution ที่เป็นแพลตฟอร์ม AI สำหรับธุรกิจ</p>
  </div>
</section>

<section class="py-8 md:py-8" id="content">
  <div class="mx-auto w-[min(1100px,92%)]">
    <h2 class="text-2xl font-semibold tracking-tight text-slate-950">Content</h2>
    <p class="mt-3 text-slate-500">เมนูบทความ</p>
    <div class="mt-5 grid gap-4">
      {% if site.posts.size > 0 %}
        {% for post in site.posts %}
          <a class="flex items-center gap-4 rounded-2xl border border-slate-900/10 bg-white px-4 py-4 transition hover:-translate-y-0.5 hover:shadow-lg" href="{{ post.url | relative_url }}">
            <img class="h-14 w-14 rounded-xl object-cover" src="{{ "/assets/content-writing.png" | relative_url }}" alt="Writing icon">
            <span class="block">
              <strong class="block text-slate-900">{{ post.title }}</strong>
              <span class="text-sm text-slate-500">{{ post.date | date: "%d %b %Y" }}</span>
            </span>
          </a>
        {% endfor %}
      {% else %}
        <div class="rounded-2xl border border-slate-900/10 bg-white px-4 py-4 text-slate-500">ยังไม่มีบทความ</div>
      {% endif %}
    </div>
  </div>
</section>
