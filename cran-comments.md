## Test environments
* Ubuntu 20.04.2 LTS, 4.1.3 (2022-03-10) (local)
* Windows R version 4.2.0 (2022-04-22 ucrt) (win-builder)
* Windows R Under development (unstable) (2022-04-25 r82253 ucrt) (win-builder)
* Windows R version 4.1.3 (2022-03-10) (win-builder)
* Microsoft Windows Server 2022, R version 4.2.0 (2022-04-22 ucrt) (GitHub Actions)
* Ubuntu 20.04.04 LTS, R Under development (unstable) (2022-04-21 r82226) (GitHub Actions)

## R CMD check results
Status: OK

## Downstream dependencies
There are no downstream dependencies.

## CRAN checks
There are no issues with CRAN checks.

# [!!] Change of maintainers
The package was formerly maintained by Rodrigo Azuero Melo <rodazuero@gmail.com>. After mutual agreement I am taking over as a maintainer. 

The change of maintainer comes with a major version bump (3.4 >> 4.0.0). No new user facing functionality is introduced, but some cleaning up was necessary (the last CRAN version is dated 2018-08-28).

This includes unit testing via {testthat}. Note that since the package functionality is entirely dependent on API key it is not practical to have the unit tests run on CRAN hardware (the same applies to examples). I am relying on monthly checks on GitHub Actions instead.

Also the section of examples was transformed to vignette format.
