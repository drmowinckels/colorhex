## Test environments
* local R installation, R 4.0.2
* ubuntu 16.04 (on travis-ci), R 4.0.2
* win-builder (devel)
* github actions:
  - {os: windows-latest, r: 'release'}
  - {os: macOS-latest, r: 'release'}
  - {os: ubuntu-20.04, r: 'release', rspm: "https://packagemanager.rstudio.com/cran/__linux__/focal/latest"}
  - {os: ubuntu-20.04, r: 'devel', rspm: "https://packagemanager.rstudio.com/cran/__linux__/focal/latest"}


## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* added `on.exit()` before changing `par()`
* added 'https:' to url in DESCRIPTION
