knit_hooks$set(chunk = function(x, options) x)
knit_hooks$set(source = function(x, options) {
    paste0("\\begin{rcode}\n", x, "\n\\end{rcode}\n")
})
