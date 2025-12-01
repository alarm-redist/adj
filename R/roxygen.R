# nocov start
roxy_duplicates <- function() {
    'Controls handling of duplicate neighbors. The value
    `"warn"` warns the user; `"error"` throws an error; `"allow"` allows
    duplicates, and `"remove"` removes duplicates silently and then sets the
    corresponding attribute to `"error"`.'
}

roxy_self_loops <- function() {
    'Controls handling of self-loops (nodes that are adjacent
    to themselves). The value `"warn"` warns the user; `"error"` throws an
    error; `"allow"` allows self-loops, and `"remove"` removes self-loops
    silently and then sets the corresponding attribute to `"error"`.'
}
# nocov end
