# code from https://github.com/JuliaGraphics/FreeType.jl/tree/master/gen

using Clang.Generators

# https://github.com/EsotericSoftware/spine-runtimes/releases

const SPINE_VERSION = v"3.8.95"
const spine_runtimes_dir = normpath(@__DIR__, "spine-runtimes-$SPINE_VERSION")
!isdir(spine_runtimes_dir) && throw(string("need ", spine_runtimes_dir))
const spine_include_dir = normpath(spine_runtimes_dir, "spine-c/spine-c/include")
const spine_include_spine_dir = normpath(spine_include_dir, "spine")
((root, dirs, files),) = walkdir(spine_include_spine_dir)
const spine_headers = normpath.(root, filter(x -> endswith(x, ".h"), files))

const headers = spine_headers
const args = vcat(get_default_args(), "-I$spine_include_dir")
const options = load_options(joinpath(@__DIR__, "generator.toml"))

ctx = create_context(headers, args, options)

build!(ctx)
