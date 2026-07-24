# LaTeX devcontainer

A [devcontainer](https://containers.dev/) for LaTeX based on the [TeX Live 2025](https://www.tug.org/texlive/) distribution.

The image is built on top of [`islandoftex/images/texlive:TL2025-historic`](https://gitlab.com/islandoftex/images/texlive)
and pins `tlmgr` to the frozen TeX Live 2025 mirror so package installs stay reproducible over time.

## Usage

Add the container to your project by placing a `.devcontainer/devcontainer.json`
that references the published image:

```json
{
  "name": "LaTeX",
  "image": "ghcr.io/benni-tec/devcontainers-latex:main"
}
```

Or simply copy the [`devcontainer.json`](./devcontainer.json) from this folder, which additionally sets up the editor integrations below.

## Editor Integration

- **Visual Studio Code**: installs the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension 
  and preconfigures **LuaLaTeX** as the default compiler. 
  
  Three recipes are available:
  - `lualatex` — a single LuaLaTeX pass (default).
  - `lualatex ➞ biber ➞ lualatex x2` — full build with bibliography.
  - `biber` — run Biber on its own.
- **JetBrains** IDEs — installs the [Texify](https://plugins.jetbrains.com/plugin/9473-texify-idea) plugin.

## Package requirements (`requirements.tex.txt`)

Rather than baking a fixed set of packages into the image, this container installs
the TeX Live packages your project needs on demand from a plain-text requirements file. 
This keeps the image small and lets each project declare exactly the packages it depends on.

### How it works

On container creation the `postCreateCommand` runs:

```
tlmgr update --self && /usr/local/bin/setup_tlmgr.sh && texhash
```

The [`setup_tlmgr.sh`](./setup_tlmgr.sh) script:

1. Reads the requirements file (by default `requirements.tex.txt` in the working
   directory).
2. Fetches the list of already-installed packages once.
3. For each package listed in the file, installs it with `tlmgr install` — unless
   it is already present, in which case it is skipped.
4. Runs `tlmgr path add` so the newly installed binaries are on the `PATH`.

### The requirements file

Create a `requirements.tex.txt` in your project and list one TeX Live package
name per line. The names are the `tlmgr` package names (which usually, but not
always, match the LaTeX package you `\usepackage`). Blank lines and extra
whitespace are fine. For example:

```
booktabs
siunitx
biblatex
algorithms
algorithmicx
```

You can find the correct package name via
[CTAN](https://ctan.org/) or with `tlmgr search --global --file <file>`.

### Overriding the file location (`TEX_REQUIREMENTS`)

The path to the requirements file is controlled by the `TEX_REQUIREMENTS`
environment variable and defaults to `requirements.tex.txt`. Set it to point the
script at a different file — for example when the file lives in a subdirectory or
uses a different name:

```jsonc
// devcontainer.json
{
  "containerEnv": {
    "TEX_REQUIREMENTS": "tex/packages.txt"
  }
}
```

You can also override it ad-hoc when invoking the script manually:

```bash
TEX_REQUIREMENTS=other-requirements.txt /usr/local/bin/setup_tlmgr.sh
```

## Building the image

The image is built from the [`Dockerfile`](./Dockerfile) in this folder and
published to `ghcr.io/benni-tec/devcontainers-latex`. To build it locally:

```bash
docker build -t devcontainers-latex ./latex
```
