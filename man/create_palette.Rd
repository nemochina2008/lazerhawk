% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_palette.R
\name{create_palette}
\alias{create_palette}
\title{Create a color palette}
\usage{
create_palette(colorhex, name = NULL, toHCL = FALSE, plot = FALSE,
  alpha = 1)
}
\arguments{
\item{colorhex}{Hexadecimal value of color or an R color name.}

\item{name}{optional name of color}

\item{toHCL}{Convert colors to hcl. Defaults to \code{FALSE}.}

\item{plot}{Plot the results. Defaults to \code{FALSE}.}

\item{alpha}{Transparency. Takes values from 0 to 1. Default is 1.}
}
\value{
A list of colors
}
\description{
Uses colortools package (and possibly scales) to easily create a
  color palette based on a initial input color.
}
\details{
Will return complementary, analogous/adjacent, split complementary,
  triadic, square and tetradic color values relative to the initial color. Note that if you want sequential, qualitative, diverging etc., other packages like \href{https://cran.rstudio.com/web/packages/colorspace/}{RColorBrewer}, \href{https://cran.rstudio.com/web/packages/colorspace/}{colorspace}, and \href{https://cran.rstudio.com/web/packages/colortools/}{colortools} will do that for you.
}
\examples{
create_palette(colorhex = '#ff5500', name='orange')
create_palette(colorhex = '#ff5500', name='orange', alpha=.5)

}
