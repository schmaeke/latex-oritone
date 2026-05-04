# Changelog

## 0.1.0 - 2026-05-04

Initial public release.

- Adds the shared `oritone` package with light, dark, white, and black modes.
- Adds semantic color roles for text, surfaces, links, listings, plots,
  callouts, headers, footers, and accents.
- Adds centralized font loading through `oritone-fonts`, defaulting to
  Recursive Sans, Recursive Mono, STIX Two Text, and STIX Two Math.
- Adds a pdfLaTeX fallback path when the external `recursive` package is not
  installed.
- Adds shared document-design helpers in `oritone-design`, including localized
  labels, semantic links, callouts, page-color helpers, and ruled title blocks.
- Adds `oritone-cv`, `oritone-manuscript`, and `oritone-thesis` classes.
- Adds the Oritone Beamer theme with color, font, inner, outer, and option
  subthemes.
- Adds filled examples for CV, manuscript, thesis, and Beamer output across all
  four modes.
- Adds a user manual, README screenshots, release checklist, and GitHub Actions
  CI for `l3build check` and `l3build doc`.
- Adds smoke tests for the public CV, manuscript, thesis, and Beamer frontends.
