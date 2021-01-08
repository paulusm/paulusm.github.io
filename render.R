render_report = function(coursecode) {
  rmarkdown::render(
    "Block0Sessions.Rmd", params = list(
      progcode = coursecode
    ),
    output_format = "md_document",
    output_options = list(variant="gfm"),
    output_file = paste0(coursecode, "-block0.md")
  )
}

render_report("INB112")

render_report("G56A12")