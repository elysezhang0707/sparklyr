ml_get_constructor <- function(jobj) {
  jobj %>%
    jobj_class() %>%
    lapply(ml_map_class) %>%
    Filter(length, .) %>%
    lapply(function(x) paste0("new_ml_", x)) %>%
    Filter(function(fn) exists(fn, where = asNamespace("sparklyr"),
                               mode = "function"), .) %>%
    rlang::flatten_chr() %>%
    head(1)
}

ml_constructor_dispatch <- function(jobj) {
  do.call(ml_get_constructor(jobj), list(jobj = jobj))
}

new_ml_pipeline_stage <- function(jobj, ..., subclass = NULL) {
  structure(
    list(
      uid = invoke(jobj, "uid"),
      param_map = ml_get_param_map(jobj),
      ...,
      .jobj = jobj
    ),
    class = c(subclass, "ml_pipeline_stage")
  )
}
