# Sanusdente · Stock — instalação (passo a passo)

App de gestão de stock para **uma clínica**, com dois acessos:
- **Clínica** — PIN `0000`
- **Administrador** — PIN `1111`

Fica 100% separada de qualquer outra app (base de dados e fotos próprias).

---

## 1) Base de dados (Supabase) — grátis
1. Cria conta em **supabase.com** → **New project** (guarda a password da BD).
2. Abre **SQL Editor → New query**, cola todo o `sanusdente_base.sql` e carrega em **Run**.
   - Cria todas as tabelas e o armazenamento de fotos. Começa vazio.
3. Vai a **Settings → API** e copia dois valores:
   - **Project URL** (ex.: `https://xxxx.supabase.co`)
   - **anon public** key

## 2) Ligar a app à tua base
No ficheiro `index.html`, no topo do `<script>` (secção CONFIG), substitui:
- `COLOCA_AQUI_O_URL_SUPABASE` → o teu **Project URL**
- `COLOCA_AQUI_A_TUA_ANON_KEY` → a tua **anon public** key

(Os PINs já estão como 0000 / 1111 — podes mudá-los aí.)

## 3) Publicar (GitHub Pages) — grátis
1. Cria conta em **github.com** e um repositório novo (ex.: `stock`).
2. **Add file → Upload files** e envia **todos** estes ficheiros:
   `index.html`, `logo.png`, `manifest.json`, `sw.js`,
   `icon-192.png`, `icon-512.png`, `apple-touch-icon.png` → **Commit**.
3. **Settings → Pages** → Source: **Deploy from a branch** → branch **main** / **/(root)** → **Save**.
4. Passado 1–2 min fica em: `https://<o-teu-utilizador>.github.io/stock/`
5. No iPhone/iPad: abre o link no Safari → **Partilhar → Adicionar ao ecrã principal**.

## 4) (Opcional) Leitura de faturas por IA 📄
O botão 📄 precisa de uma função no Supabase com chave Anthropic própria.
Sem isso, o botão dá erro mas **todo o resto funciona**. Posso preparar essa parte
à parte quando quiseres (precisa de créditos Anthropic do teu amigo).

## 5) Começar a usar
- Catálogo começa **vazio**: usa **“+ Produto”** para criar os produtos.
- Cada produto tem **nome genérico fixo** + várias **marcas** (nomes comerciais).
- Entradas/saídas, lista de compras (carrinho), fotos, código de barras — tudo igual.

> Dica: posso entregar também um **catálogo genérico de exemplo** para arrancar
> mais depressa, em vez de começar do zero. É só pedir.
