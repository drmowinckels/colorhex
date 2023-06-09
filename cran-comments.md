## Test environments
* local R installation, R 4.3.0
* win-builder (devel)
* github actions:
  - {os: macos-latest,   r: 'release'}
  - {os: windows-latest, r: 'release'}
  - {os: ubuntu-latest,   r: 'devel', http-user-agent: 'release'}
  - {os: ubuntu-latest,   r: 'release'}
  - {os: ubuntu-latest,   r: 'oldrel-1'}


## R CMD check results

0 errors | 0 warnings | 1 note

* fixed url in DESCRIPTION as per e-mail notification
