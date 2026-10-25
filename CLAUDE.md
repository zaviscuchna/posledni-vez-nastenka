# Pro Clauda: nástěnka Poslední věže

Nástěnku k hře Poslední věž (mobilní hra ve stylu Kingdom New Lands + The Tower) si upravují
Maty a Záviš sami, každý přes svůj Claude Code. **Žádné issues, PR ani schvalování.**
Když člověk řekne, co chce změnit, udělej to, vyzkoušej a nahraj rovnou do `main`.
Neptej se, jestli založit úkol.

## Postup
1. `git pull --rebase` (můžou na tom dělat oba zároveň)
2. Uprav, vyzkoušej lokálně: `python3 -m http.server 8000` → http://localhost:8000
   (přihlášení vlastním klíčem, jede to nad skutečnými daty, testovací příspěvky
   pojmenuj `TEST …` a po sobě je smaž tlačítkem 🗑).
   **Vyzkoušej i na šířce telefonu (360–390 px):** Maty přidává nápady hlavně z mobilu.
   Nic nesmí jezdit do strany a dotykové cíle mají aspoň 44 px.
3. `bash scripts/check.sh`
4. `git commit` + `git push` do `main`. Když push odmítne kvůli novějším změnám:
   `git pull --rebase` a znovu.
5. GitHub sám spustí kontrolu a do ~1 minuty nasadí. **Když kontrola neprojde, nenasadí
   se nic a zůstává předchozí verze.** Ověř `gh run list -R zaviscuchna/posledni-vez-nastenka --limit 1`
   a když je neúspěch, oprav to hned.

Uživateli pak řekni jednou větou, co je jinak, a že je to na
https://zaviscuchna.github.io/posledni-vez-nastenka/ (obnovit stránku).

## Jak to funguje
- Statická stránka bez buildu: `index.html`, `style.css`, `app.js` (vanilla JS, ES modul).
  Na Pages se nahrávají jen tyhle soubory (viz `.github/workflows/check.yml`).
- Data NEJSOU tady. Jsou v soukromém repu `matyzek/posledni-vez` (větev `main`) a nástěnka
  je čte a zapisuje přes GitHub API klíčem přihlášeného člověka:
  - příspěvek = issue se štítkem `nápad`, `grafika`, `rozhodnutí` nebo `stavba`
  - oblast = další štítek (seznam v `CATS` v `app.js`)
  - stav = štítek `diskuse` / `schváleno` / `zamítnuto`, bez štítku = nový
  - skrytý (smazaný ne-správcem) = štítek `smazáno`
  - hlas = reakce 👍 / 👎 na issue
  - obrázky = soubory v `board/navrhy/…/vN.ext`, seznam je v těle issue
    v komentáři `<!-- nastenka {"files":[...]} -->`
    (cesty mimo `board/navrhy/<složka>/<soubor>` nástěnka ignoruje, viz `jeNavrh()`: tělo issue
    může upravit kdokoli a správce by jinak svým klíčem smazal cizí soubor)
  - schválená grafika se kopíruje do `docs/art/<kategorie>/` (mapa `ART_DIR` v `app.js`,
    musí sedět se složkami v `docs/art` herního repa a s `docs/art/assety.json`: postavy,
    nepratele, stavby, prostredi, predmety, ui, efekty)
  - rozhodnutí: možnosti v `{"options":[...]}`, hlas = komentář `<!-- hlas {"o":N} -->`
    (jeden na člověka, změna = úprava komentáře), po uzavření `winner` + `record`
    a zápis `docs/rozhodnuti/NNN-nazev.md`
  - stavba (úkol): kdo dělá = assignee, hotovo = zavřené issue, postup = `- [x]` v těle,
    závislosti = řádek `Závisí na: #12, #13`. Tenhle formát používá i Claude v herním repu,
    takže ho neměň bez úpravy obou míst.
  - tlačítko 📜 Návod na grafiku ukazuje `docs/art/README.md`, 📖 GDD ukazuje `docs/GDD.md` z herního repa
- Štítky, které nástěnka potřebuje, jsou v `LABELS` v `app.js`. Když v repu nějaký chybí,
  nástěnka ukáže nahoře pruh s tlačítkem „Založit štítky“ (jen pro lidi s právem zápisu).
- Opravdové smazání issue (GraphQL `deleteIssue`) smí jen správce repa na GitHubu (admin).
  Ostatním se příspěvek jen zavře a skryje štítkem `smazáno`.
- Nastavení (repo, tým, jména) je v `CFG` na začátku `app.js`.

## Co se NESMÍ rozbít
1. **Formát dat výše.** Existující příspěvky musí jít dál číst. Když formát měníš,
   nová verze musí umět i ten starý.
2. **Klíč (token).** Posílá se jen na `api.github.com`. Žádné další servery, analytika,
   skripty z cizích CDN. Repo je veřejné. `scripts/check.sh` to hlídá.
3. **Uživatelský text jen přes `textContent`** (helper `h()`), nikdy přes `innerHTML`.
   Jinak by kdokoli mohl do nápadu vložit skript a ukrást ostatním klíč.
4. **Všechny dotazy na API mají `cache: 'no-store'`** (je to v `gh()`), GitHub posílá
   `max-age=60` a hlasy by se ukazovaly pozdě. Volej API jen přes `gh()`.
5. **Pixel art** se zvětšuje jen celými násobky a s `image-rendering: pixelated`.
6. **Telefon.** Šířka 360 px bez vodorovného posuvu, spodní lišta záložek, Stavba po sloupcích.
7. Čeština v UI, tón stručný a lidský.

## Styl kódu
Drž se toho, co v `app.js` je: malé funkce, helper `h()` na DOM, `gh()` na API,
komentář jen tam, kde je důvod neviditelný z kódu. Žádný framework ani build krok.
Barvy a písma jsou proměnné na začátku `style.css` (noc, věž, oheň, zlatá mince).
`check.sh` pouští do repa jen soubory stránky; když přidáš nový druh souboru, uprav i jeho seznam.
