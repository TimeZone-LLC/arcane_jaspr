# Bundled font licenses

The Neubrutalism renderer bundles the four font families used by [neubrutalism.com](https://neubrutalism.com/). Each family is licensed under the SIL Open Font License 1.1. The original, unmodified WOFF2 files are embedded in `lib/src/neubrutalism_fonts.dart`; no font network requests or host asset copies are required.

| Family | Role | Included weights | License |
| --- | --- | --- | --- |
| Inter | Body and controls | 400–700 | [OFL](licenses/inter_OFL.txt) |
| Space Grotesk | Headings | 400–700 | [OFL](licenses/space_grotesk_OFL.txt) |
| Space Mono | Code and labels | 400, 700 | [OFL](licenses/space_mono_OFL.txt) |
| Syne | Display text | 700–800 | [OFL](licenses/syne_OFL.txt) |

Latin and Latin Extended subsets retain the Unicode ranges supplied by Google Fonts. Inter, Space Grotesk, and Syne use variable weight faces. Other scripts fall back to the configured system font stack.

## Provenance

Downloaded from the official Google Fonts CSS API on 2026-10-25 using this [family and weight request](https://fonts.googleapis.com/css2?family=Inter:wght@400..700&family=Space+Grotesk:wght@400..700&family=Space+Mono:wght@400;700&family=Syne:wght@700..800&display=swap). The license texts come from the corresponding family directories in the [Google Fonts repository](https://github.com/google/fonts/tree/main/ofl).

| Family | Subset | Original WOFF2 | SHA-256 |
| --- | --- | --- | --- |
| Inter 400–700 | latin-ext | [Google Fonts](https://fonts.gstatic.com/s/inter/v20/UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa25L7W0Q5n-wU.woff2) | `a28eb6d3ccb534ae0c94ca999371df024aab60b08c3c8a5720ee9e32fa0faaa2` |
| Inter 400–700 | latin | [Google Fonts](https://fonts.gstatic.com/s/inter/v20/UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa1ZL7W0Q5nw.woff2) | `c940764593d0fe5d596be327ca7558855e018039fb78509aa21921fd3644c3e4` |
| Space Grotesk 400–700 | latin-ext | [Google Fonts](https://fonts.gstatic.com/s/spacegrotesk/v22/V8mDoQDjQSkFtoMM3T6r8E7mPb94C_k3HqUtEw.woff2) | `054c266fbb441ee059365dba0885d206f67ca05b375de869b88e02ebfccc9b9d` |
| Space Grotesk 400–700 | latin | [Google Fonts](https://fonts.gstatic.com/s/spacegrotesk/v22/V8mDoQDjQSkFtoMM3T6r8E7mPbF4C_k3HqU.woff2) | `a0d054c4af557de20afd6ca59f47ab353bcaec49c63ff04b6c9d39d0f8910557` |
| Space Mono 400 | latin-ext | [Google Fonts](https://fonts.gstatic.com/s/spacemono/v17/i7dPIFZifjKcF5UAWdDRYE98RXi4EwSsbg.woff2) | `b4f90459adf4851575a46d9a492c17ee34c97fe40d56979521de67d1ee77d75a` |
| Space Mono 400 | latin | [Google Fonts](https://fonts.gstatic.com/s/spacemono/v17/i7dPIFZifjKcF5UAWdDRYEF8RXi4EwQ.woff2) | `e0c8e616bda27642f4c3cebaecff6525d901e73afc8a227cbbb0f2af4810f300` |
| Space Mono 700 | latin-ext | [Google Fonts](https://fonts.gstatic.com/s/spacemono/v17/i7dMIFZifjKcF5UAWdDRaPpZUFuaHi6WZ3S_Yg.woff2) | `512458b32bf452ac0e4b33fd6277bf4f07821acefb59db2d1498aa107679a1a6` |
| Space Mono 700 | latin | [Google Fonts](https://fonts.gstatic.com/s/spacemono/v17/i7dMIFZifjKcF5UAWdDRaPpZUFWaHi6WZ3Q.woff2) | `af7cf6d2b897ec453acdcdacde4e9bcc8410718af5914de865b453e09f10eebc` |
| Syne 700–800 | latin-ext | [Google Fonts](https://fonts.gstatic.com/s/syne/v24/8vIH7w4qzmVxm25L9G78HEZnMg.woff2) | `79bc839264c4a3c9b988de4acbc0dcf0d9ca4b41e2df523940f81b78e3d6fdb3` |
| Syne 700–800 | latin | [Google Fonts](https://fonts.gstatic.com/s/syne/v24/8vIH7w4qzmVxm2BL9G78HEY.woff2) | `cfff412005eed2f0152d1c110c78ac564642b943e64322fbd687083177d6fa70` |

## NeuComic fonts

The NeuComic variant additionally bundles Bangers for comic-book headings and display text, and Comic Neue for readable handwritten body text and controls. The original, unmodified WOFF2 files are embedded in `lib/src/neucomic_fonts.dart`, with no font network requests or host asset copies required.

| Family | Role | Included weights | Included subsets | License |
| --- | --- | --- | --- | --- |
| Bangers | Headings and display text | 400 normal | Latin, Latin Extended | [OFL](licenses/bangers_OFL.txt) |
| Comic Neue | Body and controls | 400, 700 normal | Latin | [OFL](licenses/comic_neue_OFL.txt) |

These are static weight faces. Their Unicode ranges are retained exactly from Google Fonts. Comic Neue's CSS response provides Latin only; characters outside the included subsets fall back to the configured font stack.

Downloaded from the official Google Fonts CSS API on 2026-10-25 using this [family and weight request](https://fonts.googleapis.com/css2?family=Bangers&family=Comic+Neue:wght@400;700&display=swap). Both families use the SIL Open Font License 1.1. The bundled license texts preserve these notices:

- Bangers: Copyright 2010 The Bangers Project Authors ([upstream](https://github.com/googlefonts/bangers), [original license](https://raw.githubusercontent.com/google/fonts/main/ofl/bangers/OFL.txt)).
- Comic Neue: Copyright 2014 The Comic Neue Project Authors ([upstream](https://github.com/crozynski/comicneue), [original license](https://raw.githubusercontent.com/google/fonts/main/ofl/comicneue/OFL.txt)).

| Family | Subset | Original WOFF2 | SHA-256 |
| --- | --- | --- | --- |
| Bangers 400 | latin-ext | [Google Fonts](https://fonts.gstatic.com/s/bangers/v25/FeVQS0BTqb0h60ACH5BQ2J5hm25mww.woff2) | `532d54b2854cf8692dfedfcbb85064e7b6da4f2b26814a34eec028a68576df93` |
| Bangers 400 | latin | [Google Fonts](https://fonts.gstatic.com/s/bangers/v25/FeVQS0BTqb0h60ACH55Q2J5hm24.woff2) | `d37507cc3862404b3f67db10e94e6e2036052a40fc16ab559c7201edf4a77da4` |
| Comic Neue 400 | latin | [Google Fonts](https://fonts.gstatic.com/s/comicneue/v9/4UaHrEJDsxBrF37olUeD96rp57F2IwM.woff2) | `9baadbbabee2f073ca6c9fafe13de388d5db5fdfbecda8438ffd4f14f2624d1c` |
| Comic Neue 700 | latin | [Google Fonts](https://fonts.gstatic.com/s/comicneue/v9/4UaErEJDsxBrF37olUeD_xHM8pxULilENlY.woff2) | `18e9d8e67a65aed631e25fd649b8a10293ac607a0c3a55a55de909da7d64386e` |
