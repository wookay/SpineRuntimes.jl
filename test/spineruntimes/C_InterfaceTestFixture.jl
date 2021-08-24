module test_spineruntimes_C_InterfaceTestFixture

using Test
using SpineRuntimes: Lib
using .Lib: spAtlas_createFromFile, spAtlas_dispose, spSkeletonJson_create, spSkeletonJson_readSkeletonDataFile, spSkeletonJson_dispose,
            spAnimationStateData_create, spSkeleton_create, spAnimationState_create, spSkeleton_setToSetupPose,
            spAnimationState_setAnimationByName, spAnimationState_addAnimationByName,
            spSkeleton_update, spAnimationState_update, spAnimationState_apply,
            spSkeleton_dispose, spAnimationState_dispose, spAnimationStateData_dispose, spSkeletonData_dispose
using .Lib: spAtlas, spSkeletonJson, spSkeletonData, spAnimationStateData, spAnimation

# https://github.com/EsotericSoftware/spine-runtimes/blob/4.0/spine-c/spine-c-unit-tests/tests/C_InterfaceTestFixture.cpp

function readSkeletonJsonData(jsonName::String, patlas::Ptr{spAtlas})
    pjson::Ptr{spSkeletonJson} = spSkeletonJson_create(patlas)
    pskeletonData::Ptr{spSkeletonData} = spSkeletonJson_readSkeletonDataFile(pjson, Base.unsafe_convert(Ptr{Cchar}, jsonName))
    spSkeletonJson_dispose(pjson)
    return pskeletonData
end

function isnull(x)
    x == C_NULL
end

function enumerateAnimations(pskeletonData)::Vector{spAnimation}
    if !isnull(pskeletonData)
        skeletonData = unsafe_load(pskeletonData)
        animations = unsafe_wrap(Array, skeletonData.animations, skeletonData.animationsCount)
        return unsafe_load.(animations)
    end
    return []
end

macro isnotnull(p)
    name = string(p)
    quote
        ptr = $(esc(p))
        if ptr == C_NULL
            throw(AssertionError(string($name, " != C_NULL")))
        end 
    end
end

function testRunner(block, jsonName::String, atlasName::String)
    path::Ptr{Cchar} = Base.unsafe_convert(Ptr{Cchar}, atlasName)
    patlas = spAtlas_createFromFile(path, C_NULL)
    @isnotnull patlas
    atlas::spAtlas = unsafe_load(patlas)
    pages = unsafe_load(atlas.pages)
    pskeletonData = readSkeletonJsonData(jsonName, patlas)
    pstateData::Ptr{spAnimationStateData} = spAnimationStateData_create(pskeletonData)
    stateData = unsafe_load(pstateData)
    stateData.defaultMix = 0.2
    pskeleton = spSkeleton_create(pskeletonData)
    pstate = spAnimationState_create(pstateData)
    spSkeleton_setToSetupPose(pskeleton)
    anims = enumerateAnimations(pskeletonData)
    spAnimationState_setAnimationByName(pstate, 0, first(anims).name, false)
    for anim in anims[2:end]
        spAnimationState_addAnimationByName(pstate, 0, anim.name, false, 0.0f0)
    end
    timeSlice = 1.0f0 / 60.0f0
    spSkeleton_update(pskeleton, timeSlice)
    spAnimationState_update(pstate, timeSlice)
    spAnimationState_apply(pstate, pskeleton)

    block(anims)

    # Dispose Instance
    spSkeleton_dispose(pskeleton)
    spAnimationState_dispose(pstate)

    # Dispose Global
    spAnimationStateData_dispose(pstateData)
    spSkeletonData_dispose(pskeletonData)
    spAtlas_dispose(patlas)
end

const SPINEBOY_JSON  = normpath(@__DIR__, "testdata/spineboy/spineboy-ess.json")
const SPINEBOY_ATLAS = normpath(@__DIR__, "testdata/spineboy/spineboy.atlas")
const RAPTOR_JSON    = normpath(@__DIR__, "testdata/raptor/raptor-pro.json")
const RAPTOR_ATLAS   = normpath(@__DIR__, "testdata/raptor/raptor.atlas")
const GOBLINS_JSON   = normpath(@__DIR__, "testdata/goblins/goblins-pro.json")
const GOBLINS_ATLAS  = normpath(@__DIR__, "testdata/goblins/goblins.atlas")

get_anim_name(x) = unsafe_string(x.name)

testRunner(SPINEBOY_JSON, SPINEBOY_ATLAS) do anims
    @test length(anims) == 7
    @test get_anim_name.(anims) == ["death", "hit", "idle", "jump", "run", "shoot", "walk"]
end
testRunner(RAPTOR_JSON,   RAPTOR_ATLAS) do anims
    @test length(anims) == 5
    @test get_anim_name.(anims) == ["gun-grab", "gun-holster", "jump", "roar", "walk"]
end
testRunner(GOBLINS_JSON,  GOBLINS_ATLAS) do anims
    @test length(anims) == 1
    @test get_anim_name.(anims) == ["walk"]
end

end # module test_spineruntimes_C_InterfaceTestFixture
