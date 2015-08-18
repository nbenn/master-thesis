knit_hooks$set(chunk = function(x, options) x)
knit_hooks$set(source = function(x, options) {
  paste0("\\begin{rcode}\n", x, "\n\\end{rcode}\n")
})
knit_hooks$set(output = function(x, options) {
  x <- unlist(strsplit(x, "\n"))
  x <- gsub("^> ", "", x)
  x <- gsub("^\\+ ", "", x)
  x <- gsub("    ", "  ", x)
  x <- paste(c(x, ""), collapse = "\n")
  paste0("\\begin{rcode}\n", x, "\n\\end{rcode}\n")
})
