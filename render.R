render_report = function(coursecode) {
  rmarkdown::render(
    "Block0Sessions.Rmd", params = list(
      progcode = coursecode
    ),
    output_file = paste0(coursecode, "-block0.html")
  )
}

render_report("INB112")

render_report("G56A12")