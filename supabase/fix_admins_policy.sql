-- ============================================================================
-- FIX: infinite recursion in the admins-table policies (error 42P17)
--
-- The original "owners manage roster" policy queried public.admins inside a
-- policy ON public.admins, which Postgres rejects as infinite recursion.
-- This replaces it with a security-definer helper (which bypasses RLS the
-- same way public.is_admin() already does) and also registers the admin
-- user if it is not registered yet.
--
-- Run once in the Supabase SQL editor. Safe to re-run.
-- ============================================================================

create or replace function public.is_owner()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.admins
    where user_id = auth.uid() and role = 'owner' and deleted_at is null
  );
$$;

drop policy if exists "owners manage roster" on public.admins;

create policy "owners insert roster" on public.admins
  for insert with check (public.is_owner());
create policy "owners update roster" on public.admins
  for update using (public.is_owner());
create policy "owners delete roster" on public.admins
  for delete using (public.is_owner());

-- Register the admin user (edit the email if yours differs).
insert into public.admins (user_id, display_name, role)
select id, 'Operations', 'owner' from auth.users
where lower(email) = 'admin@gmail.com'
on conflict (user_id) do nothing;

-- Verify: should return one row with role = owner.
select a.display_name, a.role, u.email
from public.admins a join auth.users u on u.id = a.user_id;
