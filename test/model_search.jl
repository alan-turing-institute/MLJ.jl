module TestModelSearch

# using Revise
using Test
using MLJ

pca = model("PCA", pkg="MultivariateStats")
cnst = model("ConstantRegressor", pkg="MLJ")

@test_throws ArgumentError MLJ.model("Julia")

@test traits(ConstantRegressor) == cnst
@test traits(Standardizer()) == model("Standardizer", pkg="MLJ")

@testset "localmodels" begin
    tree = model("DecisionTreeRegressor")
    @test cnst in localmodels(mod=TestModelSearch)
    @test !(tree in localmodels(mod=TestModelSearch))
    import MLJModels
    import DecisionTree
    import MLJModels.DecisionTree_.DecisionTreeRegressor
    @test tree in localmodels(mod=TestModelSearch)
end

@testset "models() and localmodels" begin
    t(model) = model.is_pure_julia
    mods = models(t)
    @test pca in mods
    @test cnst in mods
    @test !(model("SVC") in mods)
    mods = localmodels(t, mod=TestModelSearch)
    @test cnst in mods
    @test !(pca in mods)
end

end
true