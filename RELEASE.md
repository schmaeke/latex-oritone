# Release Checklist

Use this checklist before tagging a public Oritone release.

## Required

- Confirm `\ProvidesPackage` and `\ProvidesClass` dates and versions are
  consistent across `tex/latex/oritone`.
- Update `CHANGELOG.md` with the release date and user-visible changes.
- Run the regression suite:

  ```sh
  l3build check
  ```

- Rebuild the manual and all example PDFs:

  ```sh
  l3build doc
  ```

- Refresh `doc/oritone.pdf` from `build/doc/oritone.pdf`.
- Refresh screenshots in `assets/screenshots/` from the generated example PDFs.
- Open the generated CV, manuscript, thesis, Beamer, and manual PDFs and do a
  visual pass.
- Check the repository status and stage only source, docs, tests, CI, manual
  PDF, and screenshot assets intended for publication.

## Optional

- Run one local documentation build with the external `recursive` package
  available to inspect the intended Recursive Sans/Mono output.
- Run one clean documentation build without `recursive` available to confirm
  the pdfLaTeX fallback path remains usable.
- Build a release archive with `l3build ctan` before uploading to a package
  index or attaching release artifacts.

## Tagging

For the first public release:

```sh
git tag v0.1.0
git push origin v0.1.0
```
