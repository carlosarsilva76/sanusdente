-- ============================================================
--  SANUSDENTE · Stock — criação completa da base de dados
--  Corre UMA vez no Supabase (projeto novo) → SQL Editor → New query → Run.
--  Cria todas as tabelas e o armazenamento de fotos. Começa vazio
--  (os produtos são criados na app, com "+ Produto" ou pela leitura de faturas).
-- ============================================================

-- Catálogo (produtos genéricos) --------------------------------
create table if not exists public.stk_produtos (
  id            uuid primary key default gen_random_uuid(),
  nome          text not null,
  alcunha       text,
  categoria     text,
  unidade       text default 'un',
  referencia    text,
  fornecedor    text,
  codigo_barras text,
  codigo        text,                 -- código interno do produto genérico (P0001…)
  foto_url      text,
  ativo         boolean default true,
  criado_em     timestamptz default now()
);

-- Stock por clínica --------------------------------------------
create table if not exists public.stk_stock (
  id             uuid primary key default gen_random_uuid(),
  produto_id     uuid not null references public.stk_produtos(id) on delete cascade,
  clinica        text not null,
  quantidade     numeric default 0,
  limiar_critico numeric default 0,
  limiar_rutura  numeric default 0,
  validade       date,
  unique (produto_id, clinica)
);

-- Histórico de movimentos --------------------------------------
create table if not exists public.stk_movimentos (
  id          uuid primary key default gen_random_uuid(),
  produto_id  uuid not null references public.stk_produtos(id) on delete cascade,
  clinica     text not null,
  tipo        text not null,          -- 'entrada' | 'saida' | 'ajuste'
  quantidade  numeric not null,
  preco       numeric,
  fornecedor  text,
  nota        text,
  perfil      text,
  criado_em   timestamptz default now()
);

-- Marcas / nomes comerciais por produto ------------------------
create table if not exists public.stk_variantes (
  id             uuid primary key default gen_random_uuid(),
  produto_id     uuid references public.stk_produtos(id) on delete cascade,
  nome_comercial text,
  codigo         text,
  criado_em      timestamptz default now()
);

-- Lista de compras à mão + lista de desejos --------------------
create table if not exists public.stk_desejos (
  id        uuid primary key default gen_random_uuid(),
  texto     text not null,
  nota      text,
  clinica   text,
  tipo      text not null default 'compra',   -- 'compra' | 'desejo'
  feito     boolean default false,
  perfil    text,
  qtd       numeric default 1,
  foto_url  text,
  criado_em timestamptz default now()
);

create index if not exists idx_stk_stock_clinica on public.stk_stock (clinica);
create index if not exists idx_stk_mov_produto    on public.stk_movimentos (produto_id);
create index if not exists idx_stk_prod_codbar    on public.stk_produtos (codigo_barras);
create index if not exists idx_variantes_produto  on public.stk_variantes (produto_id);

-- Armazenamento das fotos (bucket público 'produtos') ----------
insert into storage.buckets (id, name, public)
values ('produtos', 'produtos', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "produtos_read"   on storage.objects;
drop policy if exists "produtos_write"  on storage.objects;
drop policy if exists "produtos_update" on storage.objects;
drop policy if exists "produtos_delete" on storage.objects;

create policy "produtos_read"   on storage.objects for select using (bucket_id = 'produtos');
create policy "produtos_write"  on storage.objects for insert with check (bucket_id = 'produtos');
create policy "produtos_update" on storage.objects for update using (bucket_id = 'produtos') with check (bucket_id = 'produtos');
create policy "produtos_delete" on storage.objects for delete using (bucket_id = 'produtos');

-- Acesso: a app usa a anon key (PIN do lado do cliente). RLS fica
-- desligado nestas tabelas (default ao criar via SQL).
