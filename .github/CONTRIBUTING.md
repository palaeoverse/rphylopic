# Contributing to rphylopic

## How to contribute

### Minor changes

You can fix typos, spelling mistakes, or grammatical errors in the documentation directly on GitHub, provided it is done so in the source file. This means you’ll need to edit `roxygen2` comments in the `.R` file, not the `.Rd` file.

### Substantial changes

If you would like to make a substantial change, you should first file an issue and make sure someone from the development team agrees that it’s needed. If you’ve found a bug, please file an issue that illustrates the bug with a reproducible example.

### Pull request process

You (the contributor) should clone the desired repository (i.e. [the rphylopic R package](https://github.com/palaeoverse-community/rphylopic)) to your personal computer. Before changes are made, you should switch to a new git branch (i.e., not the main branch). When your changes are complete, you can submit your changes for merging via a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests) (“PR”) on GitHub. Note that a complete pull request should include a succinct description of what the code changes do, proper documentation (via [roxygen2](https://roxygen2.r-lib.org)), and unit tests (via `testthat`). Only the description is required for the initial pull request and code review (see below), but pull requests will not be merged until they contain complete documentation and tests.

If you don't feel comfortable implementing changes yourself, you can submit a bug report or feature request as a GitHub issue in the proper repository (e.g. [rphylopic issues](https://github.com/palaeoverse-community/rphylopic/issues)).

## Code review
All pull requests will be reviewed by a developer of rphylopic ([see collaborators](https://github.com/palaeoverse-community/rphylopic)) before merging. The review process will ensure that contributions 1) meet the standards and expectations as described above, 2) successfully perform the functions that they claim to perform, and 3) don't break any other parts of the codebase.

Submitting a pull request for one of the rphylopic R packages will automatically initiate an [R CMD check]( https://r-pkgs.org/check.html), [lintr check](https://lintr.r-lib.org/index.html), and [test coverage check](https://github.com/r-lib/covr) via GitHub Actions. While these checks will conduct some automatic review to ensure the package has not been broken by the new code and that the code matches the style guide (see above), a manual review is still required before the pull request can be merged.

Reviewers may have questions while reviewing your pull request. You are expected to respond to any of these questions via GitHub. If fixes and/or changes are required, you are expected to make these changes. If the required changes are minor enough, reviewers may make them for you, but this should not be expected. If you have any questions or lack the background to make the required changes, you should work with the reviewer to determine a plan of attack.

## Code of Conduct

Please note that by contributing to `rphylopic` you agree to our [Code of Conduct](https://rphylopic.palaeoverse.org/CODE_OF_CONDUCT.html).
