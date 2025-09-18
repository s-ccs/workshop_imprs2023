### A Pluto.jl notebook ###
# v0.20.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 67cfabae-21f8-11ee-02b9-c9695caf0b6d
begin 
	using PlutoUI
	#using PlutoReport
	using PlutoTeachingTools
	using HTTP
end

# ╔═╡ c963e92f-9116-4ff8-a874-e3e25340e4ae
begin
	using OrdinaryDiffEq
	import Unitful: N,m,kg,s,  ustrip
	using Measurements
end

# ╔═╡ ee02c371-757e-4853-9a93-bc67672c52b5
using DataFrames,DataFramesMeta

# ╔═╡ 1fc7fea6-66d0-480b-adc8-b7f5e360316c
let
	using WGLMakie
m = 200
function spiral(; a = 1, n = 100, h = 0, k = 0)
    φ = LinRange(rand() + 1, 6π, n)
    h .+ rand(-1:2:1) * a * cos.(φ) ./ φ, k .+ rand(-1:2:1) * a * sin.(φ) ./ φ
end

curves = [spiral(; a = rand(), h = rand(-1:1)) for i in 1:m]

with_theme(theme_minimal()) do
    fig = Figure(size = (600, 400))
    ax = Axis(fig[1, 1])
    series!(curves; color = categorical_colors(:inferno, m), linewidth = 1.5)

    hidedecorations!(ax; grid = false)
    fig
end
end

# ╔═╡ 3d2560db-08dc-4c76-aa34-16cec017e05a
using Distributed

# ╔═╡ 356ddcab-61da-4af7-a327-331d978fac81
@everywhere using Random

# ╔═╡ d340101a-d932-4035-baf1-ee772e9bf25d
	using MLJ, DecisionTree,MLJDecisionTreeInterface

# ╔═╡ e539b501-d588-4d46-ba13-38d5e04b7529
let
	using DifferentiationInterface
	import ForwardDiff: ForwardDiff
	
	
	f(x) = sin(x^2)
	ḟ(x) = 2*x*cos(x^2)
	
	xs = range(0,3,length=100)
	lines( xs, f.(xs))
	lines!(xs, ḟ.(xs),linewidth=10) # derivative

	lines!(xs,gradient(f,AutoForwardDiff(),xs),linewidth=3)
	current_figure()
end

# ╔═╡ 296e8d4e-2441-4133-936d-dba7f9b80147
using Turing

# ╔═╡ ecbed7fa-c00f-4cf6-b3b6-ea1057fed55d
using Test

# ╔═╡ c7cf4ce5-eaad-472c-876e-2b797c461a7f
using Chairmarks

# ╔═╡ 565a9f1f-2be7-4585-95f7-1e3fb61b6f23
ChooseDisplayMode()

# ╔═╡ baf7466d-23be-4a3c-aa05-a68af5a4abdb
TableOfContents()

# ╔═╡ 5043fd74-c556-40ed-a4f7-41a8a0baf963
md"""
[workshop.s-ccs.de](workshop.s-ccs.de)
"""

# ╔═╡ cc231b54-f34c-4349-b5de-479b60778bfc
md"""
# An interactive introduction to JuliaLang - A programming language for scientists

**Benedikt Ehinger, Computational Cognitive Science - University of Stuttgart**

[www.s-ccs.de](www.s-ccs.de)

"""

# ╔═╡ 8228c2d3-abd3-4e2d-824b-860f73c9f50f
md"""
# Common programming languages in Science

| | First Release | Release 1.0 | Free? | Open? |
|---|----|---|---|---|
| Matlab | 1979 | 1984 | ❌ | ❌ | 
| Python | 1991 | 1994 | ✔ | ✔ | 
| R | 1995 |2000 | ✔ | ✔ | 
| **Julia** | 2012 | 2018 |✔ | ✔ | 

"""

# ╔═╡ b1947a54-cf7c-474a-8330-a35ad6a6df47
md"""
## Why Julia?
- free
- pretty new, no "baggage"
- many science-must-haves as first-seat passengers:
  - "numpy-included"
  - package/dependecy manager
  - fast code (also for non-computer scientists)
  - parallelization without (ok, little) frustration
- interoperable - just call python/R if you need
- Pluto.jl ☄
	 
"""

# ╔═╡ 56fc2f2d-e1d8-424c-a256-4b7b282dcf69
md"""
## The two language problem in science

![](https://juliadatascience.io/images/language_comparisons.png)
If you want clarity, you use python/R - if you want speed, you use C++/Fortran.
"""

# ╔═╡ dd2816bc-230e-4c55-8903-5b817a0ea6d7
md"""
---
![](https://pbs.twimg.com/media/Fg-qasAUAAEZYQk?format=jpg&name=small)
As a result, numpy is 35% C, pytorch is 43% C++, and even in R, e.g. magritrr is 40% c++.

!!! important
	  You have to be an **expert** in **at least two** languages to develop or maintain!

!!! hint
	  or you learn julia 😉
"""

# ╔═╡ c5855931-4fe4-40bf-83c9-b100bc7f5900
begin
md"""

## Historic baggage:
Matlab: 
- PATH, 
- .+ / + inconsistencies
- vectors are n x 1 matrices
- deprecated functions strfind & findstr
- dependent on constly toolboxes

Python:
- package management via environmental variables (thus pip/conda etc emerged)
- importing same function name silently "just works"


R:
- package managing practically non-existant 
- CRAN is frustrating for publishing

JuliaLang has little historic baggage!
"""
end;

# ╔═╡ d70cdceb-679b-4a92-b5c1-814d3a66b1b9
md"""
# A taster of cool features & packages
"""

# ╔═╡ bbf8da5b-4974-4d78-a849-ad6afb28435c
import Unitful: MΩ, ms, mV, nA,mA # Import from package

# ╔═╡ a4b978d6-d395-4e49-8adf-578efab2a9d0
"""
Simulate a simple leaky-integrate-and-fire (LIF) neuron, given
input current `I` and a timestep `Δt`.
Return when the neuron fires its first spike.
The neuron’s input resistance `R` and time constant `τ` can be
customized by keyword argument.
"""
function first_spike(I, Δt; R = 100MΩ, τ = 20ms)
	N = length(I) # Number of samples
	v = -70mV # Resting membrane potential
	for i in 1:N
		dv = -v + R*I[i] # Leaky current integration
		v += dv/τ * Δt # Euler integration of ODE
		if v > -55mV # Spike!
			return time = i * Δt
		end
	end
	return nothing # Never spiked
end


# ╔═╡ 31c21f8e-09c7-4eaa-b5f6-fc2046f77b0a
first_spike(repeat([-0.5nA],500),1ms)

# ╔═╡ a3916666-7788-4716-8d6f-3ea75d9c6ad1
md"""
## Combining unrelated packages
"""

# ╔═╡ 4399b11b-6814-4899-8f6a-12fd9549e3cf
md"""
Let's simulate a simple pendulum and use some packages, that actually know **nothing** about eachother
"""

# ╔═╡ a8575e86-a5f8-4743-bb15-1166a236431a
begin
gaccel = (9.79 ± 0.02)N*(m^2/kg^2)  # Gravitational constants
L 	   = (1.00 ± 0.01)m 			# Length of the pendulum

#Initial Conditions
u₀ = [(0 ± 0), (π / 3 ± 0.02)] 		# Initial speed and initial angle
tspan = (0.0s, 10.0s)

function simplependulum(du,u,p,t)
    du[1] = u[2]/s
	du[2] = -(1kg*gaccel/L) * sin(u[1])s/m^2
end

prob = ODEProblem(simplependulum, u₀, tspan)
sol = solve(prob, Tsit5(), reltol = 1e-6) |> DataFrame;
first(sol,2)
end

# ╔═╡ ff9c0134-2139-4ee6-b81e-5a4b34484619
let
	# Linear errorpropagation
	t = ustrip.(sol.timestamp) # remove unit information
	y = Measurements.value.(sol.value1) #grab the values
	er = Measurements.uncertainty.(sol.value1) # grab the uncertainty
	scatter(t,y)
	errorbars!(t,y,er)
	current_figure()
end

# ╔═╡ 18e627c6-3dca-4d6d-a825-5884c5541ffb
md"""
## A quick showcase of Pluto
Pluto is a reactive notebook - any change in one cell automatically updates all other depending cells
"""

# ╔═╡ 57e70c41-2f0d-45a4-8db4-4575e396614b
a = 100

# ╔═╡ 3435f07d-89b0-4f9b-b08f-2443d72c3ac6
b = a * 2

# ╔═╡ 55aa1f3b-cf36-4bc7-9c58-7cf45feafb47
md"""
## Gimmicky example:
"""

# ╔═╡ 64af498f-cad1-4500-8ea5-e3b3bfdc1d86
moonphases = collect('🌑':'🌘')

# ╔═╡ 2932fad6-78e0-4e57-b9be-b0e795f26c2a
#@bind clock PlutoUI.Slider(1:length(moonphases),show_value=true)
@bind clock PlutoUI.Clock(;
		start_running=false,
		interval=0.5,
		repeat=true,
		max_value=length(moonphases))

# ╔═╡ 37055a8d-6812-4b5d-a22a-e8d913df9c74
clock

# ╔═╡ e6cb58ee-6a3b-48de-9a0f-7bc09cc2c3ee
@htl """<span style="font-size: 10rem;">$(moonphases[clock])</span>"""

# ╔═╡ ebcc8d82-3448-4e6d-9a05-f3393f2b8127
md"""
# Now it's your turn!
Go to: [workshop.s-ccs.de](https://workshop.s-ccs.de) - it will take ~30 seconds to start up.

And get started with **Task 1** & **Task 2**
"""

# ╔═╡ 765ce44e-73ed-484e-81f2-c68c23090372
md"""
# A tour through Julias syntax


#### Syntax
Syntax generally looks like a mix of MatLab, Python & R.

It has some nice benefits, as being **very explicit** when what happens, e.g. element-wise operations are used or inplace operations (side-effects) happen
"""

# ╔═╡ 6a157ab7-d741-45c9-b9fa-d7a7f409c6f5
begin
	
myarray = Int[]
for k = 1:10
	if k > 5
		k = -k
	else
		k = k * 2
	end
	append!(myarray,k)
end

end

# ╔═╡ 06c74bfb-a643-4550-8d9a-a8edeac37cd7
myarray

# ╔═╡ f7427228-0848-49cb-b024-96d225602583
[print(k) for k in '🌑':'🌕'] # python-style list/array comprehensions;

# ╔═╡ f1f2be71-a396-40fc-9bfa-b9c63afa07f5
md"""
#
#### Syntax II
Introducing splatting `...` and the `.` operator and the `!` convention
"""

# ╔═╡ b25630ca-ca7b-4d8d-ba70-44f6c04a7787
md"""
###### Elementwise operators
`myarray - 5` vs. `myarray .- 5`
"""

# ╔═╡ 2c8a7b9b-6b02-4ea2-a909-1cf8e9f31c04
myarray

# ╔═╡ 8223012d-f71e-407d-b8fd-465ad1825f6f
typeof(myarray)

# ╔═╡ 24bcdd0b-7cee-4613-a70f-fdc11d3d7c4f
myarray .- 5

# ╔═╡ 7df74cd0-89e8-4452-9a58-3e4b3c51db2f
md"""
###### Ranges, operators and splatting
"""

# ╔═╡ 8e3b1614-e430-4876-9887-0cfab25e6e66
#[50,1:4]

# ╔═╡ f87fbe41-a249-4ab0-b777-f83e18490f4b
#[50,(1:4)...]

# ╔═╡ b0fa75ce-37ef-45b2-be50-0a2b596a85ec
md"""
`!` means inplace, e.g. sort! - saves RAM!
"""

# ╔═╡ 9e5b4fdd-9695-4ec5-960b-2e66a788303a
let
a = [3,2,1,199,50]
b = [3,2,1,199,50]

sort(a)
println("non-inplace: ",a)
	
sort!(b)
println("inplace:     ", b)
end

# ╔═╡ 544f893e-9780-41d2-b749-4f1cb7b6ede5
md"""
#
#### Syntax 3
Unicode α,β,γ,←,iᵢⁱ can be used as variable names

How to: `\alpha` + `TAB` => `α`
"""

# ╔═╡ 3cfac7c5-4bab-4844-8a42-be8e0326d79c


# ╔═╡ bbc8fbb4-b29f-49c6-a285-6323c489170d
α = π/2

# ╔═╡ 3d099d83-43b5-417b-a01f-4dea93cd2390
β = 2 + α + √4

# ╔═╡ d5caafd7-231e-4785-98b9-87d48bda363a
md"""
# Reproducibility
Reproducibility: Run the same code again years later -> same results

One part: How to make sure same package-versions are used? => Python environments, `conda.yml`, `requirements.txt` etc.

Inbuilt solution in Julia: `Project.toml` and `Manifest.toml`

**📄Project.toml**
```
[deps]
PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
```
=> keeps track of user-added dependencies

**📄Manifest.toml**
```

julia_version = "1.9.2"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.BibInternal]]
git-tree-sha1 = "3a760b38ba8da19e64d29244f06104823ff26f25"
uuid = "2027ae74-3657-4b95-ae00-e2f7d55c3e64"
version = "0.3.4"

[...]
```
keeps track of all versions of all dependencies, and dependencies of dependencies

"""

# ╔═╡ 2bcc5531-cb51-4792-81d0-cc412baa7cd2
md"""
## Reproducible Notebooks in Pluto
- Pluto.jl is a reactive notebook
- It is a plain text-file, cannot save outputs (only as html/pdf)
- Project.toml + Manifest.toml inside the `myNotebook.jl`
- Collaborate on the `.jl` or upload it to github + raw.github => versioning included!
"""

# ╔═╡ 9e5935cf-920a-4726-b9a9-48f5c6b9b79c
md"""
**TLDR;** Give me your `Manifest.toml` and I can `instantiate` your exact state!
"""

# ╔═╡ 2d14b423-38d1-424f-85a9-8382708b5703
md"""
# Package showcase
"""

# ╔═╡ c8a14db6-cfe3-4a03-b952-ff098bd9c1be
md"""
## DataFrames.jl

Similar functionalities as in `Pandas` or `Tables` or `tibbles`. 

Nice bonus: Julia has a `missing` type (in addition to `NaN`)
"""


# ╔═╡ d50ef3bb-94ad-49f3-8901-4c03973a9d67
begin
df = DataFrame(A=[true, false, true,false], B=[1, 2, 3,4],
              C=[missing, "a", "b","b"], D=['a', 'b', 'c','d'])
end

# ╔═╡ 2f55eedc-8cbc-44da-a94e-e1ffe744592c
md"""
`tidyverse`-like chainning is possible too 

"""

# ╔═╡ 359de646-1616-4627-9fe1-026cbf2f1b76
@chain df begin
	dropmissing
	@by(:C, :result = sum(:B))
	
end

# ╔═╡ bb892363-8e90-46c2-a67c-e6a47ffb9d1c
md"""
Also checkout `Tidier.jl` for a 1:1 clone of the Tidyverse, including ggplot!
"""

# ╔═╡ bb52ed90-afbb-4fd0-9ead-aeabd421dc9b
md"""
## Makie.jl
Plotting library with 4 backends:
- **CairoMakie**: Vector Graphics / SVG, Publication Ready
- **GLMakie**: GPU-based backend, 3D-graphics, super fast - play minecraft with it using Miner.jl
- **WGLMakie**: Same as before, but in the browser!
- **RPRMakie**: Raytracing-backend, looks like blender - very experimental

E.g. here are plottet 60.000k datapoints
"""

# ╔═╡ 3c4090ff-6578-48d8-ab58-3036289a1f4d
scatter(rand(Point3f,100_000))

# ╔═╡ c749e920-35de-4a1d-84cb-88aceb215b33


# ╔═╡ 98b14086-bc8c-4725-bf46-8e09f698c2f0
md"""
### Layouting in Makie
Layouting multiple subplots in Makie is really nice. Some (random) features I like:
- no need to prespecify how many subplots you will have
- dynamic subplots: `f[2,3][1,2]` puts a subplot in the right half of the `2,3` subplot 
- you can choose where the plots should align (x-label bottom? plot bottom?)
- you can add small labels (e.g. **A**,**B**,**C**)
- you can use $\LaTeX$ wherever you want, 
- adjust plots after the fact
"""

# ╔═╡ 31ae04fd-ed82-43bb-b16b-9eb8064060aa
let
# new figure
f = Figure(size = (600, 400))

# 3 subplots
axright = f[2,2] = Axis(f)
axtop = f[1,1] = Axis(f)
axmain = f[2,1] = Axis(f)

# link the axes
linkyaxes!(axmain, axright)
linkxaxes!(axmain, axtop)

# generate some random data
labels = ["A",L"\frac{B}{C}","D"]
data = randn(3, 100, 2) .+ [1, 3, 5]

# plot the data in the respective axes
for (label, col) in zip(labels, eachslice(data, dims = 1))
    scatter!(axmain, col, label = label)
    density!(axtop, col[:, 1])
    density!(axright, col[:, 2], direction = :y)
end

# add a legend in the last remaining spot
l = Legend(f[1,2],axmain,tellwidth=false,tellheight=false,halign=:left)

# resize columns and rows as you like
colsize!(f.layout, 2, Auto(0.3))
rowsize!(f.layout, 1, Auto(0.5))

# make the gap a little bit smaller
rowgap!(f.layout, 10)
colgap!(f.layout, 10)

# add the small "A","B","C" labels to the respective plots
for (label, layout) in zip(["A", "B", "C"], [f[1,1],f[2,1],f[2,2]])
    Label(layout[1, 1, TopLeft()], label,
        fontsize = 20,
        font = :bold,
        padding = (0, 5, 5, 0),
        halign = :right)
end
f
end

# ╔═╡ a8210381-8b08-456e-aadc-34c0dde1e693
md"""
## Parallelization
1. Tasks
2. Threads (shared memory)
3. Distributed.jl (own worker-processes)
4. GPU (CUDA.jl)
"""

# ╔═╡ 89a8b900-98aa-4214-8b83-9c5cb6d12110
md"""
### 1. Tasks
- Lightweight, I/O, event handling, 
- Communication via `Channels` possible
- `wait`/`fetch`
- Multi-Thread possible
"""

# ╔═╡ c28f5865-7e3c-4d19-83f9-ce85b0e1fefe
let
taskstatus = "💤"
t = @task begin
	sleep(2); taskstatus = "Done 🎉!";
end
schedule(t) # start the task
	
println("Let's do something in between (Task: $taskstatus)")
sleep(1)
println("Puh.. that tasks takes ages... is it ready? (Task: $taskstatus)")
sleep(1)
println("Now Done? (Task: $taskstatus)")
	
end

# ╔═╡ 110d3a52-bd9a-47f3-8246-064ab1a15bfd
md"""
## 2. Threads
- Multi-CPU/Thread
- Shared memory
"""


# ╔═╡ 46b4ab6f-f88c-4c4f-8127-d1526f01b559
let
a = fill(0,10)
Threads.@threads for i = 1:10
		   a[i] = Threads.threadid()
end
a
end

# ╔═╡ 777cc42b-aa3c-4c07-a0b6-b33d265f7c98
md"""
## 
"""

# ╔═╡ 3ea35338-0f95-4f9e-9daf-f7db5e7bad4d
nTimes = 100

# ╔═╡ 6f3b2def-2058-4ad7-ae04-5f02f3373a63
πapprox(n) = sum([((rand()^2 + rand()^2) ≤ 1 ? 1 : 0) for k in range(1,n)])*4/n

# ╔═╡ 05ca9a83-a2db-4cbe-9c50-f29fdbd458d0
begin

	function calc_π_parallel(repeats,n)
		a = fill(0.,repeats)
	    Threads.@threads for i in 1:repeats
			a[i] = πapprox(n)
		end
		return mean(a)
	end
	
	function calc_π_serial(repeats,n)
		a = fill(0.,repeats)
		for i in 1:repeats
			a[i] = πapprox(n)
		end
		return mean(a)
	end
end

# ╔═╡ 595944a9-152a-4877-ad74-a75cbdfe7e9f
@time calc_π_serial(20, nTimes)

# ╔═╡ 785678a8-6590-43fd-bb32-d8f10859f48f
@time calc_π_parallel(20, nTimes)

# ╔═╡ cb3738f3-a46b-4533-9a58-d35b97012794
md"""
## 3. Distributed.jl
- Each **process** has its own memory
- workers could be on different machines
```
                         ┌─────────────┐
                    ┌────► myid() == 2 │
                    │    └─────────────┘
 ┌─────────────┐    │
 │ julia -p 3  │    │    ┌─────────────┐
 │             ├────┼────► myid() == 3 │
 │ myid() == 1 │    │    └─────────────┘
 └─────────────┘    │
                    │    ┌─────────────┐
                    └────► myid() == 4 │
                         └─────────────┘
```
"""


# ╔═╡ d3b87e35-a240-4ca7-b293-da3ac50424fa
Distributed.nworkers()

# ╔═╡ a48f1985-2eff-4562-9b03-ba6843197e35
Distributed.addprocs(2)

# ╔═╡ 20437c9a-e06d-47c2-9f44-1bbcc6fdbe07
@fetch(rand(myid()))

# ╔═╡ a1a03aa1-1e83-4ccc-aff0-45e34b89fd3a
pmap(x->myid(),1:10)

# ╔═╡ 10914eda-284f-4d0f-8c9b-c2b65fd2f76d
@distributed vcat for k = 1:10
	sum(a)+myid()
end

# ╔═╡ 545fcee8-d741-41ea-a14a-2e334427fa82
md"""
## Julia GPU
![](https://juliagpu.org/assets/logo_crop.png)
- CUDA.jl
- oneApi.jl
- AMDGPU.jl
- Metal.jl (Apple)

Can't showcase within Pluto right now!
"""

# ╔═╡ 5ec7d837-3729-449b-9477-7b30c981d730
md"""
```julia
A = CuArray(rand(100,100))
b = CuVector(rand(100))
C = A*b # let's goooo!
```

**Note:** Copying from/to GPU is costly, best to stay on the GPU if possible. I made 30x speed improvements in the past!
"""

# ╔═╡ f0b9c97d-31ce-4016-90e3-c5c30116d4b6
md"""
# Machine Learning & Stats
For DeepLearning there are multiple packages, e.g. Flux.jl or Lux.jl, with an assortment of AutoDiff packages - but these examples are typically more involved, and I'm not too much into deeplearning.

Generally people like the modularity, ease-of-use, and explicit parameterization, but the team of 100 engineers at pytorch have the edge on speed.
"""

# ╔═╡ bea306d3-ccd5-48da-a299-3bc247d6b16a
md"""
## MLJ.jl
A scikit-learn replacement
"""

# ╔═╡ 1c250ad7-d21f-4d49-929a-e900ba8c9e48
begin 
	DecisionTreeClassifier = @load DecisionTreeClassifier pkg=DecisionTree verbosity=0
	
	y, X = unpack(MLJ.load_iris(), ==(:target), colname -> true); 
		
	mach = machine(DecisionTreeClassifier(), X, y)
	
	evaluate!(mach, resampling=Holdout(fraction_train=0.7),
		    measures=[log_loss, brier_score])
     
	
end

# ╔═╡ 461440fc-91a5-449d-b887-a477caecf1dc
	fitted_params(mach).tree

# ╔═╡ 2ba9129b-dcf4-478c-be28-b74ccb1ecffc
md"""
## Auto-Diff
"""

# ╔═╡ 0728883f-69b4-4cf7-ae6d-fde7ec7bd18d
md"""
![](https://gdalle.github.io/JuliaCon2024-AutoDiff/img/python_julia_user.png)
"""

# ╔═╡ 54b8147e-355b-46da-929a-0ac8b1979d68
md"""
## Bayesian data analysis with Turing.jl
Also supports autodiff, thus you can introduce **weird** models and functions!
"""

# ╔═╡ fed19876-0b3a-48d4-8152-0ff6e3224b4e
begin 
	
	#myTruncateFunction(μ) = μ>0 ? Inf : μ # truncate possible μ at 0
	@model function gdemo(y)
	# priors
    σ ~ InverseGamma(2, 3)
    μ ~ Normal(0, σ)
		
	for n in eachindex(y)
		y[n] ~ Normal(μ,σ)
		#y[n] ~ Normal(myTruncateFunction(μ),σ)
	end
end
end

# ╔═╡ 44f3069f-c051-4d76-af7e-09e48a31a5a8
aside(tip(md"**myTruncateFunction**: just for demo - better to use the `Truncated` function from Turing.jl"),v_offset=-300)

# ╔═╡ d9881c88-93ca-47de-9b40-6880046fa720
begin
	# we don't fit the model to data, but just sample from it
	init_model = gdemo([1.5, 1.0, 2])
	chn = sample(init_model, NUTS(), 1000);
end;

# ╔═╡ 9e0675fd-a898-4c3f-9a11-3774329983ae
hist(DataFrame(chn)[:,"μ"],bins=100)

# ╔═╡ ced9f6e7-6bf9-4448-981d-24613279a5ec
md"""
# What I don't like about julia
"""

# ╔═╡ 812adc60-3c95-4547-b7c1-644acd97e8a6
md"""
## Startup & Time to first X
Julia is slow in three cases

1. install a new package: needs clone + precompilation
2. loading a package: needs to precompile 
3. using a function for the first time: Needs to find out what functions to use for the given `::types`

(3 implies that julia is relatively slow the first time it does anything. "luckily" we typically have to do 99% things more than once)

![https://www.youtube.com/watch?v=jFhL8EVrz7s](https://i.imgur.com/vgzuygC.png)
[State of Julia 2023](https://www.youtube.com/watch?v=jFhL8EVrz7s)
"""

# ╔═╡ f5ab2a8c-f6ef-41c3-b76a-2fafecc8ec83
md"""
# Things I like, things I don't like

|➕ | ➖ |
|:---|---|
|🚀 Speed of calculation |  Installation time 🐌|
|🔤 Explicit syntax | Time-to-first-X (but getting there) 🐌|
|📦 PackageManager ♥ | No concept of traits/interfaces, makes inheritance hard|
|👨‍👨‍👦‍👦 Community is very helpful  | Ecosystem is small (but sufficient imho)🌏|
|🧮 LinAlg/numpy included    |  No Julia emoji yet|
|$$\LaTeX$$; `\beta = β`    |  |
|Developing, testing, documenting packages is easy / good workflows    |  |
|💸 Free    |  |
|📈 Growing users and interactions    |  |
|🐍 Interoperability with Python/R is solid  |  |
|🎉 Surprisingly fun!  | |

"""

# ╔═╡ 1e9d739b-0a95-49e6-a489-4f2730799a5e
md"""
# Someone mentioned Julia is supposed to be fast?
Let's compare `linear search`!

is `3` included in `[5,2,5,1,2,3,7,5]`?

| |naive | native |
|---|---|:---|
| R | for-loop | `in`|
| Python | for-loop | `in`|
| Julia | for-loop | `∈`  (or `in` 😉) ||

[source of functions](https://towardsdatascience.com/r-vs-python-vs-julia-90456a2bcbab)
"""

# ╔═╡ 5706cf61-07da-460b-92af-a5d0e30ae67a
# ╠═╡ show_logs = false
begin
	#using PythonCall
	#using RCall
end

# ╔═╡ 83e0de6d-948f-49a9-b027-1a11faf63e6e
vec = collect(range(1,1_000_000));

# ╔═╡ 3cb07396-07be-404f-a09a-4de20a43af05
 x = 20_000_000; # well outside :-(

# ╔═╡ feb1b91a-dcbb-458d-aa0e-58a21a926ad0
md"""
## Compare with R
"""

# ╔═╡ 7953f1cd-ee07-4013-8428-7f122e6e8b84
begin # fancy way to move variables between R & Julia @rget + @rput
	@rput x
	@rput vec
end;

# ╔═╡ 51b2a265-a432-4ccb-8ecb-742737385dbd
md"""
### R naive
with for-loops (we know this is bad)
"""

# ╔═╡ dd3d1812-0057-4407-9121-69925c3770df
nai_R = @b R"""
	for_search <- function(vec, x) {
	  for (i in 1:length(vec))
	    if (vec[i] == x)
	      return (TRUE)
	  FALSE
	}
	for_search(vec,x)
  """

# ╔═╡ 668347ff-0585-4169-8aab-94ee771a55ba
md"""
### R inbuilt
"""

# ╔═╡ 1fca0668-c559-40d5-8345-7939a0dee9f2
nat_R = @b R"x %in% vec"

# ╔═╡ b2b5a4e5-380b-400f-bfff-9384cf6ec429
md"""
## Compare with Python
### Python naive
with for-loops (we know this is bad)
"""

# ╔═╡ b0be8b8a-db04-4765-af15-ca240987dc0e
nai_py = @b pyexec(Nothing,"""
def for_search(vec, x):
    for i in range(len(vec)):
        if vec[i] == x:
            return True
    return False
for_search(vec,x)
""",Main,(vec=vec,x=x)
)

# ╔═╡ 87745186-2f63-45ef-91e2-b6d757688948
md"""
### Python inbuilt
"""

# ╔═╡ 3f7d1bbd-fa2f-46e3-a535-8a46a068882a
nat_py = @b pyexec(@NamedTuple{answer::Bool},"""
answer = x in vec
""",Main,(vec=vec,x=x)
)

# ╔═╡ 4caaf820-b27d-4944-907d-76517c5afc23
md"""
## Compare with Julia
### Julia naive
"""

# ╔═╡ b591ff2a-0e48-4a05-997e-56ec4a3b09b4
function myfun(vec, x)
	@simd for i in 1:length(vec)
	  if vec[i] == x
	      return true
	  end
  end
  return false
end

# ╔═╡ d498a775-3c0c-49fe-8078-d4e00d97e142
nai_jl = @b myfun(vec,x)

# ╔═╡ 014cec12-8e87-4ff1-a5a0-d25acc58bd4b
md"""
### Julia inbuilt
"""

# ╔═╡ 6efc1438-c7af-4845-a4e8-493224d8c984
nat_jl = @b x ∈ vec

# ╔═╡ cb4c24b0-245c-4aed-b34c-123234b45926
PlutoTeachingTools.tip(md"The point is not that Julia is always faster - it is that it is easier to write fast code!")

# ╔═╡ 20dccd48-9fc2-47b2-98f2-26c1821931d8
import Unitful: µs

# ╔═╡ 57f343a6-9373-4cc4-abd0-fa8859d20c29
md"""

|  | naive | inbuilt |
|---|---|---|
|R | $(round(µs,nai_R.time*s)) | $(round(µs,nat_R.time*s)) |
|python | $(round(µs,nai_py.time*s)) | $(round(µs,nat_py.time*s)) |
|julia| **$(round(µs,nai_jl.time*s))** | **$(round(µs,nat_jl.time*s))** |

"""

# ╔═╡ 3705afa9-ddcd-4532-a2af-4acb64ff4972
import Unitful.s as sec

# ╔═╡ ca63b3f6-f303-4319-bec5-23e0e40df2ca
md"""
## Conclusion
The `native` Python & Julia implementations of this simple operation are optimized and similarly fast, R is ~3x slower. But only in Julia can you use non-native code (for loops) and be fast at the same time!)
"""


# ╔═╡ ea2ec924-ae59-4522-9f80-fd689b6fcad2
md"""
[Daniel Moura wrote a very nice blog post on this](https://towardsdatascience.com/r-vs-python-vs-julia-90456a2bcbab) 

![](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*OH_n58xfBC7HSP2U8ZC1GQ.png)

"""

# ╔═╡ 090d4e9d-fec4-4a26-91d2-43719434c52e
md"""
# But why is it faster?
In Julia, everything has a `type`. Built-in types are not special, you can build your own + gain same speed increases!!
"""

# ╔═╡ f548d4d0-2e1a-4183-98b3-bb1d3609b130
typeof(1)

# ╔═╡ b4975af5-46f7-44fd-b71e-f174782f495a


# ╔═╡ 0f61b1e9-91bf-4117-bd58-2c3f0a2a971a
c = [1  2   3;
	 3. 2.3 1;
	 π  ℯ   im]; typeof(c)

# ╔═╡ 2e3e387a-6285-4fa4-bf8f-51136bc80a33
md"""
## "Multiple-dispatch"
Julia has a special (optimized) function for everything!

e.g. for the subtraction `-` operator:
"""

# ╔═╡ add3ccba-49fa-48ba-a55c-99447eace8ec
length(methods(-))

# ╔═╡ 4c826ae7-0a07-42d9-affc-abc3aedd056a
methods(-)[1:5]

# ╔═╡ bfb4421b-9dd6-4f71-8a84-e0f10b3c761f
@which 1 + 3

# ╔═╡ 93942f8f-5814-4577-b0f6-ff3a7673f891
@which 1.0 + 3.0

# ╔═╡ 9cd4b914-ac50-4648-805f-0731210ab4dd
t = '🌻'

# ╔═╡ b9891739-ed09-4257-aa3e-990c934b0c45
begin

struct Circle
	radius::Float64
end
circumference(c::Circle) = 2*pi*c.radius
circle1 = Circle(4)

circumference(circle1)

end

# ╔═╡ 31e4ce80-6b26-45de-b7ce-6014cb968d75
md"""
## Just-In-Time (JIT) compilation
"""

# ╔═╡ 62171934-6878-4d2b-b30c-e26cb09f902f
md"""
Let's look what Julia is doing with it's code

[Source: TestSubjector](https://testsubjector.github.io/blog/2020/03/26/The-Julia-Compilation-Process)
"""

# ╔═╡ bf4673c5-8468-4862-b95b-73e400bf92c6
pos(x) = x < 0 ? 0 : x

# ╔═╡ 28d1cef2-f4fb-45e6-8529-8a5621a0e880
@code_lowered pos(1)

# ╔═╡ 4b1a0c66-1397-4890-a30a-fdb1174b9af1
@code_typed pos(1.)

# ╔═╡ 952995c5-aac9-488c-96c3-e754652d0253
@code_lowered (3 ∈  collect(1:10) )

# ╔═╡ f31c3252-3080-4450-8ee0-05429cb3397b
md"""
## Why Julia is fast: Operator fusion
[Source: Julia Blog 2017](https://julialang.org/blog/2017/01/moredots/)

Imagine:
```julia
f(A) = 3*A^2 + (5*A^3 - sqrt(A))
# with 
y = f([1,2,3,4])
```

In most programming languages, we need a lot of temporary arrays to solve this, assuming individual operations are already vectorized.
```
tmp1 = A^2
tmp2 = 3*tmp1
tmp3 = A^3
tmp4 = 5*tmp3
tmp5 = sqrt(A)
tmp6 = tmp4 - tmp5
x = tmp2 + tmp6
```


"""

# ╔═╡ d7a0eace-e3c7-41b2-ae2f-9bce5cc7c94a
md"""
#
In Julia, the different code optimization steps do something odd:

if you provide a `broadcasted` - that is - a function with `.`-operators:
```julia
y =  3 .* x.^2 .+ 4 .* x .+ 7 .* x.^3;
```

Instead of allocating temporary arrays it translates it back into a for-loop:
```julia
for i in eachindex(A)
    x = A[i]
    X[i] = 3*x^2 + 4*x + 7*x^3
end
```
"""

# ╔═╡ 0151d20c-ba1c-42e3-a8fc-e2ee2f5779da
begin
f(x) =  3x.^2 + 4x + 7x.^3;
fdot(x) =  3 .* x.^2 .+ 4 .* x .+ 7 .* x.^3; # use @. 3x^2 + (5x^3 - sqrt(x))
end

# ╔═╡ a3e4a275-1c43-4e99-9926-8573272d4d98
let
x = rand(10^6);
@time f(x);
@time fdot(x);
@time f.(x)
end;

# ╔═╡ f041e0a3-925f-4960-945f-6901578c6583
md"""
## Messing up the type-system makes Julia slow(er)
"""

# ╔═╡ 52d9e568-6a2a-43b1-87b1-b974f26d8876
begin
vec_bad = Array{Any}(undef,size(vec))
vec_bad .= vec
typeof(vec_bad)
end

# ╔═╡ 60bff96b-91aa-4468-96e2-165e0f2e3aba
@time myfun(vec_bad,x);

# ╔═╡ f1283953-b999-4e67-b21c-a2bd5e3234e1
@time myfun(vec,x);

# ╔═╡ e95ba453-1bed-49a0-8c8e-a42eb297a895
md"""
# unused stuff for now
"""

# ╔═╡ dc3f9a1a-eb21-4d59-a8fd-fe4d3b6f3173
@code_llvm pos(1)

# ╔═╡ 8cf888ba-d162-4a28-a1ce-12b34e839f5e
@code_native pos(1)

# ╔═╡ Cell order:
# ╠═565a9f1f-2be7-4585-95f7-1e3fb61b6f23
# ╠═67cfabae-21f8-11ee-02b9-c9695caf0b6d
# ╟─baf7466d-23be-4a3c-aa05-a68af5a4abdb
# ╟─5043fd74-c556-40ed-a4f7-41a8a0baf963
# ╟─cc231b54-f34c-4349-b5de-479b60778bfc
# ╟─8228c2d3-abd3-4e2d-824b-860f73c9f50f
# ╟─b1947a54-cf7c-474a-8330-a35ad6a6df47
# ╟─56fc2f2d-e1d8-424c-a256-4b7b282dcf69
# ╟─dd2816bc-230e-4c55-8903-5b817a0ea6d7
# ╟─c5855931-4fe4-40bf-83c9-b100bc7f5900
# ╟─d70cdceb-679b-4a92-b5c1-814d3a66b1b9
# ╠═bbf8da5b-4974-4d78-a849-ad6afb28435c
# ╠═a4b978d6-d395-4e49-8adf-578efab2a9d0
# ╠═31c21f8e-09c7-4eaa-b5f6-fc2046f77b0a
# ╠═a3916666-7788-4716-8d6f-3ea75d9c6ad1
# ╠═c963e92f-9116-4ff8-a874-e3e25340e4ae
# ╟─4399b11b-6814-4899-8f6a-12fd9549e3cf
# ╠═a8575e86-a5f8-4743-bb15-1166a236431a
# ╠═ff9c0134-2139-4ee6-b81e-5a4b34484619
# ╟─18e627c6-3dca-4d6d-a825-5884c5541ffb
# ╠═57e70c41-2f0d-45a4-8db4-4575e396614b
# ╠═3435f07d-89b0-4f9b-b08f-2443d72c3ac6
# ╟─55aa1f3b-cf36-4bc7-9c58-7cf45feafb47
# ╠═64af498f-cad1-4500-8ea5-e3b3bfdc1d86
# ╠═2932fad6-78e0-4e57-b9be-b0e795f26c2a
# ╠═37055a8d-6812-4b5d-a22a-e8d913df9c74
# ╠═e6cb58ee-6a3b-48de-9a0f-7bc09cc2c3ee
# ╟─ebcc8d82-3448-4e6d-9a05-f3393f2b8127
# ╟─765ce44e-73ed-484e-81f2-c68c23090372
# ╠═6a157ab7-d741-45c9-b9fa-d7a7f409c6f5
# ╠═06c74bfb-a643-4550-8d9a-a8edeac37cd7
# ╠═f7427228-0848-49cb-b024-96d225602583
# ╟─f1f2be71-a396-40fc-9bfa-b9c63afa07f5
# ╟─b25630ca-ca7b-4d8d-ba70-44f6c04a7787
# ╠═2c8a7b9b-6b02-4ea2-a909-1cf8e9f31c04
# ╠═8223012d-f71e-407d-b8fd-465ad1825f6f
# ╠═24bcdd0b-7cee-4613-a70f-fdc11d3d7c4f
# ╟─7df74cd0-89e8-4452-9a58-3e4b3c51db2f
# ╠═8e3b1614-e430-4876-9887-0cfab25e6e66
# ╠═f87fbe41-a249-4ab0-b777-f83e18490f4b
# ╟─b0fa75ce-37ef-45b2-be50-0a2b596a85ec
# ╠═9e5b4fdd-9695-4ec5-960b-2e66a788303a
# ╟─544f893e-9780-41d2-b749-4f1cb7b6ede5
# ╠═3d099d83-43b5-417b-a01f-4dea93cd2390
# ╠═3cfac7c5-4bab-4844-8a42-be8e0326d79c
# ╠═bbc8fbb4-b29f-49c6-a285-6323c489170d
# ╟─d5caafd7-231e-4785-98b9-87d48bda363a
# ╟─2bcc5531-cb51-4792-81d0-cc412baa7cd2
# ╟─9e5935cf-920a-4726-b9a9-48f5c6b9b79c
# ╟─2d14b423-38d1-424f-85a9-8382708b5703
# ╟─c8a14db6-cfe3-4a03-b952-ff098bd9c1be
# ╠═ee02c371-757e-4853-9a93-bc67672c52b5
# ╠═d50ef3bb-94ad-49f3-8901-4c03973a9d67
# ╟─2f55eedc-8cbc-44da-a94e-e1ffe744592c
# ╠═359de646-1616-4627-9fe1-026cbf2f1b76
# ╟─bb892363-8e90-46c2-a67c-e6a47ffb9d1c
# ╟─bb52ed90-afbb-4fd0-9ead-aeabd421dc9b
# ╠═1fc7fea6-66d0-480b-adc8-b7f5e360316c
# ╠═3c4090ff-6578-48d8-ab58-3036289a1f4d
# ╠═c749e920-35de-4a1d-84cb-88aceb215b33
# ╟─98b14086-bc8c-4725-bf46-8e09f698c2f0
# ╠═31ae04fd-ed82-43bb-b16b-9eb8064060aa
# ╟─a8210381-8b08-456e-aadc-34c0dde1e693
# ╟─89a8b900-98aa-4214-8b83-9c5cb6d12110
# ╠═c28f5865-7e3c-4d19-83f9-ce85b0e1fefe
# ╟─110d3a52-bd9a-47f3-8246-064ab1a15bfd
# ╠═46b4ab6f-f88c-4c4f-8127-d1526f01b559
# ╟─777cc42b-aa3c-4c07-a0b6-b33d265f7c98
# ╠═3ea35338-0f95-4f9e-9daf-f7db5e7bad4d
# ╠═6f3b2def-2058-4ad7-ae04-5f02f3373a63
# ╠═05ca9a83-a2db-4cbe-9c50-f29fdbd458d0
# ╠═595944a9-152a-4877-ad74-a75cbdfe7e9f
# ╠═785678a8-6590-43fd-bb32-d8f10859f48f
# ╟─cb3738f3-a46b-4533-9a58-d35b97012794
# ╠═3d2560db-08dc-4c76-aa34-16cec017e05a
# ╠═d3b87e35-a240-4ca7-b293-da3ac50424fa
# ╠═a48f1985-2eff-4562-9b03-ba6843197e35
# ╠═356ddcab-61da-4af7-a327-331d978fac81
# ╠═20437c9a-e06d-47c2-9f44-1bbcc6fdbe07
# ╠═a1a03aa1-1e83-4ccc-aff0-45e34b89fd3a
# ╠═10914eda-284f-4d0f-8c9b-c2b65fd2f76d
# ╟─545fcee8-d741-41ea-a14a-2e334427fa82
# ╟─5ec7d837-3729-449b-9477-7b30c981d730
# ╟─f0b9c97d-31ce-4016-90e3-c5c30116d4b6
# ╟─bea306d3-ccd5-48da-a299-3bc247d6b16a
# ╠═d340101a-d932-4035-baf1-ee772e9bf25d
# ╠═1c250ad7-d21f-4d49-929a-e900ba8c9e48
# ╠═461440fc-91a5-449d-b887-a477caecf1dc
# ╟─2ba9129b-dcf4-478c-be28-b74ccb1ecffc
# ╟─0728883f-69b4-4cf7-ae6d-fde7ec7bd18d
# ╠═e539b501-d588-4d46-ba13-38d5e04b7529
# ╟─54b8147e-355b-46da-929a-0ac8b1979d68
# ╠═296e8d4e-2441-4133-936d-dba7f9b80147
# ╠═fed19876-0b3a-48d4-8152-0ff6e3224b4e
# ╟─44f3069f-c051-4d76-af7e-09e48a31a5a8
# ╠═d9881c88-93ca-47de-9b40-6880046fa720
# ╠═9e0675fd-a898-4c3f-9a11-3774329983ae
# ╟─ced9f6e7-6bf9-4448-981d-24613279a5ec
# ╟─812adc60-3c95-4547-b7c1-644acd97e8a6
# ╟─f5ab2a8c-f6ef-41c3-b76a-2fafecc8ec83
# ╟─1e9d739b-0a95-49e6-a489-4f2730799a5e
# ╠═5706cf61-07da-460b-92af-a5d0e30ae67a
# ╠═83e0de6d-948f-49a9-b027-1a11faf63e6e
# ╠═3cb07396-07be-404f-a09a-4de20a43af05
# ╠═ecbed7fa-c00f-4cf6-b3b6-ea1057fed55d
# ╟─feb1b91a-dcbb-458d-aa0e-58a21a926ad0
# ╠═7953f1cd-ee07-4013-8428-7f122e6e8b84
# ╟─51b2a265-a432-4ccb-8ecb-742737385dbd
# ╠═dd3d1812-0057-4407-9121-69925c3770df
# ╟─668347ff-0585-4169-8aab-94ee771a55ba
# ╠═1fca0668-c559-40d5-8345-7939a0dee9f2
# ╟─b2b5a4e5-380b-400f-bfff-9384cf6ec429
# ╠═b0be8b8a-db04-4765-af15-ca240987dc0e
# ╟─87745186-2f63-45ef-91e2-b6d757688948
# ╠═3f7d1bbd-fa2f-46e3-a535-8a46a068882a
# ╟─4caaf820-b27d-4944-907d-76517c5afc23
# ╠═b591ff2a-0e48-4a05-997e-56ec4a3b09b4
# ╠═d498a775-3c0c-49fe-8078-d4e00d97e142
# ╟─014cec12-8e87-4ff1-a5a0-d25acc58bd4b
# ╠═6efc1438-c7af-4845-a4e8-493224d8c984
# ╟─57f343a6-9373-4cc4-abd0-fa8859d20c29
# ╟─cb4c24b0-245c-4aed-b34c-123234b45926
# ╟─20dccd48-9fc2-47b2-98f2-26c1821931d8
# ╟─3705afa9-ddcd-4532-a2af-4acb64ff4972
# ╟─c7cf4ce5-eaad-472c-876e-2b797c461a7f
# ╟─ca63b3f6-f303-4319-bec5-23e0e40df2ca
# ╟─ea2ec924-ae59-4522-9f80-fd689b6fcad2
# ╟─090d4e9d-fec4-4a26-91d2-43719434c52e
# ╠═f548d4d0-2e1a-4183-98b3-bb1d3609b130
# ╠═b4975af5-46f7-44fd-b71e-f174782f495a
# ╠═0f61b1e9-91bf-4117-bd58-2c3f0a2a971a
# ╟─2e3e387a-6285-4fa4-bf8f-51136bc80a33
# ╠═add3ccba-49fa-48ba-a55c-99447eace8ec
# ╠═4c826ae7-0a07-42d9-affc-abc3aedd056a
# ╠═bfb4421b-9dd6-4f71-8a84-e0f10b3c761f
# ╠═93942f8f-5814-4577-b0f6-ff3a7673f891
# ╠═9cd4b914-ac50-4648-805f-0731210ab4dd
# ╠═b9891739-ed09-4257-aa3e-990c934b0c45
# ╟─31e4ce80-6b26-45de-b7ce-6014cb968d75
# ╟─62171934-6878-4d2b-b30c-e26cb09f902f
# ╠═bf4673c5-8468-4862-b95b-73e400bf92c6
# ╠═28d1cef2-f4fb-45e6-8529-8a5621a0e880
# ╠═4b1a0c66-1397-4890-a30a-fdb1174b9af1
# ╠═952995c5-aac9-488c-96c3-e754652d0253
# ╟─f31c3252-3080-4450-8ee0-05429cb3397b
# ╟─d7a0eace-e3c7-41b2-ae2f-9bce5cc7c94a
# ╠═0151d20c-ba1c-42e3-a8fc-e2ee2f5779da
# ╠═a3e4a275-1c43-4e99-9926-8573272d4d98
# ╟─f041e0a3-925f-4960-945f-6901578c6583
# ╠═52d9e568-6a2a-43b1-87b1-b974f26d8876
# ╠═60bff96b-91aa-4468-96e2-165e0f2e3aba
# ╠═f1283953-b999-4e67-b21c-a2bd5e3234e1
# ╟─e95ba453-1bed-49a0-8c8e-a42eb297a895
# ╠═dc3f9a1a-eb21-4d59-a8fd-fe4d3b6f3173
# ╠═8cf888ba-d162-4a28-a1ce-12b34e839f5e
