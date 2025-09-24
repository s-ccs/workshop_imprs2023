```bash
julia -e 'using Pkg;Pkg.add(["WGLMakie","PlutoUI","PlutoTeachingTools","PackageCompiler"]);using PackageCompiler; create_sysimage([:WGLMakie,:PlutoUI,:PlutoTeachingTools],sysimage_path="/home/plutoserver/workshop_imprs2023/jl_image")'

julia -J jl_image
```
```julia
using Pluto
Pluto.run(host="0.0.0.0",sysimage="jl_image",require_secret_for_open_links=false,require_secret_for_Access=false,warn_about_untrusted_code=false)
```
