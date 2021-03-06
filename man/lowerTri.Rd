% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lowerTri.R
\name{lowerTri}
\alias{lowerTri}
\alias{upperTri}
\title{Return a triangular matrix}
\usage{
lowerTri(x, diag = FALSE, valuesOnly = FALSE, otherVal = 0)

upperTri(x, diag = FALSE, valuesOnly = FALSE, otherVal = 0)
}
\arguments{
\item{x}{A matrix}

\item{diag}{logical. Include the diagonal? Default is false.}

\item{valuesOnly}{logical. Return only the lower/upper triangle values (including diag
argument)}

\item{otherVal}{numeric or NA. what to make nonlower/upper values. \code{0} by
default.}
}
\value{
A lower or upper triangular matrix, possibly with diagonal. If
  \code{valuesOnly} is \code{TRUE}, then only the vector of values are
  returned.
}
\description{
Returns the upper or lower triangle of a matrix.
}
\details{
This function returns the lower/upper triangle of a square matrix rather
  than just its indices (e.g. as lower.tri does). \code{otherVal} is only relevant
  if \code{valuesOnly} is \code{FALSE}.
}
\examples{
library(lazerhawk)
(m <- matrix(1:9, 3, 3, byrow=TRUE))
lower.tri(m)
lowerTri(m)
lowerTri(m, diag=TRUE, otherVal=NA)
lowerTri(m, valuesOnly=TRUE)
upperTri(m, diag=TRUE, otherVal=NA)
}
\seealso{
\code{\link[base]{lower.tri}},  \code{\link[base]{diag}},  \code{\link[base]{matrix}}
}
