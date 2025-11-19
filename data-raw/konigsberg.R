## code to prepare `konigsberg` dataset goes here
konigsberg = tibble::tibble(
    area = LETTERS[1:4],
    bridge_to = list(
        c("B", "B", "C", "C", "D"),
        c("A", "A", "D"),
        c("A", "A", "D"),
        c("A", "B", "C")
    )
)

usethis::use_data(konigsberg, overwrite = TRUE)
