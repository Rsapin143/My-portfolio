-- Supabase setup for Rodolfo Sapin portfolio website
-- Run this in Supabase Dashboard → SQL Editor.
-- This version stores Profile, Skills, Works, theme mode, images, and videos in Supabase so every device sees the same data in real time.

create table if not exists public.site_settings (
  id text primary key default 'main',
  profile jsonb not null default '{}'::jsonb,
  works jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

insert into public.site_settings (id, profile, works, updated_at)
values (
  'main',
  $$ {"name": "Rodolfo Sapin", "title": "Freelance Video Editor & Front-End Developer", "bio": "I am a freelance video editor with 1 year of hands-on experience creating clean, engaging, and story-driven visual content for social media, short-form videos, promotional edits, and portfolio projects. I also work as a graphic designer, web developer, front-end developer, and UI/UX designer, combining creative design with functional development to build digital experiences that look professional and feel easy to use. My background in BSIT helps me understand both the technical and creative side of every project, from editing visuals and designing layouts to building responsive websites and interactive user interfaces.", "location": "Iloilo, Philippines", "contactEmail": "rodolfosapin@gmail.com", "github": "", "linkedin": "", "school": "Iloilo State University of Fisheries Science and Technology", "course": "BSIT", "profileImage": "", "theme": "dark", "skills": [{"name": "Video Editing", "level": 88}, {"name": "Graphic Design", "level": 84}, {"name": "UI/UX Design", "level": 82}, {"name": "HTML", "level": 90}, {"name": "CSS", "level": 88}, {"name": "JavaScript", "level": 86}, {"name": "PHP", "level": 80}, {"name": "Laravel", "level": 76}, {"name": "React.js", "level": 82}, {"name": "TypeScript", "level": 76}, {"name": "Node.js", "level": 78}, {"name": "Angular", "level": 70}, {"name": "React Native", "level": 74}, {"name": "Flutter", "level": 72}, {"name": "Tailwind CSS", "level": 84}, {"name": "Supabase", "level": 80}, {"name": "Firebase", "level": 78}, {"name": "MongoDB", "level": 74}, {"name": "GitHub", "level": 82}, {"name": "PWA", "level": 72}]} $$::jsonb,
  $$ [{"id": 1, "title": "Freelance Video Editing Portfolio", "description": "A collection of short-form edits, cinematic cuts, social media videos, and promotional content focused on pacing, clean transitions, storytelling, captions, and engaging visual flow.", "tech": ["CapCut", "Premiere Pro", "After Effects", "Storytelling", "Captions"], "images": ["https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?w=900&h=600&fit=crop", "https://images.unsplash.com/photo-1536240478700-b869070f9279?w=900&h=600&fit=crop"], "category": "Video Editing", "url": "#", "video": "", "videoRatio": "16 / 9"}, {"id": 2, "title": "Brand Graphics & Social Media Designs", "description": "A graphic design showcase featuring social media layouts, posters, thumbnails, banners, and visual branding concepts made for clean communication and strong audience attention.", "tech": ["Photoshop", "Canva", "Branding", "Layout Design", "Thumbnails"], "images": ["https://images.unsplash.com/photo-1561070791-2526d30994b5?w=900&h=600&fit=crop", "https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=900&h=600&fit=crop"], "category": "Graphic Design", "url": "#", "video": "", "videoRatio": "4 / 5"}, {"id": 3, "title": "Responsive Portfolio Website", "description": "A personal portfolio website built with responsive layouts, interactive sections, reusable components, smooth animations, admin editing, and real-time content updates through Supabase.", "tech": ["HTML", "CSS", "JavaScript", "Supabase", "PWA"], "images": ["https://images.unsplash.com/photo-1467232004584-a241de8bcf5d?w=900&h=600&fit=crop", "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=900&h=600&fit=crop"], "category": "Web Development", "url": "#", "video": "", "videoRatio": "16 / 9"}, {"id": 4, "title": "Front-End UI Dashboard Concept", "description": "A modern dashboard interface concept focused on organized data, clear hierarchy, smooth user experience, form controls, responsive cards, and clean UI behavior.", "tech": ["React.js", "TypeScript", "Tailwind CSS", "UI/UX", "GitHub"], "images": ["https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=900&h=600&fit=crop", "https://images.unsplash.com/photo-1551434678-e076c223a692?w=900&h=600&fit=crop"], "category": "Front-End", "url": "#", "video": "", "videoRatio": "16 / 9"}, {"id": 5, "title": "Mobile App Interface Practice", "description": "A mobile UI practice project exploring clean screens, simple navigation, responsive components, and app-style interfaces using cross-platform tools and backend services.", "tech": ["React Native", "Flutter", "Firebase", "Supabase", "UI Design"], "images": ["https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=900&h=600&fit=crop", "https://images.unsplash.com/photo-1551650975-87deedd944c3?w=900&h=600&fit=crop"], "category": "Mobile UI", "url": "#", "video": "", "videoRatio": "9 / 16"}] $$::jsonb,
  now()
)
on conflict (id) do update set
  profile = excluded.profile,
  works = excluded.works,
  updated_at = now();

-- Make the table available to Supabase Realtime.
alter table public.site_settings replica identity full;
do $$
begin
  begin
    alter publication supabase_realtime add table public.site_settings;
  exception
    when duplicate_object then null;
    when undefined_object then null;
  end;
end $$;

-- Simple public policies for a static website.
-- For production, you can replace this with Supabase Auth and restrict updates to authenticated admins.
alter table public.site_settings enable row level security;

drop policy if exists "Public read site settings" on public.site_settings;
drop policy if exists "Public insert site settings" on public.site_settings;
drop policy if exists "Public update site settings" on public.site_settings;

create policy "Public read site settings"
on public.site_settings
for select
to anon
using (true);

create policy "Public insert site settings"
on public.site_settings
for insert
to anon
with check (id = 'main');

create policy "Public update site settings"
on public.site_settings
for update
to anon
using (id = 'main')
with check (id = 'main');

-- Storage bucket for profile images and project videos.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'portfolio-media',
  'portfolio-media',
  true,
  524288000,
  array[
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
    'video/mp4',
    'video/webm',
    'video/ogg',
    'video/quicktime'
  ]
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Public read portfolio media" on storage.objects;
drop policy if exists "Public insert portfolio media" on storage.objects;
drop policy if exists "Public update portfolio media" on storage.objects;
drop policy if exists "Public delete portfolio media" on storage.objects;

create policy "Public read portfolio media"
on storage.objects
for select
to anon
using (bucket_id = 'portfolio-media');

create policy "Public insert portfolio media"
on storage.objects
for insert
to anon
with check (bucket_id = 'portfolio-media');

create policy "Public update portfolio media"
on storage.objects
for update
to anon
using (bucket_id = 'portfolio-media')
with check (bucket_id = 'portfolio-media');

create policy "Public delete portfolio media"
on storage.objects
for delete
to anon
using (bucket_id = 'portfolio-media');
