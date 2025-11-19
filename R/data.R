#' The Seven Bridges of Königsberg
#'
#' A dataset encoding the adjacency structure of seven bridges in Königsberg,
#' Prussia, as described by Leonhard Euler in 1736.
#'
#' @format ## `konigsberg`
#' A data frame with 4 rows and 2 columns:
#' \describe{
#'   \item{area}{The four land areas, A-D, as described by Euler. Area 'A'
#'    corresponds to the central island of Kneiphof.}
#'   \item{bridge_to}{A list column, where each entry is a character vector
#'    listing the areas directly connected by bridges to the area in that row.}
#' }
#'
#' @references
#' Euler, Leonhard (1741). "Solutio problematis ad geometriam situs
#' pertinentis". _Commentarii Academiae Scientiarum Petropolitanae_: 128–140.
#'
"konigsberg"
