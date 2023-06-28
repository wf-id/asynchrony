using Documenter, DocumenterTools
using asynchrony

#cp("./docs/Manifest.toml", "./docs/src/assets/Manifest.toml", force = true)
#cp("./docs/Project.toml", "./docs/src/assets/Project.toml", force = true)


makedocs(
    sitename = "asynchrony.jl",
    format = Documenter.HTML(),
    modules = [asynchrony],
    authors="Michael E. DeWitt <me.dewitt.jr@gmail.com>", "Nicholas Kortessis",
    pages = [
        "Introduction" => "index.md"
        ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "https://github.com/wf-id/asynchrony.git",
    target = "build", push_preview = false
)