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

# ╔═╡ 83ed505e-21f8-11ee-1d5c-0f27e8691b73
begin
	using Pkg
	Pkg.activate(".") # deactivate pkg manager to use precompiled packages / sysimage
	using PlutoTeachingTools # showing Question-Boxes
	using WGLMakie # plotting
	set_theme!(merge(theme_dark(),Theme(;colormap=:Reds)))
	using PlutoUI # Sliders
end

# ╔═╡ bb2d7aa2-f244-4163-8b21-6dd367c465d5
begin
	ENV["JULIA_CONDAPKG_BACKEND"] ="MicroMamba"
	#using CondaPkg # if you manually want to add PythonPackages
	#CondaPkg.add("numpy")
	using PythonCall
end

# ╔═╡ 5b23e82b-04e3-4fcf-ac7a-2624a8f2112b
md"""
# The Lorenz Function
Interactive get-to-know-julia notebook for the **IMPRS Retreat 2025**

Author: [Benedikt Ehinger](www.s-ccs.de)

---
"""

# ╔═╡ 7a6668e7-b619-4f6d-9ff6-9f1d4128954c
Markdown.MD(Markdown.Admonition("warning", "Where to start",[md""" What follows is some code that you could read/inspect, but mostly you can ignore it for the exercises at hand. 

Start at **Task 1** """]))

# ╔═╡ 4d4685dc-5e45-4893-8a26-3d553cff3bc8
function lorenz_step(state,fixed,Δt)
    x, y, z = state   # current state
	σ, ρ, β = fixed   # current coefficients
    
    dx = σ*(y-x)
    dy = x*(ρ-z) - y
    dz = x*y - β*z
	
	return [x + Δt*dx,
			y + Δt*dy,
			z + Δt*dz] # return the new state
end;

# ╔═╡ 10ab9257-3073-4f20-924b-29b2990e32a6
aside(tip(md"""
This function allocates a new array everytime it updates - it is thus slower than it could be. Be we will optimize it later in Task 4.
"""),v_offset=-250)

# ╔═╡ 869c811e-bd7a-485e-bac4-4cf0006daeab
function lorenz(fixed,Δt,n)
	state0 = [1.0, 0.0, 0.0] # initial state
	res = Array{Float64}(undef,(3,n+1)) # initialize an Array to save things
	res[:,1] .= state0 # assign the initial state
	
	for t in 1:n
		res[:,t+1] = lorenz_step(res[:,t],fixed,Δt)
	end

	# Lorenz wants to escape often, we have to check to not get weird error for weird parameters
	nans = isnan.(res) .| isinf.(res) .| (res.>1e3)
	any(nans) ? @warn("Lorenz escaped - the dynamic systen created a NaN inf value - choose different parameters") : ""
	
	return res[:,.!any(nans,dims=1)[1,:]][:,1:end-1]
end;

# ╔═╡ d22214ac-838b-4e69-8b46-dc62985f959d
begin
Δt = 0.05
Tmax = 100
tlist = range(0,Tmax,step=Δt)
end;

# ╔═╡ d5df570b-19c8-46e6-acd8-f70cf20f9eac
md"""
# Task 1: Changing parameters

Using the `Pluto.jl` reactive backend, changing a value in some cell will automatically update all other cells - including plots.
"""

# ╔═╡ 334f156f-7f7a-4fcf-8ed9-adb22eb095fb


# ╔═╡ a7302ba3-5620-43e6-aee1-abc46393c265
question_box(md"Change one of the values below of the `parameters` Vector - the plot should immediately update")

# ╔═╡ 3fdc5e18-c563-499d-bc7a-4ce8200b4d3f
parameters = [5,7,7/8] # in the lorenz_step-function: [σ, ρ, β]

# ╔═╡ da95a4dd-c814-4c6c-b06f-61d34240ea55
res = lorenz(parameters,Δt,length(tlist))

# ╔═╡ c7114d34-2e1e-441e-b2cb-31b37dcf7f15
begin
	f = plot(res[1,:],res[2,:],res[3,:],color=1:size(res,2))
	update_cam!(f.axis.scene, 0,0)
	f
end

# ╔═╡ afb15a36-e6c5-4be9-aa8d-beecdb4a70f0
f # replot for convenience

# ╔═╡ e4bac073-56b3-4379-bcf8-adbd3d246c26
PlutoTeachingTools.aside

# ╔═╡ 49342d6f-a24a-42aa-9f90-dfff82ad35c2
md"""
# Task 2: Sliders
We can use Sliders instead of fixing the parameters. 

A slider is defined like this:
```julia
@bind yourVarName PlutoUI.Slider(from:to) 
```

If you want to specify the step-size just use `from:step:to` or `range(from,stop=to,step=x)`
"""



# ╔═╡ 4856cd8b-26de-4577-ac1a-497aef8d1931
question_box(md"""Generate three sliders for the three parameters in `parameters`. Remember to replace your chosen variablenames in the `parameters` vector itself!
""")

# ╔═╡ e580399e-bfed-414b-8437-48c1f5d6afb3
tip(md"""
You can get the fancy `σ`, `ρ`, `β` characters by typing e.g. `\beta` + `TAB`
""")

# ╔═╡ 394ea92a-b487-4c39-a377-e9e814bc946b
# add slider 1

# ╔═╡ f9d3ca6f-bb83-41fa-9d85-24d0197a72bf
# add slider 2

# ╔═╡ a8908646-6aa9-4774-8257-054370583fcb
# add slider 3

# ╔═╡ 09f20ad4-3567-4de7-921a-7bd05048c99d
f # replot for your convenience

# ╔═╡ e911dd57-bedd-49a9-adcf-ec634e668e6f
tip(Foldable("You want more beautiful sliders?",md"""
You can specify default values + show the values via
```julia
@bind var PlutoUI.Slider(0:10,show_value=true,default=defaultvalue)
```

If you  want to be super fancy, you can put all this in a nice table, providing labels to your sliders:
```
md\"\"\"
|description|slider|
|---|---|
|param1| $(@bind var PlutoUI.Slider(0:10,show_value=true,default=defaultvalue))
\"\"\"
```
**Tip:** the `$(juliacode)` syntax runs the inline `juliacode` and 'interpolates' the output back into the string/output format """))

# ╔═╡ aea4a4c9-3c02-4436-8d11-21140264c807
Markdown.MD(Markdown.Admonition("tip","Bonus-Question",[md"""
If you have time, provide some `PlutoUI.CheckBox` or `PlutoUI.Select` elements, to change which dimension is plotted on the x/y axis
"""]))


# ╔═╡ c5791eb1-62e4-47a0-bdc1-c3cb2066bd90
md"""
# Task 3: Compare Julia & Python
"""

# ╔═╡ a69b3724-353f-4639-81f4-0875c4203e12
np = PythonCall.pyimport("numpy");

# ╔═╡ aee0ec79-0ce7-4908-90d6-a95cf81d38ee
np.array([1,2,3])

# ╔═╡ b2137820-d51c-4a9f-8b5a-73f3f7f6cb1b
begin
	# this is not exactly how'd you use e.g. numpy from python - because you could just use the package "as if" it would be a julia package, but I found it more convenient in my usecase
python_results = pyexec(@NamedTuple{xyzs},"""
import numpy as np
def lorenz(xyz,fixed):
    import numpy as np
    s,r,b = (fixed[0],fixed[1],fixed[2])
    x, y, z = xyz
    x_dot = s*(y - x)
    y_dot = r*x - y - x*z
    z_dot = x*y - b*z
    return np.array([x_dot, y_dot, z_dot])


xyzs = np.empty((num_steps + 1, 3))  # Need one more for the initial values
xyzs[0] = (1.0, 0., 0.)  # Set initial values
# Step through "time", calculating the partial derivatives at the current point
# and using them to estimate the next point
for i in range(num_steps):
    xyzs[i + 1] = xyzs[i] + lorenz(xyzs[i],fixed) * dt

""",Main,(;fixed=parameters,num_steps=length(tlist)-1,dt=Δt))
	python_results = collect(pyconvert(Array,python_results.xyzs)')
end

# ╔═╡ 9ec4822e-8d7b-4948-afe9-228ca2d924ae
julia_results = lorenz(parameters,Δt,length(tlist))

# ╔═╡ ab1eabac-cd53-49a5-80db-edf01124071a
question_box(md"""
Check that the solution is actually equal, using `==`
""")

# ╔═╡ 5b309790-4c82-447d-b910-d5a469e52211
# Add code here - Are they equal?


# ╔═╡ 46411942-9e86-4108-ae64-4784e6d6bddd
question_box(md"""
**Task**: Calculate and plot the elementwise differences in one (or all three) dimensions. Use `plot`,elementwise subtraction `.-` and `x[1,:]` to access one dimension
""")


# ╔═╡ 0734c0d9-06c6-445f-bbda-3b8294e89cc6
# put your code here

# ╔═╡ f2094213-2243-4978-824a-37e1987b9631
md"""
# Task 4: Timing is everything
"""

# ╔═╡ 4019ad17-50b0-4983-b375-e237219b99e0
question_box(md""" Add the `@time` macro infront of the python & julia code to evaluate their timing. 

**Note:** In principle, you should use `BenchmarkTools.@btime` or `BenchmarkTools.@benchmark` which runs the function many times and takes the fastest (`@btime`) or shows a histogram (@benchmark) - but who has time for that?
""")

# ╔═╡ 73af4c85-8170-4404-aac7-9d45e698769a
md"""
# Task 5: Improve the speed!
If you are super fast with everything, some optional ideas:
"""

# ╔═╡ 88a8cdfb-5300-41c6-a9ba-2da53d37ee91
question_box(md"""**Speeding up Python**

Can you speed up the python code to match Julias code?
""")

# ╔═╡ 003214b4-e62c-432a-a9a7-9b580c460de4
question_box(md"""**Speeding up Julia**

If we can replace the for loop + Lorenz-function with something like
```julia
for col in eachcol(res)
		col .= lorenz_step!(state0,fixed,Δt)
end
```
We have some further optimization potential.

Note the `lorenz_step!` exclamationmark. Which means, that now the lorenz_step function has to also update the `state0` array with the `.=` syntax inside the function (and also return a copy of the state to be saved in `col`)



""")

# ╔═╡ ce86adc0-f10d-47c9-9436-a6b20c2d496e
md"""
----
"""

# ╔═╡ 02172a1a-ac29-4081-886d-a2daeab0d29d
md"""
What follows here is just some setup code - interesting maybe to see how Python-Packages can be added in the `PythonCall` package
"""

# ╔═╡ 609633d1-2b1b-4834-a1c3-84ffe11bc946
TableOfContents()

# ╔═╡ 924a83e4-92a1-4176-9cd2-c48f866bffec
WGLMakie.Page()

# ╔═╡ 8a224690-723a-4af2-8733-8a0a83f7812b
PlutoTeachingTools.hint(title::String,str) = Markdown.MD(Markdown.Admonition("hint",title,[str]))

# ╔═╡ 003cd0f8-b7cb-4770-9135-df5058b52a09
hint("Slider-Solution",md"""
```julia
# for one slider:
@bind σ PlutoUI.Slider(1:0.1:10)
parameters= [σ, 12/3,4]
```
""")

# ╔═╡ 21ecad53-8987-44c2-81d8-6c6374dcd073
hint("Hover to see the answer",md"""
They are not! 
 **Solution:** Either
	 `julia_results == python_results` - or elementwise `julia_results .== python_results`

""")

# ╔═╡ 11280da3-437a-45a6-bc6f-92ca2d03a98b
hint("Hint",md"""
Ooops - I don't know Python well enough to actually speed this up, sorry. Be sure to share your speed improvements with me!
""")

# ╔═╡ 250144dd-9034-4c05-9316-7bb89df429bf
hint("Solution",md"""
Make use of the following function
```julia
function lorenz_step!(state,fixed,Δt)
    x, y, z = state   #variables are part of vector array u
	σ, ρ, β = fixed    #coefficients are part of vector array p
    
    dx = σ*(y-x)
    dy = x*(ρ-z) - y
    dz = x*y - β*z
	state .= x + Δt*dx, y + Δt*dy, z + Δt*dz # in place update the state
	return copy(state) # also return a copy of the state
end
```
""")

# ╔═╡ 49576c5c-15d6-4c56-8190-f2ce022e6233
hint("Bonus: For the super-curious minded", md"""
Somewhat surprising (to me) this code:
```julia
res = hcat([lorenz_step!(state0,fixed,Δt) for s in tlist]...)
```
has the same fast performance as the loop!
""")

# ╔═╡ Cell order:
# ╟─5b23e82b-04e3-4fcf-ac7a-2624a8f2112b
# ╟─7a6668e7-b619-4f6d-9ff6-9f1d4128954c
# ╠═4d4685dc-5e45-4893-8a26-3d553cff3bc8
# ╟─10ab9257-3073-4f20-924b-29b2990e32a6
# ╠═869c811e-bd7a-485e-bac4-4cf0006daeab
# ╠═d22214ac-838b-4e69-8b46-dc62985f959d
# ╠═da95a4dd-c814-4c6c-b06f-61d34240ea55
# ╠═c7114d34-2e1e-441e-b2cb-31b37dcf7f15
# ╟─d5df570b-19c8-46e6-acd8-f70cf20f9eac
# ╠═334f156f-7f7a-4fcf-8ed9-adb22eb095fb
# ╟─a7302ba3-5620-43e6-aee1-abc46393c265
# ╠═3fdc5e18-c563-499d-bc7a-4ce8200b4d3f
# ╠═afb15a36-e6c5-4be9-aa8d-beecdb4a70f0
# ╠═e4bac073-56b3-4379-bcf8-adbd3d246c26
# ╟─49342d6f-a24a-42aa-9f90-dfff82ad35c2
# ╟─4856cd8b-26de-4577-ac1a-497aef8d1931
# ╟─e580399e-bfed-414b-8437-48c1f5d6afb3
# ╠═394ea92a-b487-4c39-a377-e9e814bc946b
# ╠═f9d3ca6f-bb83-41fa-9d85-24d0197a72bf
# ╠═a8908646-6aa9-4774-8257-054370583fcb
# ╠═09f20ad4-3567-4de7-921a-7bd05048c99d
# ╟─e911dd57-bedd-49a9-adcf-ec634e668e6f
# ╟─003cd0f8-b7cb-4770-9135-df5058b52a09
# ╟─aea4a4c9-3c02-4436-8d11-21140264c807
# ╟─c5791eb1-62e4-47a0-bdc1-c3cb2066bd90
# ╠═a69b3724-353f-4639-81f4-0875c4203e12
# ╠═aee0ec79-0ce7-4908-90d6-a95cf81d38ee
# ╠═b2137820-d51c-4a9f-8b5a-73f3f7f6cb1b
# ╠═9ec4822e-8d7b-4948-afe9-228ca2d924ae
# ╟─ab1eabac-cd53-49a5-80db-edf01124071a
# ╠═5b309790-4c82-447d-b910-d5a469e52211
# ╟─21ecad53-8987-44c2-81d8-6c6374dcd073
# ╟─46411942-9e86-4108-ae64-4784e6d6bddd
# ╠═0734c0d9-06c6-445f-bbda-3b8294e89cc6
# ╟─f2094213-2243-4978-824a-37e1987b9631
# ╟─4019ad17-50b0-4983-b375-e237219b99e0
# ╟─73af4c85-8170-4404-aac7-9d45e698769a
# ╟─88a8cdfb-5300-41c6-a9ba-2da53d37ee91
# ╟─11280da3-437a-45a6-bc6f-92ca2d03a98b
# ╟─003214b4-e62c-432a-a9a7-9b580c460de4
# ╟─250144dd-9034-4c05-9316-7bb89df429bf
# ╟─49576c5c-15d6-4c56-8190-f2ce022e6233
# ╟─ce86adc0-f10d-47c9-9436-a6b20c2d496e
# ╟─02172a1a-ac29-4081-886d-a2daeab0d29d
# ╠═bb2d7aa2-f244-4163-8b21-6dd367c465d5
# ╠═609633d1-2b1b-4834-a1c3-84ffe11bc946
# ╠═924a83e4-92a1-4176-9cd2-c48f866bffec
# ╠═83ed505e-21f8-11ee-1d5c-0f27e8691b73
# ╠═8a224690-723a-4af2-8733-8a0a83f7812b
