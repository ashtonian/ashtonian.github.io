# ashtonkinslow.com

Source for [www.ashtonkinslow.com](https://www.ashtonkinslow.com): a short profile page, three case studies and a list of merged open-source contributions. Built with [Hugo](https://gohugo.io), no theme, no client-side JavaScript, deployed to GitHub Pages by GitHub Actions.

## Build, run, test

Requires Hugo 0.146.0 or later; CI pins 0.168.0. Nothing else: no Node, no theme module.

| Command | What it does |
|---|---|
| `make serve` | Live-reloading server at http://localhost:1313 |
| `make build` | Production build into `public/` |
| `make preview` | Build for hosts with no directory index into `public-artifact/` (relative `.html` links, embedded fonts) |
| `make upstream` | Regenerate `data/upstream.json` from GitHub (needs `gh` and `jq`) |
| `make clean` | Remove build output |

CI (`.github/workflows/pages.yml`) builds every push and pull request and fails on any internal link that does not resolve. Pushes to `master` deploy.

## Configuration

All in `config/_default/hugo.toml`.

| Key | Type | Default | Description |
|---|---|---|---|
| `baseURL` | URL | `https://www.ashtonkinslow.com/` | Canonical origin |
| `locale` | string | `en-US` | Document language |
| `params.description` | string | positioning line | Meta description and JSON-LD |
| `params.location` | string | `Austin, Texas` | Shown under the home page lede |
| `params.email` | string | `hello@ashtonkinslow.com` | Footer contact |
| `params.github` | URL | GitHub profile | Footer link and JSON-LD `sameAs` |
| `params.linkedin` | URL | LinkedIn profile | Footer link and JSON-LD `sameAs` |
| `params.figuresAsOf` | date | `2026-10-19` | Date printed beside every figure; update it when the figures change |
| `params.fonts` | list | Plex Sans, Plex Mono 400/500 | Font files; `preload` marks the one preloaded |

`config/artifact/hugo.toml` overrides only what the preview build needs.

## Content and data

| Path | Holds |
|---|---|
| `content/_index.md` | Home lede, `principles` (each with `evidence`: a page ref or a name and URL; an unknown page ref fails the build) and the `also` list |
| `content/work/*.md` | Case studies. Front matter: `tagline`, `summary`, `headline` (the home page figure), `facts`, `repo`, `weight` (order) |
| `content/open-source.md` | Page rendered by `layouts/open-source.html` |
| `data/upstream.json` | Merged pull requests outside this account, from `make upstream` |
| `data/upstream_exclude.yaml` | Pull requests hidden from the site, each with a reason: list entries, typo fixes, docs- or example-only edits, housekeeping, dependency upgrades |

`layouts/_partials/upstream-projects.html` is the only place exclusions are applied. The open-source page, the home page summary, the totals and the `{{</* upstream repo="owner/name" */>}}` shortcode all read from it, so they cannot disagree. An unknown repo in the shortcode fails the build.

To refresh the contributions: `make upstream`, review the diff, and add any PR that is housekeeping to `data/upstream_exclude.yaml`. Repositories to leave out entirely go in `.upstream-exclude` (one `owner/name` per line), which is gitignored so their names are never published.

## Deployment

GitHub Pages with the source set to **GitHub Actions**. The custom domain `www.ashtonkinslow.com` is set in the repository's Pages settings; DNS and TLS sit in Cloudflare in front of Pages.

The workflow downloads the pinned Hugo release, verifies it against the release checksums, builds, checks internal links, and deploys with `actions/deploy-pages`. Actions are pinned by commit SHA; Dependabot proposes updates weekly.

## Operations

| Symptom | Check | Fix |
|---|---|---|
| A push did not change the live site | Actions tab: did `Site` run and pass on `master`? | A failed build never deploys; the previous version stays live. Fix the error in the log and push again. |
| Build fails on "broken: /path" | The link-check step names the href | Fix the link, or the page it should point at |
| Build fails in the `upstream` shortcode | The error names the repo | The repo has no shown PRs in `data/upstream.json`; regenerate or fix the shortcode |
| Site serves GitHub's 404 for every page | Settings → Pages: source must be "GitHub Actions" and the custom domain `www.ashtonkinslow.com` | Restore both, then re-run the workflow |
| Fonts fall back to system fonts | Browser devtools, Network tab | The fingerprinted font files are missing from the build; rebuild |

## Security and privacy

No client-side JavaScript, no cookies, no analytics, no third-party requests: fonts are self-hosted and the stylesheet is inlined. The only data the site publishes is already public on GitHub.

## Design

One reading column. IBM Plex Sans for text and IBM Plex Mono for figures, labels and identifiers (latin subsets from Fontsource, SIL Open Font License 1.1, `assets/fonts/OFL.txt`). Colours and spacing are tokens at the top of `assets/css/site.css`; the dark theme follows `prefers-color-scheme`. Vertical rhythm: sections 3.5rem apart, 2.5rem above a heading, 1rem between blocks, and a heading or label closer to its own content than to anything else.

## Code map

```
.github/workflows/pages.yml   build, link check, deploy
.github/dependabot.yml        weekly action updates
config/_default/hugo.toml     site config
config/artifact/hugo.toml     preview-build overrides
content/                      home, work/, open-source
data/                         upstream.json (generated), upstream_exclude.yaml (curated)
scripts/update-upstream.sh    regenerates data/upstream.json
layouts/baseof.html           document shell (fragment mode for the preview build's root page)
layouts/home.html             home
layouts/section.html          work index
layouts/work/page.html        case study
layouts/open-source.html      contributions
layouts/404.html              not found
layouts/_partials/            head, header, footer, styles, lists, totals
layouts/_shortcodes/upstream.html
layouts/_markup/render-table.html   tables scroll inside their own box on phones
assets/css/                   site.css (tokens, layout), fonts.css (template)
assets/fonts/                 Plex woff2 files and licence
static/                       favicon
```
