module = "oritone"

-- Keep the generated manual in doc/. l3build copies finished PDFs back to
-- docfiledir, so using the repository root here would leave release artifacts
-- next to the source tree.
docfiledir = "doc"

sourcefiles = {
  "tex/latex/oritone/*.sty",
  "tex/latex/oritone/*.cls",
}

installfiles = {"*.sty", "*.cls"}
checkfiles = {"testfiles/*.lvt"}
docfiles = {
  "oritone.tex",
}
typesetfiles = {
  "oritone.tex",
  "cv-light.tex",
  "cv-dark.tex",
  "cv-white.tex",
  "cv-black.tex",
  "manuscript-light.tex",
  "manuscript-dark.tex",
  "manuscript-white.tex",
  "manuscript-black.tex",
  "thesis-light.tex",
  "thesis-dark.tex",
  "thesis-white.tex",
  "thesis-black.tex",
  "beamer-light.tex",
  "beamer-dark.tex",
  "beamer-white.tex",
  "beamer-black.tex",
}

checkengines = {"pdftex", "luatex", "xetex"}
stdengine = "pdftex"

-- The canonical examples live in examples/, but l3build derives output
-- destinations from the path in typesetfiles. Copy the example sources into the
-- temporary typesetting directory and list them above by basename so the PDFs go
-- to doc/ instead of path-derived hidden files at the repository root.
function docinit_hook()
  return cp("*.tex", "examples", typesetdir)
end
