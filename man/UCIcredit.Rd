\name{UCIcredit}
\alias{UCIcredit}
\docType{data}
\title{Taiwanese credit-card repayment outcomes and histories}
\description{All 30,000 records of the UCI Default of Credit Card Clients
dataset. One row is a client. These are Taiwanese observations, not Swiss data.}
\usage{data(UCIcredit)}
\format{A data frame with 30,000 rows and 25 numeric variables:
\describe{
\item{borrower_id}{Original ID, unique record identifier, not a predictive feature.}
\item{LIMIT_BAL}{Credit limit in New Taiwan dollars (NTD), including individual and supplementary family credit. Not income.}
\item{SEX}{Source code: 1 male, 2 female.}
\item{EDUCATION}{Source codes 1 graduate school, 2 university, 3 high school, 4 other. Codes 0, 5 and 6 also occur and are retained as undocumented categories.}
\item{MARRIAGE}{Source codes 1 married, 2 single, 3 other. Code 0 also occurs and is retained without inventing a category.}
\item{AGE}{Age in years.}
\item{PAY_0, PAY_2, PAY_3, PAY_4, PAY_5, PAY_6}{Repayment-status codes for September, August, July, June, May and April 2005, respectively. Source documentation defines -1 as paying duly and positive integers as months of payment delay. Additional codes -2 and 0 are retained; the official description does not define them. Treat status as categorical unless an explicit coding assumption is made. PAY_0 is September; PAY_1 is not a variable.}
\item{BILL_AMT1, BILL_AMT2, BILL_AMT3, BILL_AMT4, BILL_AMT5, BILL_AMT6}{Statement amounts in NTD, September back to April 2005. Negative balances are retained, not clipped or logged automatically.}
\item{PAY_AMT1, PAY_AMT2, PAY_AMT3, PAY_AMT4, PAY_AMT5, PAY_AMT6}{Previous-payment amounts in NTD, September back to April 2005.}
\item{default_next_month}{Original binary next-month default-payment indicator, 1 yes and 0 no; 6,636 ones. Not a measure of ultimate loss given default or lifetime insolvency.}
}}
\details{Downloaded 20 October 2026 from UCI dataset 350. All source rows and
values are retained; only ID and the outcome column are renamed. No missing
values occur in the source extract. Undocumented category codes are not silently
converted to missing or pooled. Use factors for nominal demographic/status codes.

The outcome supports logit/probit, marginal effects and predictive evaluation.
It does not establish causal effects, and an aggregate shift in credit limits
must not be called an income intervention. No income, loan interest rate or
Swiss borrower population is present. Split train/test by client and exclude
borrower_id from predictors. The six monthly histories are predictors within
one record, not six independent default outcomes.

The frozen ZIP, source metadata and SHA-256 are in the source repository's
data-raw/UCIcredit directory. Rebuild with its build.R (base R plus readxl and
shasum). Ordinary use requires no network access or readxl. Installed column
mappings and hashes are in teaching-data/. The original XLS is inside the ZIP;
the preparation reads its second row as the header.
}
\section{Redistribution}{CC BY 4.0, as explicitly stated on the UCI dataset
page. Credit I-Cheng Yeh and UCI Machine Learning Repository, link the licence
and identify the two renamed columns. This does not place legacy AEC credit
data under the same licence.}
\source{Yeh, I. (2009). Default of Credit Card Clients [Dataset]. UCI Machine
Learning Repository. DOI: 10.24432/C55S3H.
\url{https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients}}
\references{\url{https://creativecommons.org/licenses/by/4.0/}}
\examples{
data(UCIcredit)
mean(UCIcredit$default_next_month)
fit <- glm(default_next_month ~ AGE + factor(EDUCATION) + factor(PAY_0),
           data=UCIcredit, family=binomial(link="probit"))
head(predict(fit, type="response"))
}
\keyword{datasets}
