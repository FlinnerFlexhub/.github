# FlinnerFlexhub/.github

Org-wide GitHub defaults for the Flinner repos. GitHub uses these for every repo in the org that has no file of its own.

| File | What |
|---|---|
| `.github/ISSUE_TEMPLATE/` | Bug, feature and todo forms. Blank issues are disabled. |
| `.github/PULL_REQUEST_TEMPLATE.md` | `Closes #`, what & why, smoke / happy / grumpy test table, companion PR. |
| `.github/workflows/conventions.yml` | Reusable workflow: tags titles with the repo, checks PR titles and gitflow branches. |

A repo that keeps its own `.github/ISSUE_TEMPLATE/` or `PULL_REQUEST_TEMPLATE.md` ignores these — delete them there.

## Using the conventions workflow

Add `.github/workflows/conventions.yml` to a repo:

```yaml
name: conventions
on:
  issues:
    types: [opened, edited]
  pull_request:
    types: [opened, edited, reopened, synchronize]
permissions:
  issues: write
  pull-requests: write
jobs:
  conventions:
    uses: FlinnerFlexhub/.github/.github/workflows/conventions.yml@main
    # with:
    #   gitflow: false   # repos without gitflow (e.g. Flinner-Claude)
```

Titles become `[<repo>] type: description`, where `<repo>` is the repo name without `Flinner-`, lowercased. The branch
rules (gitflow) are explained in Flinner-Claude's `skills/github/SKILL.md`.

After changing the script, run `bash tests/conventions.sh`.
