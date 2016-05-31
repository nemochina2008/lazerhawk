#' Summarize brms-fit objects
#'
#' @description Returns a summary table of model output from the brms package.
#'   Requires the brms package.
#'
#'
#' @param model A brmsfit object
#' @param formatOptions A list(!) of options to pass to the format function
#' @param round See code{\link[base]{round}}
#' @param star Put asterisks next to effects whose credible interval does not
#'   contain 0
#' @param hype Run one-sided hypothesis tests of whether effect is greater
#'   (less) than 0 if positive (negative)
#' @param panderize Create a markdown summary table. Requires the pander package
#' @param ... Additional arguments to pass to \code{\link[brms]{summary.brmsfit}}
#'
#' @details This function creates a data.frame summary object for a brms package
#'   model object.  As of now it only does so for the fixed effects part of the
#'   model.  It will star 'significant' effects, add results from one-sided
#'   hypothesis tests, and allow additional formating options.
#'
#'   For \code{hype = TRUE}, the returned object contains a column indicating
#'   the posterior probability under the hypothesis against its alternative as
#'   noted in the hypothesis function of the brms package. Both the evidence
#'   ratio and probability are produced. Note that for effects near zero, the
#'   probability can be < .5 due to the posterior samples not being perfectly
#'   symmetric.
#'
#' @seealso \code{\link[brms]{summary.brmsfit}} \code{\link[brms]{hypothesis}}
#'   \code{\link[rstan]{print.stanfit}} \code{\link[base]{format}}
#'   \code{\link[base]{round}}
#'
#' @return A data.frame, or Pandoc markdown table if panderize=T.
#'
#' @examples
#'
#' ## Not run:
#'
#' ## Probit regression using the binomial family
#' library(brms)
#' n <- sample(1:10, 100, TRUE)  # number of trials
#' success <- rbinom(100, size = n, prob = 0.4)
#' x <- rnorm(100)
#' fit4 <- brm(success | trials(n) ~ x, family = binomial("probit"))
#' summary(fit4)
#'
#' library(lazerhawk)
#' brms_SummaryTable(fit4)
#'
#'
#' @export
brms_SummaryTable <- function(model, formatOptions=list(digits=2, nsmall=2), round=2,
                              star=F, hype=F, panderize=F, ...) {
  if(class(model) != "brmsfit") stop('Model is not a brmsfit class object.')

  est = brms:::summary.brmsfit(model, ...)$fixed
  partables = round(est[,c('Estimate', 'Est.Error', 'l-95% CI', 'u-95% CI')], round)
  estnames = rownames(partables)
  partables_formated = do.call(format, list(x=partables, formatOptions[[1]]))

  # star intervals not containing zero
  if (star){
    sigeffects0 = apply(sign(partables[,c('l-95% CI', 'u-95% CI')]), 1, function(interval) ifelse(diff(interval)==0, '*', ''))
    sigeffects =  data.frame(var=estnames, partables_formated, sigeffects0)
    colnames(sigeffects) = c('var', 'coef', 'se', '2.5%', '97.5%', '')
  } else {
    sigeffects =  data.frame(var=estnames, partables_formated)
    colnames(sigeffects) = c('var', 'coef', 'se', '2.5%', '97.5%')
  }


  # conduct hypothesis tests
  if(hype){
    signcoefs = sign(partables[,'Estimate'])
    testnams = mapply(function(coefname, sign) ifelse(sign>0, paste0(coefname, ' > 0'), paste0(coefname, ' < 0')),
                      estnames, signcoefs)
    hypetests = sapply(testnams, brms::hypothesis, x=model, simplify = F)
    ER = sapply(hypetests, function(test) test[['hypothesis']]['Evid.Ratio'])
    ER = unlist(ER)
    sigeffects$pvals = round(ER/(ER+1), round)
    sigeffects$pvals[is.infinite(ER)] = 1

    colnames(sigeffects)[ncol(sigeffects)] = 'B < > 0'
    sigeffects[,'Evidence Ratio'] = round(ER, round)
  }

  rownames(sigeffects) = NULL

  if(panderize) return(pander::pander(sigeffects))
  sigeffects
}

