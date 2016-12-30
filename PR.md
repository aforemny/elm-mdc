# Pull requests

We have a few simple guidelines we'd like you to follow when you submit a PR.
You don't have to; we'll consider your PR anyway also if you don't follow these
guidelines, but it saves us a lot of time and effort if you do. 


## Submit your PR against the right branch

  Make the PR against master if `elm-package diff` reports a major version bump,
  against the current version branch otherwise. 

  Example. You implement a feature on the v8 branch. `elm-package diff` reports
  a "minor version change". Submit a PR against the v8 branch. If instead 
  `elm-package diff` reports a "major version change", submit a PR against master. 

  Submitting your PR to the correct branch ensures that your fix/feature goes
  out as quickly as possible—PRs against master waits for the next major
  version, which could be months away. 

## Write good commit messages and PR titles

Follow [these guidelines](http://chris.beams.io/posts/git-commit/) for formulating 
  commit messages and PR titles. Especially the [seven
  rules](http://chris.beams.io/posts/git-commit/#seven-rules) are important: 

1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line
6. Wrap the body at 72 characters
7. Use the body to explain what and why vs. how

We generate release-notes
[semi-automatically](https://github.com/skywinder/github-changelog-generator)
from commit-messages and PR titles. If your commit message and PR titles are
neat and informative already, we won't have to edit them for the release notes. 

## Link issues in commit messages

If your PR fixes a bug or adds a feature on the
[https://github.com/debois/elm-mdl/issues](issue list), add a github keyword to
your commit message.

Example. Commit 5d0c0bea0ff53f7c3c3187e606106e72ade87095 fixes #170. This is
the commit-message:

```
Make Layout.navigation respect style option

Fix #170.
```

If your commit is related to an issue or a PR but doesn't fix anything
outright, add a "See also" instead. E.g., commit b356572ca0b06dca602cf15a6658414ff045c273
fixes an unreported issue related to #137. This is the commit-message:
```
Fix wrong recording of Layout tabs width
    
See also: #137.
```

Adding `Fix` signals to Github that the referenced issue should be closed when
the commit is merged. "See also" references show up at the referenced issue/PR
and may help solve problems there later. For example, your PR partially solves
a problem for some issue, or it is a [not-quite succesful
attempt](https://github.com/debois/elm-mdl/issues/161#ref-commit-1c3d7ea) at
fixing a bug. 


## Do not merge your own PRs

(For contributors with commit-rights only.)

If a PR resp. commit contains changes to a `.elm` file, do not merge it
yourself resp. commit it directly. 

We respect this rule because (a) it radically improves code quality, and (b) we
want to have a culture of discussion around PRs.  Someone might know an Elm
trick you didn't know; recognise that your PR might be useful for a different
part of the library; catch a bug; suggest improvements to documentation, etc.
Having such a discussion in comments for the PR also gives users a chance to
voice concerns we may not have thought about. Everything is better this way. 

### Exemptions
Minor corrections to documentation comments can be merged/committed directly. 

The demo is **not** exempt from this rule. Users, many of which are newcomers
to Elm, take inspiration from it; it should be a shining example of Elm
programming. (It currently isn't because we didn't respect the rule in the
past.)


## Rebase before submitting your PR

(Someone please briefly what we expect of people and why.)
