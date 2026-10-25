# Poslední věž · nástěnka

Nápady, návrhy grafiky, rozhodnutí a úkoly k mobilní hře **Poslední věž** na jednom místě.
Běží na https://zaviscuchna.github.io/posledni-vez-nastenka/ a dobře se ovládá i z telefonu.

Tohle repo obsahuje **jen kód stránky** a je veřejné, protože GitHub Pages
na bezplatném účtu jinak nejde. Všechna data (nápady, obrázky, hlasy, komentáře)
jsou v soukromém repu `matyzek/posledni-vez` a nástěnka k nim přistupuje
přes GitHub API klíčem přihlášeného člověka. Bez přístupu k `posledni-vez` neuvidíš nic.

- `index.html`, `style.css`, `app.js`: vanilla JS, žádný build
- nastavení týmu a repa je na začátku `app.js` (`CFG`)
- lokálně: `python3 -m http.server` a otevřít `http://localhost:8000`

## Co umí
- **Nápady** a **grafika**: karty s obrázky, hlasování 👍 / 👎, komentáře, verze obrázků,
  schválená grafika se sama uloží do `docs/art/<kategorie>/` herního repa
- **Rozhodnutí**: otázka s možnostmi, každý hlasuje pro jednu, po uzavření zápis do `docs/rozhodnuti/`
- **Stavba**: úkoly Na řadě / Dělá se / Hotovo, kdo na čem dělá, postup a závislosti
- přímé odkazy: `…/#grafika` otevře záložku, `…/#12` rovnou příspěvek

## Úpravy
Nástěnku si upravujeme sami: řekni svému Claude Code, co chceš změnit. Pravidla má v [`CLAUDE.md`](CLAUDE.md).
Každý push do `main` projde kontrolou a do minuty je živě. Když kontrola selže, zůstane předchozí verze.

## První nasazení (jednou)
1. Veřejné repo `zaviscuchna/posledni-vez-nastenka`, push `main`.
2. Settings → Pages → Source: **GitHub Actions** (`build_type=workflow`).
3. Maty v `matyzek/posledni-vez` pozve spoluhráče (Settings → Collaborators).
4. Při prvním přihlášení nástěnka nabídne založit chybějící štítky.
