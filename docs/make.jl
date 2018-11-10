using Documenter
using SVDD

makedocs(
    sitename = "SVDD Documentation",
    pages = [
        "Home" => "index.md",
        "Getting Started" => "start.md",
            "Overview" => "index.md",
            "Custom Solvers" => [
                "SMO" => "smo.md"
                ]
        ],
    format = :html,
    modules = [SVDD]
)
# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
