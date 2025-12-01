## code to prepare `konigsberg` dataset goes here
konigsberg = tibble::tibble(
    area = LETTERS[1:4],
    bridge_to = list(
        c("B", "B", "C", "C", "D"),
        c("A", "A", "D"),
        c("A", "A", "D"),
        c("A", "B", "C")
    ),
    x = c(20.51, 20.5115, 20.511, 20.517),
    y = c(54.706, 54.709, 54.703, 54.705)
)

usethis::use_data(konigsberg, overwrite = TRUE)
