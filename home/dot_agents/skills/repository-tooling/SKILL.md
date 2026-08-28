---
name: repository-tooling
description: Audit or set up a repository's complete developer toolchain. Use when bootstrapping a repository or reviewing mise, language runtimes, package-managed development tools, lint/format/build/test commands, or CI reproducibility. Account for every dependency layer from installing mise through running the aggregate check.
---

# Repository tooling

Own the complete path from a fresh machine and checkout to a successful build
and quality check. A command already installed on one developer's machine does
not satisfy a project dependency.

## Workflow

1. Read the repository instructions and inspect its manifests, lockfiles, mise
   configuration, task runner, scripts, CI, containers, source types, shebangs,
   and nested project roots.
2. Build a toolchain inventory using the ownership layers below. Account for
   every command required to install dependencies, generate code, format, lint,
   type-check, test, build, scan, and run CI. Record why each plausible tool is
   required or not applicable.
3. Give every required tool one authoritative declaration at the lowest layer
   that naturally owns its version. Preserve an established equivalent when it
   is reproducible; avoid declaring the same tool in mise and an ecosystem
   manifest without a concrete reason.
4. Follow the repository's version policy. If none exists, use exact versions
   or moving selectors backed by committed lockfiles. Keep monorepo tools at the
   narrowest shared root that owns all of their inputs.
5. Wire tools into the existing task runner. Provide read-only `check` and
   writing `format` entry points as applicable, and keep focused `lint`, `test`,
   `build`, or generation tasks reachable independently. When mise is adopted
   and no runner exists, mise tasks are the default runner.
6. Make existing CI install the same declared dependencies and call the same
   aggregate task used locally. Creating an otherwise absent CI system remains
   a separate decision.
7. Install tools and modify files only when setup is authorized. An audit or
   explanation reports missing declarations and wiring without changing them.
8. Exercise the full bootstrap path as far as the environment permits. The work
   is complete when a fresh checkout has a documented way to obtain mise,
   install runtimes and packages, and run an aggregate check covering every
   owned source class.

## Ownership layers

| Layer | What belongs here | Typical declaration |
| --- | --- | --- |
| Bootstrap | mise itself and anything required before `mise install` can run | OS package manifest, installer/bootstrap script, devcontainer, CI setup action, and concise setup documentation |
| Runtimes and package managers | Go, Bun, Node.js, Python, and other execution environments selected by the repository | Repository-local `mise.toml` |
| Ecosystem dependencies | Tools resolved and locked with application packages, especially tools imported by config or plugins | `devDependencies` plus the package lockfile, Go tool dependencies, or the ecosystem's equivalent |
| Standalone repository tools | External binaries used by repository checks but not naturally owned by its package graph | Repository-local `mise.toml` |
| Runtime-provided tools | Commands shipped by a declared runtime, such as `gofmt` and `go test` | The runtime version; add no duplicate tool declaration |
| Entry points | Stable install, check, format, lint, test, build, scan, and generation commands | Existing task runner, package scripts, or mise tasks |

mise cannot bootstrap itself. Verify that local setup and CI can obtain a
compatible mise release before relying on `mise.toml`; pin or constrain that
release wherever the bootstrap mechanism supports it. Project checks must still
declare their mise-managed tools locally even when a developer also installs
them in global mise configuration.

## Selection cues

Treat these as cues, not a closed catalog. Inspect the actual project before
selecting tools.

- **Python:** Declare Python and uv in repository-local mise. Keep application
  and development dependencies in `pyproject.toml`, commit `uv.lock`, and use
  locked `uv run` invocations in checks. For a new project, use Ruff for linting
  and formatting, pytest for tests, and consider ty for type checking after
  confirming project compatibility. Preserve an established mypy or Pyright
  setup instead of running redundant type checkers. Keep Ruff, pytest, and ty in
  the project's development dependency group rather than also declaring them in
  mise.
- **Go:** Declare Go at a version compatible with `go.mod`, its `toolchain`
  directive, and CI. Use runtime-provided checks such as `gofmt`, `go vet`, and
  `go test`; consider repository-local golangci-lint for broader linting and
  govulncheck for reachable dependency vulnerabilities. Manage each external
  binary consistently through repository-local mise or Go's tool dependency
  mechanism, while Go modules remain in `go.mod` and `go.sum`. For a Go-only
  vulnerability check, prefer govulncheck over a second generic scanner.
- **JavaScript/TypeScript with Bun:** Declare Bun in repository-local mise, keep
  an exact compatible `packageManager` value in `package.json`, and commit the
  Bun lockfile. Put Biome, TypeScript, Vite, Vitest, Knip, and similar JS tools in
  `devDependencies` with package scripts as their stable entry points. Use a
  no-emit TypeScript check, a non-watch Vitest CI task, and Knip for unused files,
  exports, and dependencies in a non-trivial application or package. Add Vite
  when the frontend or library build calls for it, and configure Knip from the
  project's real framework entry points; JS/TS utility scripts alone imply
  neither tool.
- **Shell:** Use ShellCheck for supported shell dialects and shfmt for POSIX
  shell, Bash, or mksh. Keep check mode non-writing and expose formatting
  separately. Validate Zsh with Zsh-aware tooling such as `zsh -n`.
- **GitHub Actions:** Use actionlint for workflow correctness and keep
  ShellCheck on the same mise-provided `PATH` so eligible `run:` scripts are
  checked. Add repository-local zizmor when GitHub Actions security is in scope;
  it complements rather than replaces actionlint.
- **Containers:** Use Hadolint when the repository owns Dockerfiles, passing all
  owned Dockerfile paths and keeping any ignores narrow and explained.
- **Dependency vulnerabilities:** Consider repository-local OSV-Scanner for a
  polyglot repository, multiple lockfile ecosystems, or container scanning. Run
  it alongside an ecosystem-specific scanner such as govulncheck only when their
  scopes are deliberately complementary.
- **Secrets:** A Git repository needs an explicit secret-scanning decision. For
  new setup, consider Betterleaks with a redacted working-tree check. Keep an
  established Gitleaks or equivalent scanner unless migration is requested.
  History scans are explicit audit tasks, and live credential validation is
  enabled only when specifically requested.

Also consider tools implied by schemas, generated code, infrastructure,
documentation, dependency policy, licenses, and supply-chain requirements. Add
them from repository evidence rather than accumulating a universal checklist.

## Integration checks

- Confirm mise resolves its local configuration and reports no missing runtime
  or standalone tool versions.
- Confirm each ecosystem install succeeds from its committed manifest and
  lockfile without silently rewriting either.
- Run the read-only aggregate check, then inspect the diff for rewritten files
  or untracked generated artifacts.
- Validate task and CI syntax with the configured tools themselves.
- Keep secrets out of logs and summaries; report locations and rule identifiers,
  not raw findings.
- Report the inventory by ownership layer, version policy, command entry points,
  applicability decisions, and any remaining findings.
