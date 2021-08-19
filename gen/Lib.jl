module Lib

using SpineRuntimes_jll
export SpineRuntimes_jll

using CEnum



@cenum spTimelineType::UInt32 begin
    SP_TIMELINE_ROTATE = 0
    SP_TIMELINE_TRANSLATE = 1
    SP_TIMELINE_SCALE = 2
    SP_TIMELINE_SHEAR = 3
    SP_TIMELINE_ATTACHMENT = 4
    SP_TIMELINE_COLOR = 5
    SP_TIMELINE_DEFORM = 6
    SP_TIMELINE_EVENT = 7
    SP_TIMELINE_DRAWORDER = 8
    SP_TIMELINE_IKCONSTRAINT = 9
    SP_TIMELINE_TRANSFORMCONSTRAINT = 10
    SP_TIMELINE_PATHCONSTRAINTPOSITION = 11
    SP_TIMELINE_PATHCONSTRAINTSPACING = 12
    SP_TIMELINE_PATHCONSTRAINTMIX = 13
    SP_TIMELINE_TWOCOLOR = 14
end

struct spTimeline
    type::spTimelineType
    vtable::Ptr{Cvoid}
end

struct spAnimation
    name::Ptr{Cchar}
    duration::Cfloat
    timelinesCount::Cint
    timelines::Ptr{Ptr{spTimeline}}
end

@cenum spMixBlend::UInt32 begin
    SP_MIX_BLEND_SETUP = 0
    SP_MIX_BLEND_FIRST = 1
    SP_MIX_BLEND_REPLACE = 2
    SP_MIX_BLEND_ADD = 3
end

@cenum spMixDirection::UInt32 begin
    SP_MIX_DIRECTION_IN = 0
    SP_MIX_DIRECTION_OUT = 1
end

function spAnimation_create(name, timelinesCount)
    ccall((:spAnimation_create, libspine), Ptr{spAnimation}, (Ptr{Cchar}, Cint), name, timelinesCount)
end

function spAnimation_dispose(self)
    ccall((:spAnimation_dispose, libspine), Cvoid, (Ptr{spAnimation},), self)
end

@cenum spTransformMode::UInt32 begin
    SP_TRANSFORMMODE_NORMAL = 0
    SP_TRANSFORMMODE_ONLYTRANSLATION = 1
    SP_TRANSFORMMODE_NOROTATIONORREFLECTION = 2
    SP_TRANSFORMMODE_NOSCALE = 3
    SP_TRANSFORMMODE_NOSCALEORREFLECTION = 4
end

struct spBoneData
    index::Cint
    name::Ptr{Cchar}
    parent::Ptr{spBoneData}
    length::Cfloat
    x::Cfloat
    y::Cfloat
    rotation::Cfloat
    scaleX::Cfloat
    scaleY::Cfloat
    shearX::Cfloat
    shearY::Cfloat
    transformMode::spTransformMode
    skinRequired::Cint
end

struct spIkConstraintData
    name::Ptr{Cchar}
    order::Cint
    skinRequired::Cint
    bonesCount::Cint
    bones::Ptr{Ptr{spBoneData}}
    target::Ptr{spBoneData}
    bendDirection::Cint
    compress::Cint
    stretch::Cint
    uniform::Cint
    mix::Cfloat
    softness::Cfloat
end

struct spBone
    data::Ptr{spBoneData}
    skeleton::Ptr{Cvoid} # skeleton::Ptr{spSkeleton}
    parent::Ptr{spBone}
    childrenCount::Cint
    children::Ptr{Ptr{spBone}}
    x::Cfloat
    y::Cfloat
    rotation::Cfloat
    scaleX::Cfloat
    scaleY::Cfloat
    shearX::Cfloat
    shearY::Cfloat
    ax::Cfloat
    ay::Cfloat
    arotation::Cfloat
    ascaleX::Cfloat
    ascaleY::Cfloat
    ashearX::Cfloat
    ashearY::Cfloat
    appliedValid::Cint
    a::Cfloat
    b::Cfloat
    worldX::Cfloat
    c::Cfloat
    d::Cfloat
    worldY::Cfloat
    sorted::Cint
    active::Cint
end

function Base.getproperty(x::spBone, f::Symbol)
    f === :skeleton && return Ptr{spSkeleton}(getfield(x, f))
    return getfield(x, f)
end

struct spIkConstraint
    data::Ptr{spIkConstraintData}
    bonesCount::Cint
    bones::Ptr{Ptr{spBone}}
    target::Ptr{spBone}
    bendDirection::Cint
    compress::Cint
    stretch::Cint
    mix::Cfloat
    softness::Cfloat
    active::Cint
end

struct spTransformConstraintData
    name::Ptr{Cchar}
    order::Cint
    skinRequired::Cint
    bonesCount::Cint
    bones::Ptr{Ptr{spBoneData}}
    target::Ptr{spBoneData}
    rotateMix::Cfloat
    translateMix::Cfloat
    scaleMix::Cfloat
    shearMix::Cfloat
    offsetRotation::Cfloat
    offsetX::Cfloat
    offsetY::Cfloat
    offsetScaleX::Cfloat
    offsetScaleY::Cfloat
    offsetShearY::Cfloat
    relative::Cint
    _local::Cint
end

struct spTransformConstraint
    data::Ptr{spTransformConstraintData}
    bonesCount::Cint
    bones::Ptr{Ptr{spBone}}
    target::Ptr{spBone}
    rotateMix::Cfloat
    translateMix::Cfloat
    scaleMix::Cfloat
    shearMix::Cfloat
    active::Cint
end

struct spColor
    r::Cfloat
    g::Cfloat
    b::Cfloat
    a::Cfloat
end

@cenum spBlendMode::UInt32 begin
    SP_BLEND_MODE_NORMAL = 0
    SP_BLEND_MODE_ADDITIVE = 1
    SP_BLEND_MODE_MULTIPLY = 2
    SP_BLEND_MODE_SCREEN = 3
end

struct spSlotData
    index::Cint
    name::Ptr{Cchar}
    boneData::Ptr{spBoneData}
    attachmentName::Ptr{Cchar}
    color::spColor
    darkColor::Ptr{spColor}
    blendMode::spBlendMode
end

@cenum spPositionMode::UInt32 begin
    SP_POSITION_MODE_FIXED = 0
    SP_POSITION_MODE_PERCENT = 1
end

@cenum spSpacingMode::UInt32 begin
    SP_SPACING_MODE_LENGTH = 0
    SP_SPACING_MODE_FIXED = 1
    SP_SPACING_MODE_PERCENT = 2
end

@cenum spRotateMode::UInt32 begin
    SP_ROTATE_MODE_TANGENT = 0
    SP_ROTATE_MODE_CHAIN = 1
    SP_ROTATE_MODE_CHAIN_SCALE = 2
end

struct spPathConstraintData
    name::Ptr{Cchar}
    order::Cint
    skinRequired::Cint
    bonesCount::Cint
    bones::Ptr{Ptr{spBoneData}}
    target::Ptr{spSlotData}
    positionMode::spPositionMode
    spacingMode::spSpacingMode
    rotateMode::spRotateMode
    offsetRotation::Cfloat
    position::Cfloat
    spacing::Cfloat
    rotateMix::Cfloat
    translateMix::Cfloat
end

@cenum spAttachmentType::UInt32 begin
    SP_ATTACHMENT_REGION = 0
    SP_ATTACHMENT_BOUNDING_BOX = 1
    SP_ATTACHMENT_MESH = 2
    SP_ATTACHMENT_LINKED_MESH = 3
    SP_ATTACHMENT_PATH = 4
    SP_ATTACHMENT_POINT = 5
    SP_ATTACHMENT_CLIPPING = 6
end

struct spAttachmentLoader
    error1::Ptr{Cchar}
    error2::Ptr{Cchar}
    vtable::Ptr{Cvoid}
end

struct spAttachment
    name::Ptr{Cchar}
    type::spAttachmentType
    vtable::Ptr{Cvoid}
    refCount::Cint
    attachmentLoader::Ptr{spAttachmentLoader}
end

struct spSlot
    data::Ptr{spSlotData}
    bone::Ptr{spBone}
    color::spColor
    darkColor::Ptr{spColor}
    attachment::Ptr{spAttachment}
    attachmentState::Cint
    deformCapacity::Cint
    deformCount::Cint
    deform::Ptr{Cfloat}
end

struct spPathConstraint
    data::Ptr{spPathConstraintData}
    bonesCount::Cint
    bones::Ptr{Ptr{spBone}}
    target::Ptr{spSlot}
    position::Cfloat
    spacing::Cfloat
    rotateMix::Cfloat
    translateMix::Cfloat
    spacesCount::Cint
    spaces::Ptr{Cfloat}
    positionsCount::Cint
    positions::Ptr{Cfloat}
    worldCount::Cint
    world::Ptr{Cfloat}
    curvesCount::Cint
    curves::Ptr{Cfloat}
    lengthsCount::Cint
    lengths::Ptr{Cfloat}
    segments::NTuple{10, Cfloat}
    active::Cint
end

struct spBoneDataArray
    size::Cint
    capacity::Cint
    items::Ptr{Ptr{spBoneData}}
end

struct spIkConstraintDataArray
    size::Cint
    capacity::Cint
    items::Ptr{Ptr{spIkConstraintData}}
end

struct spTransformConstraintDataArray
    size::Cint
    capacity::Cint
    items::Ptr{Ptr{spTransformConstraintData}}
end

struct spPathConstraintDataArray
    size::Cint
    capacity::Cint
    items::Ptr{Ptr{spPathConstraintData}}
end

struct spSkin
    name::Ptr{Cchar}
    bones::Ptr{spBoneDataArray}
    ikConstraints::Ptr{spIkConstraintDataArray}
    transformConstraints::Ptr{spTransformConstraintDataArray}
    pathConstraints::Ptr{spPathConstraintDataArray}
end

struct spSkeleton
    data::Ptr{Cvoid} # data::Ptr{spSkeletonData}
    bonesCount::Cint
    bones::Ptr{Ptr{spBone}}
    root::Ptr{spBone}
    slotsCount::Cint
    slots::Ptr{Ptr{spSlot}}
    drawOrder::Ptr{Ptr{spSlot}}
    ikConstraintsCount::Cint
    ikConstraints::Ptr{Ptr{spIkConstraint}}
    transformConstraintsCount::Cint
    transformConstraints::Ptr{Ptr{spTransformConstraint}}
    pathConstraintsCount::Cint
    pathConstraints::Ptr{Ptr{spPathConstraint}}
    skin::Ptr{spSkin}
    color::spColor
    time::Cfloat
    scaleX::Cfloat
    scaleY::Cfloat
    x::Cfloat
    y::Cfloat
end

function Base.getproperty(x::spSkeleton, f::Symbol)
    f === :data && return Ptr{spSkeletonData}(getfield(x, f))
    return getfield(x, f)
end

struct spEventData
    name::Ptr{Cchar}
    intValue::Cint
    floatValue::Cfloat
    stringValue::Ptr{Cchar}
    audioPath::Ptr{Cchar}
    volume::Cfloat
    balance::Cfloat
end

struct spEvent
    data::Ptr{spEventData}
    time::Cfloat
    intValue::Cint
    floatValue::Cfloat
    stringValue::Ptr{Cchar}
    volume::Cfloat
    balance::Cfloat
end

function spAnimation_apply(self, skeleton, lastTime, time, loop, events, eventsCount, alpha, blend, direction)
    ccall((:spAnimation_apply, libspine), Cvoid, (Ptr{spAnimation}, Ptr{spSkeleton}, Cfloat, Cfloat, Cint, Ptr{Ptr{spEvent}}, Ptr{Cint}, Cfloat, spMixBlend, spMixDirection), self, skeleton, lastTime, time, loop, events, eventsCount, alpha, blend, direction)
end

function spTimeline_dispose(self)
    ccall((:spTimeline_dispose, libspine), Cvoid, (Ptr{spTimeline},), self)
end

function spTimeline_apply(self, skeleton, lastTime, time, firedEvents, eventsCount, alpha, blend, direction)
    ccall((:spTimeline_apply, libspine), Cvoid, (Ptr{spTimeline}, Ptr{spSkeleton}, Cfloat, Cfloat, Ptr{Ptr{spEvent}}, Ptr{Cint}, Cfloat, spMixBlend, spMixDirection), self, skeleton, lastTime, time, firedEvents, eventsCount, alpha, blend, direction)
end

function spTimeline_getPropertyId(self)
    ccall((:spTimeline_getPropertyId, libspine), Cint, (Ptr{spTimeline},), self)
end

struct spCurveTimeline
    super::spTimeline
    curves::Ptr{Cfloat}
end

function spCurveTimeline_setLinear(self, frameIndex)
    ccall((:spCurveTimeline_setLinear, libspine), Cvoid, (Ptr{spCurveTimeline}, Cint), self, frameIndex)
end

function spCurveTimeline_setStepped(self, frameIndex)
    ccall((:spCurveTimeline_setStepped, libspine), Cvoid, (Ptr{spCurveTimeline}, Cint), self, frameIndex)
end

function spCurveTimeline_setCurve(self, frameIndex, cx1, cy1, cx2, cy2)
    ccall((:spCurveTimeline_setCurve, libspine), Cvoid, (Ptr{spCurveTimeline}, Cint, Cfloat, Cfloat, Cfloat, Cfloat), self, frameIndex, cx1, cy1, cx2, cy2)
end

function spCurveTimeline_getCurvePercent(self, frameIndex, percent)
    ccall((:spCurveTimeline_getCurvePercent, libspine), Cfloat, (Ptr{spCurveTimeline}, Cint, Cfloat), self, frameIndex, percent)
end

struct spBaseTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    boneIndex::Cint
end

const spRotateTimeline = spBaseTimeline

function spRotateTimeline_create(framesCount)
    ccall((:spRotateTimeline_create, libspine), Ptr{spRotateTimeline}, (Cint,), framesCount)
end

function spRotateTimeline_setFrame(self, frameIndex, time, angle)
    ccall((:spRotateTimeline_setFrame, libspine), Cvoid, (Ptr{spRotateTimeline}, Cint, Cfloat, Cfloat), self, frameIndex, time, angle)
end

const spTranslateTimeline = spBaseTimeline

function spTranslateTimeline_create(framesCount)
    ccall((:spTranslateTimeline_create, libspine), Ptr{spTranslateTimeline}, (Cint,), framesCount)
end

function spTranslateTimeline_setFrame(self, frameIndex, time, x, y)
    ccall((:spTranslateTimeline_setFrame, libspine), Cvoid, (Ptr{spTranslateTimeline}, Cint, Cfloat, Cfloat, Cfloat), self, frameIndex, time, x, y)
end

const spScaleTimeline = spBaseTimeline

function spScaleTimeline_create(framesCount)
    ccall((:spScaleTimeline_create, libspine), Ptr{spScaleTimeline}, (Cint,), framesCount)
end

function spScaleTimeline_setFrame(self, frameIndex, time, x, y)
    ccall((:spScaleTimeline_setFrame, libspine), Cvoid, (Ptr{spScaleTimeline}, Cint, Cfloat, Cfloat, Cfloat), self, frameIndex, time, x, y)
end

const spShearTimeline = spBaseTimeline

function spShearTimeline_create(framesCount)
    ccall((:spShearTimeline_create, libspine), Ptr{spShearTimeline}, (Cint,), framesCount)
end

function spShearTimeline_setFrame(self, frameIndex, time, x, y)
    ccall((:spShearTimeline_setFrame, libspine), Cvoid, (Ptr{spShearTimeline}, Cint, Cfloat, Cfloat, Cfloat), self, frameIndex, time, x, y)
end

struct spColorTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    slotIndex::Cint
end

function spColorTimeline_create(framesCount)
    ccall((:spColorTimeline_create, libspine), Ptr{spColorTimeline}, (Cint,), framesCount)
end

function spColorTimeline_setFrame(self, frameIndex, time, r, g, b, a)
    ccall((:spColorTimeline_setFrame, libspine), Cvoid, (Ptr{spColorTimeline}, Cint, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), self, frameIndex, time, r, g, b, a)
end

struct spTwoColorTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    slotIndex::Cint
end

function spTwoColorTimeline_create(framesCount)
    ccall((:spTwoColorTimeline_create, libspine), Ptr{spTwoColorTimeline}, (Cint,), framesCount)
end

function spTwoColorTimeline_setFrame(self, frameIndex, time, r, g, b, a, r2, g2, b2)
    ccall((:spTwoColorTimeline_setFrame, libspine), Cvoid, (Ptr{spTwoColorTimeline}, Cint, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), self, frameIndex, time, r, g, b, a, r2, g2, b2)
end

struct spAttachmentTimeline
    super::spTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    slotIndex::Cint
    attachmentNames::Ptr{Ptr{Cchar}}
end

function spAttachmentTimeline_create(framesCount)
    ccall((:spAttachmentTimeline_create, libspine), Ptr{spAttachmentTimeline}, (Cint,), framesCount)
end

function spAttachmentTimeline_setFrame(self, frameIndex, time, attachmentName)
    ccall((:spAttachmentTimeline_setFrame, libspine), Cvoid, (Ptr{spAttachmentTimeline}, Cint, Cfloat, Ptr{Cchar}), self, frameIndex, time, attachmentName)
end

struct spEventTimeline
    super::spTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    events::Ptr{Ptr{spEvent}}
end

function spEventTimeline_create(framesCount)
    ccall((:spEventTimeline_create, libspine), Ptr{spEventTimeline}, (Cint,), framesCount)
end

function spEventTimeline_setFrame(self, frameIndex, event)
    ccall((:spEventTimeline_setFrame, libspine), Cvoid, (Ptr{spEventTimeline}, Cint, Ptr{spEvent}), self, frameIndex, event)
end

struct spDrawOrderTimeline
    super::spTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    drawOrders::Ptr{Ptr{Cint}}
    slotsCount::Cint
end

function spDrawOrderTimeline_create(framesCount, slotsCount)
    ccall((:spDrawOrderTimeline_create, libspine), Ptr{spDrawOrderTimeline}, (Cint, Cint), framesCount, slotsCount)
end

function spDrawOrderTimeline_setFrame(self, frameIndex, time, drawOrder)
    ccall((:spDrawOrderTimeline_setFrame, libspine), Cvoid, (Ptr{spDrawOrderTimeline}, Cint, Cfloat, Ptr{Cint}), self, frameIndex, time, drawOrder)
end

struct spDeformTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    frameVerticesCount::Cint
    frameVertices::Ptr{Ptr{Cfloat}}
    slotIndex::Cint
    attachment::Ptr{spAttachment}
end

function spDeformTimeline_create(framesCount, frameVerticesCount)
    ccall((:spDeformTimeline_create, libspine), Ptr{spDeformTimeline}, (Cint, Cint), framesCount, frameVerticesCount)
end

function spDeformTimeline_setFrame(self, frameIndex, time, vertices)
    ccall((:spDeformTimeline_setFrame, libspine), Cvoid, (Ptr{spDeformTimeline}, Cint, Cfloat, Ptr{Cfloat}), self, frameIndex, time, vertices)
end

struct spIkConstraintTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    ikConstraintIndex::Cint
end

function spIkConstraintTimeline_create(framesCount)
    ccall((:spIkConstraintTimeline_create, libspine), Ptr{spIkConstraintTimeline}, (Cint,), framesCount)
end

function spIkConstraintTimeline_setFrame(self, frameIndex, time, mix, softness, bendDirection, compress, stretch)
    ccall((:spIkConstraintTimeline_setFrame, libspine), Cvoid, (Ptr{spIkConstraintTimeline}, Cint, Cfloat, Cfloat, Cfloat, Cint, Cint, Cint), self, frameIndex, time, mix, softness, bendDirection, compress, stretch)
end

struct spTransformConstraintTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    transformConstraintIndex::Cint
end

function spTransformConstraintTimeline_create(framesCount)
    ccall((:spTransformConstraintTimeline_create, libspine), Ptr{spTransformConstraintTimeline}, (Cint,), framesCount)
end

function spTransformConstraintTimeline_setFrame(self, frameIndex, time, rotateMix, translateMix, scaleMix, shearMix)
    ccall((:spTransformConstraintTimeline_setFrame, libspine), Cvoid, (Ptr{spTransformConstraintTimeline}, Cint, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), self, frameIndex, time, rotateMix, translateMix, scaleMix, shearMix)
end

struct spPathConstraintPositionTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    pathConstraintIndex::Cint
end

function spPathConstraintPositionTimeline_create(framesCount)
    ccall((:spPathConstraintPositionTimeline_create, libspine), Ptr{spPathConstraintPositionTimeline}, (Cint,), framesCount)
end

function spPathConstraintPositionTimeline_setFrame(self, frameIndex, time, value)
    ccall((:spPathConstraintPositionTimeline_setFrame, libspine), Cvoid, (Ptr{spPathConstraintPositionTimeline}, Cint, Cfloat, Cfloat), self, frameIndex, time, value)
end

struct spPathConstraintSpacingTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    pathConstraintIndex::Cint
end

function spPathConstraintSpacingTimeline_create(framesCount)
    ccall((:spPathConstraintSpacingTimeline_create, libspine), Ptr{spPathConstraintSpacingTimeline}, (Cint,), framesCount)
end

function spPathConstraintSpacingTimeline_setFrame(self, frameIndex, time, value)
    ccall((:spPathConstraintSpacingTimeline_setFrame, libspine), Cvoid, (Ptr{spPathConstraintSpacingTimeline}, Cint, Cfloat, Cfloat), self, frameIndex, time, value)
end

struct spPathConstraintMixTimeline
    super::spCurveTimeline
    framesCount::Cint
    frames::Ptr{Cfloat}
    pathConstraintIndex::Cint
end

function spPathConstraintMixTimeline_create(framesCount)
    ccall((:spPathConstraintMixTimeline_create, libspine), Ptr{spPathConstraintMixTimeline}, (Cint,), framesCount)
end

function spPathConstraintMixTimeline_setFrame(self, frameIndex, time, rotateMix, translateMix)
    ccall((:spPathConstraintMixTimeline_setFrame, libspine), Cvoid, (Ptr{spPathConstraintMixTimeline}, Cint, Cfloat, Cfloat, Cfloat), self, frameIndex, time, rotateMix, translateMix)
end

@cenum spEventType::UInt32 begin
    SP_ANIMATION_START = 0
    SP_ANIMATION_INTERRUPT = 1
    SP_ANIMATION_END = 2
    SP_ANIMATION_COMPLETE = 3
    SP_ANIMATION_DISPOSE = 4
    SP_ANIMATION_EVENT = 5
end

struct spSkeletonData
    version::Ptr{Cchar}
    hash::Ptr{Cchar}
    x::Cfloat
    y::Cfloat
    width::Cfloat
    height::Cfloat
    stringsCount::Cint
    strings::Ptr{Ptr{Cchar}}
    bonesCount::Cint
    bones::Ptr{Ptr{spBoneData}}
    slotsCount::Cint
    slots::Ptr{Ptr{spSlotData}}
    skinsCount::Cint
    skins::Ptr{Ptr{spSkin}}
    defaultSkin::Ptr{spSkin}
    eventsCount::Cint
    events::Ptr{Ptr{spEventData}}
    animationsCount::Cint
    animations::Ptr{Ptr{spAnimation}}
    ikConstraintsCount::Cint
    ikConstraints::Ptr{Ptr{spIkConstraintData}}
    transformConstraintsCount::Cint
    transformConstraints::Ptr{Ptr{spTransformConstraintData}}
    pathConstraintsCount::Cint
    pathConstraints::Ptr{Ptr{spPathConstraintData}}
end

struct spAnimationStateData
    skeletonData::Ptr{spSkeletonData}
    defaultMix::Cfloat
    entries::Ptr{Cvoid}
end

# typedef void ( * spAnimationStateListener ) ( spAnimationState * state , spEventType type , spTrackEntry * entry , spEvent * event )
const spAnimationStateListener = Ptr{Cvoid}

struct spAnimationState
    data::Ptr{spAnimationStateData}
    tracksCount::Cint
    tracks::Ptr{Ptr{Cvoid}} # tracks::Ptr{Ptr{spTrackEntry}}
    listener::spAnimationStateListener
    timeScale::Cfloat
    rendererObject::Ptr{Cvoid}
    userData::Ptr{Cvoid}
    unkeyedState::Cint
end

function Base.getproperty(x::spAnimationState, f::Symbol)
    f === :tracks && return Ptr{Ptr{spTrackEntry}}(getfield(x, f))
    return getfield(x, f)
end

struct spIntArray
    size::Cint
    capacity::Cint
    items::Ptr{Cint}
end

struct spTrackEntry
    animation::Ptr{spAnimation}
    next::Ptr{spTrackEntry}
    mixingFrom::Ptr{spTrackEntry}
    mixingTo::Ptr{spTrackEntry}
    listener::spAnimationStateListener
    trackIndex::Cint
    loop::Cint
    holdPrevious::Cint
    eventThreshold::Cfloat
    attachmentThreshold::Cfloat
    drawOrderThreshold::Cfloat
    animationStart::Cfloat
    animationEnd::Cfloat
    animationLast::Cfloat
    nextAnimationLast::Cfloat
    delay::Cfloat
    trackTime::Cfloat
    trackLast::Cfloat
    nextTrackLast::Cfloat
    trackEnd::Cfloat
    timeScale::Cfloat
    alpha::Cfloat
    mixTime::Cfloat
    mixDuration::Cfloat
    interruptAlpha::Cfloat
    totalAlpha::Cfloat
    mixBlend::spMixBlend
    timelineMode::Ptr{spIntArray}
    timelineHoldMix::Ptr{Cvoid} # timelineHoldMix::Ptr{spTrackEntryArray}
    timelinesRotation::Ptr{Cfloat}
    timelinesRotationCount::Cint
    rendererObject::Ptr{Cvoid}
    userData::Ptr{Cvoid}
end

function Base.getproperty(x::spTrackEntry, f::Symbol)
    f === :timelineHoldMix && return Ptr{spTrackEntryArray}(getfield(x, f))
    return getfield(x, f)
end

struct spTrackEntryArray
    size::Cint
    capacity::Cint
    items::Ptr{Ptr{spTrackEntry}}
end

function spTrackEntryArray_create(initialCapacity)
    ccall((:spTrackEntryArray_create, libspine), Ptr{spTrackEntryArray}, (Cint,), initialCapacity)
end

function spTrackEntryArray_dispose(self)
    ccall((:spTrackEntryArray_dispose, libspine), Cvoid, (Ptr{spTrackEntryArray},), self)
end

function spTrackEntryArray_clear(self)
    ccall((:spTrackEntryArray_clear, libspine), Cvoid, (Ptr{spTrackEntryArray},), self)
end

function spTrackEntryArray_setSize(self, newSize)
    ccall((:spTrackEntryArray_setSize, libspine), Ptr{spTrackEntryArray}, (Ptr{spTrackEntryArray}, Cint), self, newSize)
end

function spTrackEntryArray_ensureCapacity(self, newCapacity)
    ccall((:spTrackEntryArray_ensureCapacity, libspine), Cvoid, (Ptr{spTrackEntryArray}, Cint), self, newCapacity)
end

function spTrackEntryArray_add(self, value)
    ccall((:spTrackEntryArray_add, libspine), Cvoid, (Ptr{spTrackEntryArray}, Ptr{spTrackEntry}), self, value)
end

function spTrackEntryArray_addAll(self, other)
    ccall((:spTrackEntryArray_addAll, libspine), Cvoid, (Ptr{spTrackEntryArray}, Ptr{spTrackEntryArray}), self, other)
end

function spTrackEntryArray_addAllValues(self, values, offset, count)
    ccall((:spTrackEntryArray_addAllValues, libspine), Cvoid, (Ptr{spTrackEntryArray}, Ptr{Ptr{spTrackEntry}}, Cint, Cint), self, values, offset, count)
end

function spTrackEntryArray_removeAt(self, index)
    ccall((:spTrackEntryArray_removeAt, libspine), Cvoid, (Ptr{spTrackEntryArray}, Cint), self, index)
end

function spTrackEntryArray_contains(self, value)
    ccall((:spTrackEntryArray_contains, libspine), Cint, (Ptr{spTrackEntryArray}, Ptr{spTrackEntry}), self, value)
end

function spTrackEntryArray_pop(self)
    ccall((:spTrackEntryArray_pop, libspine), Ptr{spTrackEntry}, (Ptr{spTrackEntryArray},), self)
end

function spTrackEntryArray_peek(self)
    ccall((:spTrackEntryArray_peek, libspine), Ptr{spTrackEntry}, (Ptr{spTrackEntryArray},), self)
end

function spAnimationState_create(data)
    ccall((:spAnimationState_create, libspine), Ptr{spAnimationState}, (Ptr{spAnimationStateData},), data)
end

function spAnimationState_dispose(self)
    ccall((:spAnimationState_dispose, libspine), Cvoid, (Ptr{spAnimationState},), self)
end

function spAnimationState_update(self, delta)
    ccall((:spAnimationState_update, libspine), Cvoid, (Ptr{spAnimationState}, Cfloat), self, delta)
end

function spAnimationState_apply(self, skeleton)
    ccall((:spAnimationState_apply, libspine), Cint, (Ptr{spAnimationState}, Ptr{spSkeleton}), self, skeleton)
end

function spAnimationState_clearTracks(self)
    ccall((:spAnimationState_clearTracks, libspine), Cvoid, (Ptr{spAnimationState},), self)
end

function spAnimationState_clearTrack(self, trackIndex)
    ccall((:spAnimationState_clearTrack, libspine), Cvoid, (Ptr{spAnimationState}, Cint), self, trackIndex)
end

function spAnimationState_setAnimationByName(self, trackIndex, animationName, loop)
    ccall((:spAnimationState_setAnimationByName, libspine), Ptr{spTrackEntry}, (Ptr{spAnimationState}, Cint, Ptr{Cchar}, Cint), self, trackIndex, animationName, loop)
end

function spAnimationState_setAnimation(self, trackIndex, animation, loop)
    ccall((:spAnimationState_setAnimation, libspine), Ptr{spTrackEntry}, (Ptr{spAnimationState}, Cint, Ptr{spAnimation}, Cint), self, trackIndex, animation, loop)
end

function spAnimationState_addAnimationByName(self, trackIndex, animationName, loop, delay)
    ccall((:spAnimationState_addAnimationByName, libspine), Ptr{spTrackEntry}, (Ptr{spAnimationState}, Cint, Ptr{Cchar}, Cint, Cfloat), self, trackIndex, animationName, loop, delay)
end

function spAnimationState_addAnimation(self, trackIndex, animation, loop, delay)
    ccall((:spAnimationState_addAnimation, libspine), Ptr{spTrackEntry}, (Ptr{spAnimationState}, Cint, Ptr{spAnimation}, Cint, Cfloat), self, trackIndex, animation, loop, delay)
end

function spAnimationState_setEmptyAnimation(self, trackIndex, mixDuration)
    ccall((:spAnimationState_setEmptyAnimation, libspine), Ptr{spTrackEntry}, (Ptr{spAnimationState}, Cint, Cfloat), self, trackIndex, mixDuration)
end

function spAnimationState_addEmptyAnimation(self, trackIndex, mixDuration, delay)
    ccall((:spAnimationState_addEmptyAnimation, libspine), Ptr{spTrackEntry}, (Ptr{spAnimationState}, Cint, Cfloat, Cfloat), self, trackIndex, mixDuration, delay)
end

function spAnimationState_setEmptyAnimations(self, mixDuration)
    ccall((:spAnimationState_setEmptyAnimations, libspine), Cvoid, (Ptr{spAnimationState}, Cfloat), self, mixDuration)
end

function spAnimationState_getCurrent(self, trackIndex)
    ccall((:spAnimationState_getCurrent, libspine), Ptr{spTrackEntry}, (Ptr{spAnimationState}, Cint), self, trackIndex)
end

function spAnimationState_clearListenerNotifications(self)
    ccall((:spAnimationState_clearListenerNotifications, libspine), Cvoid, (Ptr{spAnimationState},), self)
end

function spTrackEntry_getAnimationTime(entry)
    ccall((:spTrackEntry_getAnimationTime, libspine), Cfloat, (Ptr{spTrackEntry},), entry)
end

# no prototype is found for this function at AnimationState.h:158:13, please use with caution
function spAnimationState_disposeStatics()
    ccall((:spAnimationState_disposeStatics, libspine), Cvoid, ())
end

function spAnimationStateData_create(skeletonData)
    ccall((:spAnimationStateData_create, libspine), Ptr{spAnimationStateData}, (Ptr{spSkeletonData},), skeletonData)
end

function spAnimationStateData_dispose(self)
    ccall((:spAnimationStateData_dispose, libspine), Cvoid, (Ptr{spAnimationStateData},), self)
end

function spAnimationStateData_setMixByName(self, fromName, toName, duration)
    ccall((:spAnimationStateData_setMixByName, libspine), Cvoid, (Ptr{spAnimationStateData}, Ptr{Cchar}, Ptr{Cchar}, Cfloat), self, fromName, toName, duration)
end

function spAnimationStateData_setMix(self, from, to, duration)
    ccall((:spAnimationStateData_setMix, libspine), Cvoid, (Ptr{spAnimationStateData}, Ptr{spAnimation}, Ptr{spAnimation}, Cfloat), self, from, to, duration)
end

function spAnimationStateData_getMix(self, from, to)
    ccall((:spAnimationStateData_getMix, libspine), Cfloat, (Ptr{spAnimationStateData}, Ptr{spAnimation}, Ptr{spAnimation}), self, from, to)
end

struct spFloatArray
    size::Cint
    capacity::Cint
    items::Ptr{Cfloat}
end

function spFloatArray_create(initialCapacity)
    ccall((:spFloatArray_create, libspine), Ptr{spFloatArray}, (Cint,), initialCapacity)
end

function spFloatArray_dispose(self)
    ccall((:spFloatArray_dispose, libspine), Cvoid, (Ptr{spFloatArray},), self)
end

function spFloatArray_clear(self)
    ccall((:spFloatArray_clear, libspine), Cvoid, (Ptr{spFloatArray},), self)
end

function spFloatArray_setSize(self, newSize)
    ccall((:spFloatArray_setSize, libspine), Ptr{spFloatArray}, (Ptr{spFloatArray}, Cint), self, newSize)
end

function spFloatArray_ensureCapacity(self, newCapacity)
    ccall((:spFloatArray_ensureCapacity, libspine), Cvoid, (Ptr{spFloatArray}, Cint), self, newCapacity)
end

function spFloatArray_add(self, value)
    ccall((:spFloatArray_add, libspine), Cvoid, (Ptr{spFloatArray}, Cfloat), self, value)
end

function spFloatArray_addAll(self, other)
    ccall((:spFloatArray_addAll, libspine), Cvoid, (Ptr{spFloatArray}, Ptr{spFloatArray}), self, other)
end

function spFloatArray_addAllValues(self, values, offset, count)
    ccall((:spFloatArray_addAllValues, libspine), Cvoid, (Ptr{spFloatArray}, Ptr{Cfloat}, Cint, Cint), self, values, offset, count)
end

function spFloatArray_removeAt(self, index)
    ccall((:spFloatArray_removeAt, libspine), Cvoid, (Ptr{spFloatArray}, Cint), self, index)
end

function spFloatArray_contains(self, value)
    ccall((:spFloatArray_contains, libspine), Cint, (Ptr{spFloatArray}, Cfloat), self, value)
end

function spFloatArray_pop(self)
    ccall((:spFloatArray_pop, libspine), Cfloat, (Ptr{spFloatArray},), self)
end

function spFloatArray_peek(self)
    ccall((:spFloatArray_peek, libspine), Cfloat, (Ptr{spFloatArray},), self)
end

function spIntArray_create(initialCapacity)
    ccall((:spIntArray_create, libspine), Ptr{spIntArray}, (Cint,), initialCapacity)
end

function spIntArray_dispose(self)
    ccall((:spIntArray_dispose, libspine), Cvoid, (Ptr{spIntArray},), self)
end

function spIntArray_clear(self)
    ccall((:spIntArray_clear, libspine), Cvoid, (Ptr{spIntArray},), self)
end

function spIntArray_setSize(self, newSize)
    ccall((:spIntArray_setSize, libspine), Ptr{spIntArray}, (Ptr{spIntArray}, Cint), self, newSize)
end

function spIntArray_ensureCapacity(self, newCapacity)
    ccall((:spIntArray_ensureCapacity, libspine), Cvoid, (Ptr{spIntArray}, Cint), self, newCapacity)
end

function spIntArray_add(self, value)
    ccall((:spIntArray_add, libspine), Cvoid, (Ptr{spIntArray}, Cint), self, value)
end

function spIntArray_addAll(self, other)
    ccall((:spIntArray_addAll, libspine), Cvoid, (Ptr{spIntArray}, Ptr{spIntArray}), self, other)
end

function spIntArray_addAllValues(self, values, offset, count)
    ccall((:spIntArray_addAllValues, libspine), Cvoid, (Ptr{spIntArray}, Ptr{Cint}, Cint, Cint), self, values, offset, count)
end

function spIntArray_removeAt(self, index)
    ccall((:spIntArray_removeAt, libspine), Cvoid, (Ptr{spIntArray}, Cint), self, index)
end

function spIntArray_contains(self, value)
    ccall((:spIntArray_contains, libspine), Cint, (Ptr{spIntArray}, Cint), self, value)
end

function spIntArray_pop(self)
    ccall((:spIntArray_pop, libspine), Cint, (Ptr{spIntArray},), self)
end

function spIntArray_peek(self)
    ccall((:spIntArray_peek, libspine), Cint, (Ptr{spIntArray},), self)
end

struct spShortArray
    size::Cint
    capacity::Cint
    items::Ptr{Cshort}
end

function spShortArray_create(initialCapacity)
    ccall((:spShortArray_create, libspine), Ptr{spShortArray}, (Cint,), initialCapacity)
end

function spShortArray_dispose(self)
    ccall((:spShortArray_dispose, libspine), Cvoid, (Ptr{spShortArray},), self)
end

function spShortArray_clear(self)
    ccall((:spShortArray_clear, libspine), Cvoid, (Ptr{spShortArray},), self)
end

function spShortArray_setSize(self, newSize)
    ccall((:spShortArray_setSize, libspine), Ptr{spShortArray}, (Ptr{spShortArray}, Cint), self, newSize)
end

function spShortArray_ensureCapacity(self, newCapacity)
    ccall((:spShortArray_ensureCapacity, libspine), Cvoid, (Ptr{spShortArray}, Cint), self, newCapacity)
end

function spShortArray_add(self, value)
    ccall((:spShortArray_add, libspine), Cvoid, (Ptr{spShortArray}, Cshort), self, value)
end

function spShortArray_addAll(self, other)
    ccall((:spShortArray_addAll, libspine), Cvoid, (Ptr{spShortArray}, Ptr{spShortArray}), self, other)
end

function spShortArray_addAllValues(self, values, offset, count)
    ccall((:spShortArray_addAllValues, libspine), Cvoid, (Ptr{spShortArray}, Ptr{Cshort}, Cint, Cint), self, values, offset, count)
end

function spShortArray_removeAt(self, index)
    ccall((:spShortArray_removeAt, libspine), Cvoid, (Ptr{spShortArray}, Cint), self, index)
end

function spShortArray_contains(self, value)
    ccall((:spShortArray_contains, libspine), Cint, (Ptr{spShortArray}, Cshort), self, value)
end

function spShortArray_pop(self)
    ccall((:spShortArray_pop, libspine), Cshort, (Ptr{spShortArray},), self)
end

function spShortArray_peek(self)
    ccall((:spShortArray_peek, libspine), Cshort, (Ptr{spShortArray},), self)
end

struct spUnsignedShortArray
    size::Cint
    capacity::Cint
    items::Ptr{Cushort}
end

function spUnsignedShortArray_create(initialCapacity)
    ccall((:spUnsignedShortArray_create, libspine), Ptr{spUnsignedShortArray}, (Cint,), initialCapacity)
end

function spUnsignedShortArray_dispose(self)
    ccall((:spUnsignedShortArray_dispose, libspine), Cvoid, (Ptr{spUnsignedShortArray},), self)
end

function spUnsignedShortArray_clear(self)
    ccall((:spUnsignedShortArray_clear, libspine), Cvoid, (Ptr{spUnsignedShortArray},), self)
end

function spUnsignedShortArray_setSize(self, newSize)
    ccall((:spUnsignedShortArray_setSize, libspine), Ptr{spUnsignedShortArray}, (Ptr{spUnsignedShortArray}, Cint), self, newSize)
end

function spUnsignedShortArray_ensureCapacity(self, newCapacity)
    ccall((:spUnsignedShortArray_ensureCapacity, libspine), Cvoid, (Ptr{spUnsignedShortArray}, Cint), self, newCapacity)
end

function spUnsignedShortArray_add(self, value)
    ccall((:spUnsignedShortArray_add, libspine), Cvoid, (Ptr{spUnsignedShortArray}, Cushort), self, value)
end

function spUnsignedShortArray_addAll(self, other)
    ccall((:spUnsignedShortArray_addAll, libspine), Cvoid, (Ptr{spUnsignedShortArray}, Ptr{spUnsignedShortArray}), self, other)
end

function spUnsignedShortArray_addAllValues(self, values, offset, count)
    ccall((:spUnsignedShortArray_addAllValues, libspine), Cvoid, (Ptr{spUnsignedShortArray}, Ptr{Cushort}, Cint, Cint), self, values, offset, count)
end

function spUnsignedShortArray_removeAt(self, index)
    ccall((:spUnsignedShortArray_removeAt, libspine), Cvoid, (Ptr{spUnsignedShortArray}, Cint), self, index)
end

function spUnsignedShortArray_contains(self, value)
    ccall((:spUnsignedShortArray_contains, libspine), Cint, (Ptr{spUnsignedShortArray}, Cushort), self, value)
end

function spUnsignedShortArray_pop(self)
    ccall((:spUnsignedShortArray_pop, libspine), Cushort, (Ptr{spUnsignedShortArray},), self)
end

function spUnsignedShortArray_peek(self)
    ccall((:spUnsignedShortArray_peek, libspine), Cushort, (Ptr{spUnsignedShortArray},), self)
end

struct spArrayFloatArray
    size::Cint
    capacity::Cint
    items::Ptr{Ptr{spFloatArray}}
end

function spArrayFloatArray_create(initialCapacity)
    ccall((:spArrayFloatArray_create, libspine), Ptr{spArrayFloatArray}, (Cint,), initialCapacity)
end

function spArrayFloatArray_dispose(self)
    ccall((:spArrayFloatArray_dispose, libspine), Cvoid, (Ptr{spArrayFloatArray},), self)
end

function spArrayFloatArray_clear(self)
    ccall((:spArrayFloatArray_clear, libspine), Cvoid, (Ptr{spArrayFloatArray},), self)
end

function spArrayFloatArray_setSize(self, newSize)
    ccall((:spArrayFloatArray_setSize, libspine), Ptr{spArrayFloatArray}, (Ptr{spArrayFloatArray}, Cint), self, newSize)
end

function spArrayFloatArray_ensureCapacity(self, newCapacity)
    ccall((:spArrayFloatArray_ensureCapacity, libspine), Cvoid, (Ptr{spArrayFloatArray}, Cint), self, newCapacity)
end

function spArrayFloatArray_add(self, value)
    ccall((:spArrayFloatArray_add, libspine), Cvoid, (Ptr{spArrayFloatArray}, Ptr{spFloatArray}), self, value)
end

function spArrayFloatArray_addAll(self, other)
    ccall((:spArrayFloatArray_addAll, libspine), Cvoid, (Ptr{spArrayFloatArray}, Ptr{spArrayFloatArray}), self, other)
end

function spArrayFloatArray_addAllValues(self, values, offset, count)
    ccall((:spArrayFloatArray_addAllValues, libspine), Cvoid, (Ptr{spArrayFloatArray}, Ptr{Ptr{spFloatArray}}, Cint, Cint), self, values, offset, count)
end

function spArrayFloatArray_removeAt(self, index)
    ccall((:spArrayFloatArray_removeAt, libspine), Cvoid, (Ptr{spArrayFloatArray}, Cint), self, index)
end

function spArrayFloatArray_contains(self, value)
    ccall((:spArrayFloatArray_contains, libspine), Cint, (Ptr{spArrayFloatArray}, Ptr{spFloatArray}), self, value)
end

function spArrayFloatArray_pop(self)
    ccall((:spArrayFloatArray_pop, libspine), Ptr{spFloatArray}, (Ptr{spArrayFloatArray},), self)
end

function spArrayFloatArray_peek(self)
    ccall((:spArrayFloatArray_peek, libspine), Ptr{spFloatArray}, (Ptr{spArrayFloatArray},), self)
end

struct spArrayShortArray
    size::Cint
    capacity::Cint
    items::Ptr{Ptr{spShortArray}}
end

function spArrayShortArray_create(initialCapacity)
    ccall((:spArrayShortArray_create, libspine), Ptr{spArrayShortArray}, (Cint,), initialCapacity)
end

function spArrayShortArray_dispose(self)
    ccall((:spArrayShortArray_dispose, libspine), Cvoid, (Ptr{spArrayShortArray},), self)
end

function spArrayShortArray_clear(self)
    ccall((:spArrayShortArray_clear, libspine), Cvoid, (Ptr{spArrayShortArray},), self)
end

function spArrayShortArray_setSize(self, newSize)
    ccall((:spArrayShortArray_setSize, libspine), Ptr{spArrayShortArray}, (Ptr{spArrayShortArray}, Cint), self, newSize)
end

function spArrayShortArray_ensureCapacity(self, newCapacity)
    ccall((:spArrayShortArray_ensureCapacity, libspine), Cvoid, (Ptr{spArrayShortArray}, Cint), self, newCapacity)
end

function spArrayShortArray_add(self, value)
    ccall((:spArrayShortArray_add, libspine), Cvoid, (Ptr{spArrayShortArray}, Ptr{spShortArray}), self, value)
end

function spArrayShortArray_addAll(self, other)
    ccall((:spArrayShortArray_addAll, libspine), Cvoid, (Ptr{spArrayShortArray}, Ptr{spArrayShortArray}), self, other)
end

function spArrayShortArray_addAllValues(self, values, offset, count)
    ccall((:spArrayShortArray_addAllValues, libspine), Cvoid, (Ptr{spArrayShortArray}, Ptr{Ptr{spShortArray}}, Cint, Cint), self, values, offset, count)
end

function spArrayShortArray_removeAt(self, index)
    ccall((:spArrayShortArray_removeAt, libspine), Cvoid, (Ptr{spArrayShortArray}, Cint), self, index)
end

function spArrayShortArray_contains(self, value)
    ccall((:spArrayShortArray_contains, libspine), Cint, (Ptr{spArrayShortArray}, Ptr{spShortArray}), self, value)
end

function spArrayShortArray_pop(self)
    ccall((:spArrayShortArray_pop, libspine), Ptr{spShortArray}, (Ptr{spArrayShortArray},), self)
end

function spArrayShortArray_peek(self)
    ccall((:spArrayShortArray_peek, libspine), Ptr{spShortArray}, (Ptr{spArrayShortArray},), self)
end

struct spAtlas
    pages::Ptr{Cvoid} # pages::Ptr{spAtlasPage}
    regions::Ptr{Cvoid} # regions::Ptr{spAtlasRegion}
    rendererObject::Ptr{Cvoid}
end

function Base.getproperty(x::spAtlas, f::Symbol)
    f === :pages && return Ptr{spAtlasPage}(getfield(x, f))
    f === :regions && return Ptr{spAtlasRegion}(getfield(x, f))
    return getfield(x, f)
end

@cenum spAtlasFormat::UInt32 begin
    SP_ATLAS_UNKNOWN_FORMAT = 0
    SP_ATLAS_ALPHA = 1
    SP_ATLAS_INTENSITY = 2
    SP_ATLAS_LUMINANCE_ALPHA = 3
    SP_ATLAS_RGB565 = 4
    SP_ATLAS_RGBA4444 = 5
    SP_ATLAS_RGB888 = 6
    SP_ATLAS_RGBA8888 = 7
end

@cenum spAtlasFilter::UInt32 begin
    SP_ATLAS_UNKNOWN_FILTER = 0
    SP_ATLAS_NEAREST = 1
    SP_ATLAS_LINEAR = 2
    SP_ATLAS_MIPMAP = 3
    SP_ATLAS_MIPMAP_NEAREST_NEAREST = 4
    SP_ATLAS_MIPMAP_LINEAR_NEAREST = 5
    SP_ATLAS_MIPMAP_NEAREST_LINEAR = 6
    SP_ATLAS_MIPMAP_LINEAR_LINEAR = 7
end

@cenum spAtlasWrap::UInt32 begin
    SP_ATLAS_MIRROREDREPEAT = 0
    SP_ATLAS_CLAMPTOEDGE = 1
    SP_ATLAS_REPEAT = 2
end

struct spAtlasPage
    atlas::Ptr{spAtlas}
    name::Ptr{Cchar}
    format::spAtlasFormat
    minFilter::spAtlasFilter
    magFilter::spAtlasFilter
    uWrap::spAtlasWrap
    vWrap::spAtlasWrap
    rendererObject::Ptr{Cvoid}
    width::Cint
    height::Cint
    next::Ptr{spAtlasPage}
end

function spAtlasPage_create(atlas, name)
    ccall((:spAtlasPage_create, libspine), Ptr{spAtlasPage}, (Ptr{spAtlas}, Ptr{Cchar}), atlas, name)
end

function spAtlasPage_dispose(self)
    ccall((:spAtlasPage_dispose, libspine), Cvoid, (Ptr{spAtlasPage},), self)
end

struct spAtlasRegion
    name::Ptr{Cchar}
    x::Cint
    y::Cint
    width::Cint
    height::Cint
    u::Cfloat
    v::Cfloat
    u2::Cfloat
    v2::Cfloat
    offsetX::Cint
    offsetY::Cint
    originalWidth::Cint
    originalHeight::Cint
    index::Cint
    rotate::Cint
    degrees::Cint
    flip::Cint
    splits::Ptr{Cint}
    pads::Ptr{Cint}
    page::Ptr{spAtlasPage}
    next::Ptr{spAtlasRegion}
end

# no prototype is found for this function at Atlas.h:135:23, please use with caution
function spAtlasRegion_create()
    ccall((:spAtlasRegion_create, libspine), Ptr{spAtlasRegion}, ())
end

function spAtlasRegion_dispose(self)
    ccall((:spAtlasRegion_dispose, libspine), Cvoid, (Ptr{spAtlasRegion},), self)
end

function spAtlas_create(data, length, dir, rendererObject)
    ccall((:spAtlas_create, libspine), Ptr{spAtlas}, (Ptr{Cchar}, Cint, Ptr{Cchar}, Ptr{Cvoid}), data, length, dir, rendererObject)
end

function spAtlas_createFromFile(path, rendererObject)
    ccall((:spAtlas_createFromFile, libspine), Ptr{spAtlas}, (Ptr{Cchar}, Ptr{Cvoid}), path, rendererObject)
end

function spAtlas_dispose(atlas)
    ccall((:spAtlas_dispose, libspine), Cvoid, (Ptr{spAtlas},), atlas)
end

function spAtlas_findRegion(self, name)
    ccall((:spAtlas_findRegion, libspine), Ptr{spAtlasRegion}, (Ptr{spAtlas}, Ptr{Cchar}), self, name)
end

struct spAtlasAttachmentLoader
    super::spAttachmentLoader
    atlas::Ptr{spAtlas}
end

function spAtlasAttachmentLoader_create(atlas)
    ccall((:spAtlasAttachmentLoader_create, libspine), Ptr{spAtlasAttachmentLoader}, (Ptr{spAtlas},), atlas)
end

function spAttachment_dispose(self)
    ccall((:spAttachment_dispose, libspine), Cvoid, (Ptr{spAttachment},), self)
end

function spAttachment_copy(self)
    ccall((:spAttachment_copy, libspine), Ptr{spAttachment}, (Ptr{spAttachment},), self)
end

function spAttachmentLoader_dispose(self)
    ccall((:spAttachmentLoader_dispose, libspine), Cvoid, (Ptr{spAttachmentLoader},), self)
end

function spAttachmentLoader_createAttachment(self, skin, type, name, path)
    ccall((:spAttachmentLoader_createAttachment, libspine), Ptr{spAttachment}, (Ptr{spAttachmentLoader}, Ptr{spSkin}, spAttachmentType, Ptr{Cchar}, Ptr{Cchar}), self, skin, type, name, path)
end

function spAttachmentLoader_configureAttachment(self, attachment)
    ccall((:spAttachmentLoader_configureAttachment, libspine), Cvoid, (Ptr{spAttachmentLoader}, Ptr{spAttachment}), self, attachment)
end

function spAttachmentLoader_disposeAttachment(self, attachment)
    ccall((:spAttachmentLoader_disposeAttachment, libspine), Cvoid, (Ptr{spAttachmentLoader}, Ptr{spAttachment}), self, attachment)
end

function spBone_setYDown(yDown)
    ccall((:spBone_setYDown, libspine), Cvoid, (Cint,), yDown)
end

# no prototype is found for this function at Bone.h:78:19, please use with caution
function spBone_isYDown()
    ccall((:spBone_isYDown, libspine), Cint, ())
end

function spBone_create(data, skeleton, parent)
    ccall((:spBone_create, libspine), Ptr{spBone}, (Ptr{spBoneData}, Ptr{spSkeleton}, Ptr{spBone}), data, skeleton, parent)
end

function spBone_dispose(self)
    ccall((:spBone_dispose, libspine), Cvoid, (Ptr{spBone},), self)
end

function spBone_setToSetupPose(self)
    ccall((:spBone_setToSetupPose, libspine), Cvoid, (Ptr{spBone},), self)
end

function spBone_updateWorldTransform(self)
    ccall((:spBone_updateWorldTransform, libspine), Cvoid, (Ptr{spBone},), self)
end

function spBone_updateWorldTransformWith(self, x, y, rotation, scaleX, scaleY, shearX, shearY)
    ccall((:spBone_updateWorldTransformWith, libspine), Cvoid, (Ptr{spBone}, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), self, x, y, rotation, scaleX, scaleY, shearX, shearY)
end

function spBone_getWorldRotationX(self)
    ccall((:spBone_getWorldRotationX, libspine), Cfloat, (Ptr{spBone},), self)
end

function spBone_getWorldRotationY(self)
    ccall((:spBone_getWorldRotationY, libspine), Cfloat, (Ptr{spBone},), self)
end

function spBone_getWorldScaleX(self)
    ccall((:spBone_getWorldScaleX, libspine), Cfloat, (Ptr{spBone},), self)
end

function spBone_getWorldScaleY(self)
    ccall((:spBone_getWorldScaleY, libspine), Cfloat, (Ptr{spBone},), self)
end

function spBone_updateAppliedTransform(self)
    ccall((:spBone_updateAppliedTransform, libspine), Cvoid, (Ptr{spBone},), self)
end

function spBone_worldToLocal(self, worldX, worldY, localX, localY)
    ccall((:spBone_worldToLocal, libspine), Cvoid, (Ptr{spBone}, Cfloat, Cfloat, Ptr{Cfloat}, Ptr{Cfloat}), self, worldX, worldY, localX, localY)
end

function spBone_localToWorld(self, localX, localY, worldX, worldY)
    ccall((:spBone_localToWorld, libspine), Cvoid, (Ptr{spBone}, Cfloat, Cfloat, Ptr{Cfloat}, Ptr{Cfloat}), self, localX, localY, worldX, worldY)
end

function spBone_worldToLocalRotation(self, worldRotation)
    ccall((:spBone_worldToLocalRotation, libspine), Cfloat, (Ptr{spBone}, Cfloat), self, worldRotation)
end

function spBone_localToWorldRotation(self, localRotation)
    ccall((:spBone_localToWorldRotation, libspine), Cfloat, (Ptr{spBone}, Cfloat), self, localRotation)
end

function spBone_rotateWorld(self, degrees)
    ccall((:spBone_rotateWorld, libspine), Cvoid, (Ptr{spBone}, Cfloat), self, degrees)
end

function spBoneData_create(index, name, parent)
    ccall((:spBoneData_create, libspine), Ptr{spBoneData}, (Cint, Ptr{Cchar}, Ptr{spBoneData}), index, name, parent)
end

function spBoneData_dispose(self)
    ccall((:spBoneData_dispose, libspine), Cvoid, (Ptr{spBoneData},), self)
end

struct spVertexAttachment
    super::spAttachment
    bonesCount::Cint
    bones::Ptr{Cint}
    verticesCount::Cint
    vertices::Ptr{Cfloat}
    worldVerticesLength::Cint
    deformAttachment::Ptr{spVertexAttachment}
    id::Cint
end

struct spBoundingBoxAttachment
    super::spVertexAttachment
end

struct spClippingAttachment
    super::spVertexAttachment
    endSlot::Ptr{spSlotData}
end

function spBoundingBoxAttachment_create(name)
    ccall((:spBoundingBoxAttachment_create, libspine), Ptr{spBoundingBoxAttachment}, (Ptr{Cchar},), name)
end

function _spClippingAttachment_dispose(self)
    ccall((:_spClippingAttachment_dispose, libspine), Cvoid, (Ptr{spAttachment},), self)
end

function spClippingAttachment_create(name)
    ccall((:spClippingAttachment_create, libspine), Ptr{spClippingAttachment}, (Ptr{Cchar},), name)
end

# no prototype is found for this function at Color.h:54:17, please use with caution
function spColor_create()
    ccall((:spColor_create, libspine), Ptr{spColor}, ())
end

function spColor_dispose(self)
    ccall((:spColor_dispose, libspine), Cvoid, (Ptr{spColor},), self)
end

function spColor_setFromFloats(color, r, g, b, a)
    ccall((:spColor_setFromFloats, libspine), Cvoid, (Ptr{spColor}, Cfloat, Cfloat, Cfloat, Cfloat), color, r, g, b, a)
end

function spColor_setFromColor(color, otherColor)
    ccall((:spColor_setFromColor, libspine), Cvoid, (Ptr{spColor}, Ptr{spColor}), color, otherColor)
end

function spColor_addFloats(color, r, g, b, a)
    ccall((:spColor_addFloats, libspine), Cvoid, (Ptr{spColor}, Cfloat, Cfloat, Cfloat, Cfloat), color, r, g, b, a)
end

function spColor_addColor(color, otherColor)
    ccall((:spColor_addColor, libspine), Cvoid, (Ptr{spColor}, Ptr{spColor}), color, otherColor)
end

function spColor_clamp(color)
    ccall((:spColor_clamp, libspine), Cvoid, (Ptr{spColor},), color)
end

function spEvent_create(time, data)
    ccall((:spEvent_create, libspine), Ptr{spEvent}, (Cfloat, Ptr{spEventData}), time, data)
end

function spEvent_dispose(self)
    ccall((:spEvent_dispose, libspine), Cvoid, (Ptr{spEvent},), self)
end

function spEventData_create(name)
    ccall((:spEventData_create, libspine), Ptr{spEventData}, (Ptr{Cchar},), name)
end

function spEventData_dispose(self)
    ccall((:spEventData_dispose, libspine), Cvoid, (Ptr{spEventData},), self)
end

function spIkConstraint_create(data, skeleton)
    ccall((:spIkConstraint_create, libspine), Ptr{spIkConstraint}, (Ptr{spIkConstraintData}, Ptr{spSkeleton}), data, skeleton)
end

function spIkConstraint_dispose(self)
    ccall((:spIkConstraint_dispose, libspine), Cvoid, (Ptr{spIkConstraint},), self)
end

function spIkConstraint_apply(self)
    ccall((:spIkConstraint_apply, libspine), Cvoid, (Ptr{spIkConstraint},), self)
end

function spIkConstraint_apply1(bone, targetX, targetY, compress, stretch, uniform, alpha)
    ccall((:spIkConstraint_apply1, libspine), Cvoid, (Ptr{spBone}, Cfloat, Cfloat, Cint, Cint, Cint, Cfloat), bone, targetX, targetY, compress, stretch, uniform, alpha)
end

function spIkConstraint_apply2(parent, child, targetX, targetY, bendDirection, stretch, softness, alpha)
    ccall((:spIkConstraint_apply2, libspine), Cvoid, (Ptr{spBone}, Ptr{spBone}, Cfloat, Cfloat, Cint, Cint, Cfloat, Cfloat), parent, child, targetX, targetY, bendDirection, stretch, softness, alpha)
end

function spIkConstraintData_create(name)
    ccall((:spIkConstraintData_create, libspine), Ptr{spIkConstraintData}, (Ptr{Cchar},), name)
end

function spIkConstraintData_dispose(self)
    ccall((:spIkConstraintData_dispose, libspine), Cvoid, (Ptr{spIkConstraintData},), self)
end

struct spMeshAttachment
    super::spVertexAttachment
    rendererObject::Ptr{Cvoid}
    regionOffsetX::Cint
    regionOffsetY::Cint
    regionWidth::Cint
    regionHeight::Cint
    regionOriginalWidth::Cint
    regionOriginalHeight::Cint
    regionU::Cfloat
    regionV::Cfloat
    regionU2::Cfloat
    regionV2::Cfloat
    regionRotate::Cint
    regionDegrees::Cint
    path::Ptr{Cchar}
    regionUVs::Ptr{Cfloat}
    uvs::Ptr{Cfloat}
    trianglesCount::Cint
    triangles::Ptr{Cushort}
    color::spColor
    hullLength::Cint
    parentMesh::Ptr{spMeshAttachment}
    edgesCount::Cint
    edges::Ptr{Cint}
    width::Cfloat
    height::Cfloat
end

function spMeshAttachment_create(name)
    ccall((:spMeshAttachment_create, libspine), Ptr{spMeshAttachment}, (Ptr{Cchar},), name)
end

function spMeshAttachment_updateUVs(self)
    ccall((:spMeshAttachment_updateUVs, libspine), Cvoid, (Ptr{spMeshAttachment},), self)
end

function spMeshAttachment_setParentMesh(self, parentMesh)
    ccall((:spMeshAttachment_setParentMesh, libspine), Cvoid, (Ptr{spMeshAttachment}, Ptr{spMeshAttachment}), self, parentMesh)
end

function spMeshAttachment_newLinkedMesh(self)
    ccall((:spMeshAttachment_newLinkedMesh, libspine), Ptr{spMeshAttachment}, (Ptr{spMeshAttachment},), self)
end

struct spPathAttachment
    super::spVertexAttachment
    lengthsLength::Cint
    lengths::Ptr{Cfloat}
    closed::Cint
    constantSpeed::Cint
end

function spPathAttachment_create(name)
    ccall((:spPathAttachment_create, libspine), Ptr{spPathAttachment}, (Ptr{Cchar},), name)
end

function spPathConstraint_create(data, skeleton)
    ccall((:spPathConstraint_create, libspine), Ptr{spPathConstraint}, (Ptr{spPathConstraintData}, Ptr{spSkeleton}), data, skeleton)
end

function spPathConstraint_dispose(self)
    ccall((:spPathConstraint_dispose, libspine), Cvoid, (Ptr{spPathConstraint},), self)
end

function spPathConstraint_apply(self)
    ccall((:spPathConstraint_apply, libspine), Cvoid, (Ptr{spPathConstraint},), self)
end

function spPathConstraint_computeWorldPositions(self, path, spacesCount, tangents, percentPosition, percentSpacing)
    ccall((:spPathConstraint_computeWorldPositions, libspine), Ptr{Cfloat}, (Ptr{spPathConstraint}, Ptr{spPathAttachment}, Cint, Cint, Cint, Cint), self, path, spacesCount, tangents, percentPosition, percentSpacing)
end

function spPathConstraintData_create(name)
    ccall((:spPathConstraintData_create, libspine), Ptr{spPathConstraintData}, (Ptr{Cchar},), name)
end

function spPathConstraintData_dispose(self)
    ccall((:spPathConstraintData_dispose, libspine), Cvoid, (Ptr{spPathConstraintData},), self)
end

struct spPointAttachment
    super::spAttachment
    x::Cfloat
    y::Cfloat
    rotation::Cfloat
    color::spColor
end

function spPointAttachment_create(name)
    ccall((:spPointAttachment_create, libspine), Ptr{spPointAttachment}, (Ptr{Cchar},), name)
end

function spPointAttachment_computeWorldPosition(self, bone, x, y)
    ccall((:spPointAttachment_computeWorldPosition, libspine), Cvoid, (Ptr{spPointAttachment}, Ptr{spBone}, Ptr{Cfloat}, Ptr{Cfloat}), self, bone, x, y)
end

function spPointAttachment_computeWorldRotation(self, bone)
    ccall((:spPointAttachment_computeWorldRotation, libspine), Cfloat, (Ptr{spPointAttachment}, Ptr{spBone}), self, bone)
end

struct spRegionAttachment
    super::spAttachment
    path::Ptr{Cchar}
    x::Cfloat
    y::Cfloat
    scaleX::Cfloat
    scaleY::Cfloat
    rotation::Cfloat
    width::Cfloat
    height::Cfloat
    color::spColor
    rendererObject::Ptr{Cvoid}
    regionOffsetX::Cint
    regionOffsetY::Cint
    regionWidth::Cint
    regionHeight::Cint
    regionOriginalWidth::Cint
    regionOriginalHeight::Cint
    offset::NTuple{8, Cfloat}
    uvs::NTuple{8, Cfloat}
end

function spRegionAttachment_create(name)
    ccall((:spRegionAttachment_create, libspine), Ptr{spRegionAttachment}, (Ptr{Cchar},), name)
end

function spRegionAttachment_setUVs(self, u, v, u2, v2, rotate)
    ccall((:spRegionAttachment_setUVs, libspine), Cvoid, (Ptr{spRegionAttachment}, Cfloat, Cfloat, Cfloat, Cfloat, Cint), self, u, v, u2, v2, rotate)
end

function spRegionAttachment_updateOffset(self)
    ccall((:spRegionAttachment_updateOffset, libspine), Cvoid, (Ptr{spRegionAttachment},), self)
end

function spRegionAttachment_computeWorldVertices(self, bone, vertices, offset, stride)
    ccall((:spRegionAttachment_computeWorldVertices, libspine), Cvoid, (Ptr{spRegionAttachment}, Ptr{spBone}, Ptr{Cfloat}, Cint, Cint), self, bone, vertices, offset, stride)
end

function spSkeleton_create(data)
    ccall((:spSkeleton_create, libspine), Ptr{spSkeleton}, (Ptr{spSkeletonData},), data)
end

function spSkeleton_dispose(self)
    ccall((:spSkeleton_dispose, libspine), Cvoid, (Ptr{spSkeleton},), self)
end

function spSkeleton_updateCache(self)
    ccall((:spSkeleton_updateCache, libspine), Cvoid, (Ptr{spSkeleton},), self)
end

function spSkeleton_updateWorldTransform(self)
    ccall((:spSkeleton_updateWorldTransform, libspine), Cvoid, (Ptr{spSkeleton},), self)
end

function spSkeleton_setToSetupPose(self)
    ccall((:spSkeleton_setToSetupPose, libspine), Cvoid, (Ptr{spSkeleton},), self)
end

function spSkeleton_setBonesToSetupPose(self)
    ccall((:spSkeleton_setBonesToSetupPose, libspine), Cvoid, (Ptr{spSkeleton},), self)
end

function spSkeleton_setSlotsToSetupPose(self)
    ccall((:spSkeleton_setSlotsToSetupPose, libspine), Cvoid, (Ptr{spSkeleton},), self)
end

function spSkeleton_findBone(self, boneName)
    ccall((:spSkeleton_findBone, libspine), Ptr{spBone}, (Ptr{spSkeleton}, Ptr{Cchar}), self, boneName)
end

function spSkeleton_findBoneIndex(self, boneName)
    ccall((:spSkeleton_findBoneIndex, libspine), Cint, (Ptr{spSkeleton}, Ptr{Cchar}), self, boneName)
end

function spSkeleton_findSlot(self, slotName)
    ccall((:spSkeleton_findSlot, libspine), Ptr{spSlot}, (Ptr{spSkeleton}, Ptr{Cchar}), self, slotName)
end

function spSkeleton_findSlotIndex(self, slotName)
    ccall((:spSkeleton_findSlotIndex, libspine), Cint, (Ptr{spSkeleton}, Ptr{Cchar}), self, slotName)
end

function spSkeleton_setSkin(self, skin)
    ccall((:spSkeleton_setSkin, libspine), Cvoid, (Ptr{spSkeleton}, Ptr{spSkin}), self, skin)
end

function spSkeleton_setSkinByName(self, skinName)
    ccall((:spSkeleton_setSkinByName, libspine), Cint, (Ptr{spSkeleton}, Ptr{Cchar}), self, skinName)
end

function spSkeleton_getAttachmentForSlotName(self, slotName, attachmentName)
    ccall((:spSkeleton_getAttachmentForSlotName, libspine), Ptr{spAttachment}, (Ptr{spSkeleton}, Ptr{Cchar}, Ptr{Cchar}), self, slotName, attachmentName)
end

function spSkeleton_getAttachmentForSlotIndex(self, slotIndex, attachmentName)
    ccall((:spSkeleton_getAttachmentForSlotIndex, libspine), Ptr{spAttachment}, (Ptr{spSkeleton}, Cint, Ptr{Cchar}), self, slotIndex, attachmentName)
end

function spSkeleton_setAttachment(self, slotName, attachmentName)
    ccall((:spSkeleton_setAttachment, libspine), Cint, (Ptr{spSkeleton}, Ptr{Cchar}, Ptr{Cchar}), self, slotName, attachmentName)
end

function spSkeleton_findIkConstraint(self, constraintName)
    ccall((:spSkeleton_findIkConstraint, libspine), Ptr{spIkConstraint}, (Ptr{spSkeleton}, Ptr{Cchar}), self, constraintName)
end

function spSkeleton_findTransformConstraint(self, constraintName)
    ccall((:spSkeleton_findTransformConstraint, libspine), Ptr{spTransformConstraint}, (Ptr{spSkeleton}, Ptr{Cchar}), self, constraintName)
end

function spSkeleton_findPathConstraint(self, constraintName)
    ccall((:spSkeleton_findPathConstraint, libspine), Ptr{spPathConstraint}, (Ptr{spSkeleton}, Ptr{Cchar}), self, constraintName)
end

function spSkeleton_update(self, deltaTime)
    ccall((:spSkeleton_update, libspine), Cvoid, (Ptr{spSkeleton}, Cfloat), self, deltaTime)
end

struct spSkeletonBinary
    scale::Cfloat
    attachmentLoader::Ptr{spAttachmentLoader}
    error::Ptr{Cchar}
end

function spSkeletonBinary_createWithLoader(attachmentLoader)
    ccall((:spSkeletonBinary_createWithLoader, libspine), Ptr{spSkeletonBinary}, (Ptr{spAttachmentLoader},), attachmentLoader)
end

function spSkeletonBinary_create(atlas)
    ccall((:spSkeletonBinary_create, libspine), Ptr{spSkeletonBinary}, (Ptr{spAtlas},), atlas)
end

function spSkeletonBinary_dispose(self)
    ccall((:spSkeletonBinary_dispose, libspine), Cvoid, (Ptr{spSkeletonBinary},), self)
end

function spSkeletonBinary_readSkeletonData(self, binary, length)
    ccall((:spSkeletonBinary_readSkeletonData, libspine), Ptr{spSkeletonData}, (Ptr{spSkeletonBinary}, Ptr{Cuchar}, Cint), self, binary, length)
end

function spSkeletonBinary_readSkeletonDataFile(self, path)
    ccall((:spSkeletonBinary_readSkeletonDataFile, libspine), Ptr{spSkeletonData}, (Ptr{spSkeletonBinary}, Ptr{Cchar}), self, path)
end

struct spPolygon
    vertices::Ptr{Cfloat}
    count::Cint
    capacity::Cint
end

function spPolygon_create(capacity)
    ccall((:spPolygon_create, libspine), Ptr{spPolygon}, (Cint,), capacity)
end

function spPolygon_dispose(self)
    ccall((:spPolygon_dispose, libspine), Cvoid, (Ptr{spPolygon},), self)
end

function spPolygon_containsPoint(polygon, x, y)
    ccall((:spPolygon_containsPoint, libspine), Cint, (Ptr{spPolygon}, Cfloat, Cfloat), polygon, x, y)
end

function spPolygon_intersectsSegment(polygon, x1, y1, x2, y2)
    ccall((:spPolygon_intersectsSegment, libspine), Cint, (Ptr{spPolygon}, Cfloat, Cfloat, Cfloat, Cfloat), polygon, x1, y1, x2, y2)
end

struct spSkeletonBounds
    count::Cint
    boundingBoxes::Ptr{Ptr{spBoundingBoxAttachment}}
    polygons::Ptr{Ptr{spPolygon}}
    minX::Cfloat
    minY::Cfloat
    maxX::Cfloat
    maxY::Cfloat
end

# no prototype is found for this function at SkeletonBounds.h:71:26, please use with caution
function spSkeletonBounds_create()
    ccall((:spSkeletonBounds_create, libspine), Ptr{spSkeletonBounds}, ())
end

function spSkeletonBounds_dispose(self)
    ccall((:spSkeletonBounds_dispose, libspine), Cvoid, (Ptr{spSkeletonBounds},), self)
end

function spSkeletonBounds_update(self, skeleton, updateAabb)
    ccall((:spSkeletonBounds_update, libspine), Cvoid, (Ptr{spSkeletonBounds}, Ptr{spSkeleton}, Cint), self, skeleton, updateAabb)
end

function spSkeletonBounds_aabbContainsPoint(self, x, y)
    ccall((:spSkeletonBounds_aabbContainsPoint, libspine), Cint, (Ptr{spSkeletonBounds}, Cfloat, Cfloat), self, x, y)
end

function spSkeletonBounds_aabbIntersectsSegment(self, x1, y1, x2, y2)
    ccall((:spSkeletonBounds_aabbIntersectsSegment, libspine), Cint, (Ptr{spSkeletonBounds}, Cfloat, Cfloat, Cfloat, Cfloat), self, x1, y1, x2, y2)
end

function spSkeletonBounds_aabbIntersectsSkeleton(self, bounds)
    ccall((:spSkeletonBounds_aabbIntersectsSkeleton, libspine), Cint, (Ptr{spSkeletonBounds}, Ptr{spSkeletonBounds}), self, bounds)
end

function spSkeletonBounds_containsPoint(self, x, y)
    ccall((:spSkeletonBounds_containsPoint, libspine), Ptr{spBoundingBoxAttachment}, (Ptr{spSkeletonBounds}, Cfloat, Cfloat), self, x, y)
end

function spSkeletonBounds_intersectsSegment(self, x1, y1, x2, y2)
    ccall((:spSkeletonBounds_intersectsSegment, libspine), Ptr{spBoundingBoxAttachment}, (Ptr{spSkeletonBounds}, Cfloat, Cfloat, Cfloat, Cfloat), self, x1, y1, x2, y2)
end

function spSkeletonBounds_getPolygon(self, boundingBox)
    ccall((:spSkeletonBounds_getPolygon, libspine), Ptr{spPolygon}, (Ptr{spSkeletonBounds}, Ptr{spBoundingBoxAttachment}), self, boundingBox)
end

struct spTriangulator
    convexPolygons::Ptr{spArrayFloatArray}
    convexPolygonsIndices::Ptr{spArrayShortArray}
    indicesArray::Ptr{spShortArray}
    isConcaveArray::Ptr{spIntArray}
    triangles::Ptr{spShortArray}
    polygonPool::Ptr{spArrayFloatArray}
    polygonIndicesPool::Ptr{spArrayShortArray}
end

struct spSkeletonClipping
    triangulator::Ptr{spTriangulator}
    clippingPolygon::Ptr{spFloatArray}
    clipOutput::Ptr{spFloatArray}
    clippedVertices::Ptr{spFloatArray}
    clippedUVs::Ptr{spFloatArray}
    clippedTriangles::Ptr{spUnsignedShortArray}
    scratch::Ptr{spFloatArray}
    clipAttachment::Ptr{spClippingAttachment}
    clippingPolygons::Ptr{spArrayFloatArray}
end

# no prototype is found for this function at SkeletonClipping.h:55:28, please use with caution
function spSkeletonClipping_create()
    ccall((:spSkeletonClipping_create, libspine), Ptr{spSkeletonClipping}, ())
end

function spSkeletonClipping_clipStart(self, slot, clip)
    ccall((:spSkeletonClipping_clipStart, libspine), Cint, (Ptr{spSkeletonClipping}, Ptr{spSlot}, Ptr{spClippingAttachment}), self, slot, clip)
end

function spSkeletonClipping_clipEnd(self, slot)
    ccall((:spSkeletonClipping_clipEnd, libspine), Cvoid, (Ptr{spSkeletonClipping}, Ptr{spSlot}), self, slot)
end

function spSkeletonClipping_clipEnd2(self)
    ccall((:spSkeletonClipping_clipEnd2, libspine), Cvoid, (Ptr{spSkeletonClipping},), self)
end

function spSkeletonClipping_isClipping(self)
    ccall((:spSkeletonClipping_isClipping, libspine), Cint, (Ptr{spSkeletonClipping},), self)
end

function spSkeletonClipping_clipTriangles(self, vertices, verticesLength, triangles, trianglesLength, uvs, stride)
    ccall((:spSkeletonClipping_clipTriangles, libspine), Cvoid, (Ptr{spSkeletonClipping}, Ptr{Cfloat}, Cint, Ptr{Cushort}, Cint, Ptr{Cfloat}, Cint), self, vertices, verticesLength, triangles, trianglesLength, uvs, stride)
end

function spSkeletonClipping_dispose(self)
    ccall((:spSkeletonClipping_dispose, libspine), Cvoid, (Ptr{spSkeletonClipping},), self)
end

# no prototype is found for this function at SkeletonData.h:81:24, please use with caution
function spSkeletonData_create()
    ccall((:spSkeletonData_create, libspine), Ptr{spSkeletonData}, ())
end

function spSkeletonData_dispose(self)
    ccall((:spSkeletonData_dispose, libspine), Cvoid, (Ptr{spSkeletonData},), self)
end

function spSkeletonData_findBone(self, boneName)
    ccall((:spSkeletonData_findBone, libspine), Ptr{spBoneData}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, boneName)
end

function spSkeletonData_findBoneIndex(self, boneName)
    ccall((:spSkeletonData_findBoneIndex, libspine), Cint, (Ptr{spSkeletonData}, Ptr{Cchar}), self, boneName)
end

function spSkeletonData_findSlot(self, slotName)
    ccall((:spSkeletonData_findSlot, libspine), Ptr{spSlotData}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, slotName)
end

function spSkeletonData_findSlotIndex(self, slotName)
    ccall((:spSkeletonData_findSlotIndex, libspine), Cint, (Ptr{spSkeletonData}, Ptr{Cchar}), self, slotName)
end

function spSkeletonData_findSkin(self, skinName)
    ccall((:spSkeletonData_findSkin, libspine), Ptr{spSkin}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, skinName)
end

function spSkeletonData_findEvent(self, eventName)
    ccall((:spSkeletonData_findEvent, libspine), Ptr{spEventData}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, eventName)
end

function spSkeletonData_findAnimation(self, animationName)
    ccall((:spSkeletonData_findAnimation, libspine), Ptr{spAnimation}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, animationName)
end

function spSkeletonData_findIkConstraint(self, constraintName)
    ccall((:spSkeletonData_findIkConstraint, libspine), Ptr{spIkConstraintData}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, constraintName)
end

function spSkeletonData_findTransformConstraint(self, constraintName)
    ccall((:spSkeletonData_findTransformConstraint, libspine), Ptr{spTransformConstraintData}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, constraintName)
end

function spSkeletonData_findPathConstraint(self, constraintName)
    ccall((:spSkeletonData_findPathConstraint, libspine), Ptr{spPathConstraintData}, (Ptr{spSkeletonData}, Ptr{Cchar}), self, constraintName)
end

struct spSkeletonJson
    scale::Cfloat
    attachmentLoader::Ptr{spAttachmentLoader}
    error::Ptr{Cchar}
end

function spSkeletonJson_createWithLoader(attachmentLoader)
    ccall((:spSkeletonJson_createWithLoader, libspine), Ptr{spSkeletonJson}, (Ptr{spAttachmentLoader},), attachmentLoader)
end

function spSkeletonJson_create(atlas)
    ccall((:spSkeletonJson_create, libspine), Ptr{spSkeletonJson}, (Ptr{spAtlas},), atlas)
end

function spSkeletonJson_dispose(self)
    ccall((:spSkeletonJson_dispose, libspine), Cvoid, (Ptr{spSkeletonJson},), self)
end

function spSkeletonJson_readSkeletonData(self, json)
    ccall((:spSkeletonJson_readSkeletonData, libspine), Ptr{spSkeletonData}, (Ptr{spSkeletonJson}, Ptr{Cchar}), self, json)
end

function spSkeletonJson_readSkeletonDataFile(self, path)
    ccall((:spSkeletonJson_readSkeletonDataFile, libspine), Ptr{spSkeletonData}, (Ptr{spSkeletonJson}, Ptr{Cchar}), self, path)
end

function spBoneDataArray_create(initialCapacity)
    ccall((:spBoneDataArray_create, libspine), Ptr{spBoneDataArray}, (Cint,), initialCapacity)
end

function spBoneDataArray_dispose(self)
    ccall((:spBoneDataArray_dispose, libspine), Cvoid, (Ptr{spBoneDataArray},), self)
end

function spBoneDataArray_clear(self)
    ccall((:spBoneDataArray_clear, libspine), Cvoid, (Ptr{spBoneDataArray},), self)
end

function spBoneDataArray_setSize(self, newSize)
    ccall((:spBoneDataArray_setSize, libspine), Ptr{spBoneDataArray}, (Ptr{spBoneDataArray}, Cint), self, newSize)
end

function spBoneDataArray_ensureCapacity(self, newCapacity)
    ccall((:spBoneDataArray_ensureCapacity, libspine), Cvoid, (Ptr{spBoneDataArray}, Cint), self, newCapacity)
end

function spBoneDataArray_add(self, value)
    ccall((:spBoneDataArray_add, libspine), Cvoid, (Ptr{spBoneDataArray}, Ptr{spBoneData}), self, value)
end

function spBoneDataArray_addAll(self, other)
    ccall((:spBoneDataArray_addAll, libspine), Cvoid, (Ptr{spBoneDataArray}, Ptr{spBoneDataArray}), self, other)
end

function spBoneDataArray_addAllValues(self, values, offset, count)
    ccall((:spBoneDataArray_addAllValues, libspine), Cvoid, (Ptr{spBoneDataArray}, Ptr{Ptr{spBoneData}}, Cint, Cint), self, values, offset, count)
end

function spBoneDataArray_removeAt(self, index)
    ccall((:spBoneDataArray_removeAt, libspine), Cvoid, (Ptr{spBoneDataArray}, Cint), self, index)
end

function spBoneDataArray_contains(self, value)
    ccall((:spBoneDataArray_contains, libspine), Cint, (Ptr{spBoneDataArray}, Ptr{spBoneData}), self, value)
end

function spBoneDataArray_pop(self)
    ccall((:spBoneDataArray_pop, libspine), Ptr{spBoneData}, (Ptr{spBoneDataArray},), self)
end

function spBoneDataArray_peek(self)
    ccall((:spBoneDataArray_peek, libspine), Ptr{spBoneData}, (Ptr{spBoneDataArray},), self)
end

function spIkConstraintDataArray_create(initialCapacity)
    ccall((:spIkConstraintDataArray_create, libspine), Ptr{spIkConstraintDataArray}, (Cint,), initialCapacity)
end

function spIkConstraintDataArray_dispose(self)
    ccall((:spIkConstraintDataArray_dispose, libspine), Cvoid, (Ptr{spIkConstraintDataArray},), self)
end

function spIkConstraintDataArray_clear(self)
    ccall((:spIkConstraintDataArray_clear, libspine), Cvoid, (Ptr{spIkConstraintDataArray},), self)
end

function spIkConstraintDataArray_setSize(self, newSize)
    ccall((:spIkConstraintDataArray_setSize, libspine), Ptr{spIkConstraintDataArray}, (Ptr{spIkConstraintDataArray}, Cint), self, newSize)
end

function spIkConstraintDataArray_ensureCapacity(self, newCapacity)
    ccall((:spIkConstraintDataArray_ensureCapacity, libspine), Cvoid, (Ptr{spIkConstraintDataArray}, Cint), self, newCapacity)
end

function spIkConstraintDataArray_add(self, value)
    ccall((:spIkConstraintDataArray_add, libspine), Cvoid, (Ptr{spIkConstraintDataArray}, Ptr{spIkConstraintData}), self, value)
end

function spIkConstraintDataArray_addAll(self, other)
    ccall((:spIkConstraintDataArray_addAll, libspine), Cvoid, (Ptr{spIkConstraintDataArray}, Ptr{spIkConstraintDataArray}), self, other)
end

function spIkConstraintDataArray_addAllValues(self, values, offset, count)
    ccall((:spIkConstraintDataArray_addAllValues, libspine), Cvoid, (Ptr{spIkConstraintDataArray}, Ptr{Ptr{spIkConstraintData}}, Cint, Cint), self, values, offset, count)
end

function spIkConstraintDataArray_removeAt(self, index)
    ccall((:spIkConstraintDataArray_removeAt, libspine), Cvoid, (Ptr{spIkConstraintDataArray}, Cint), self, index)
end

function spIkConstraintDataArray_contains(self, value)
    ccall((:spIkConstraintDataArray_contains, libspine), Cint, (Ptr{spIkConstraintDataArray}, Ptr{spIkConstraintData}), self, value)
end

function spIkConstraintDataArray_pop(self)
    ccall((:spIkConstraintDataArray_pop, libspine), Ptr{spIkConstraintData}, (Ptr{spIkConstraintDataArray},), self)
end

function spIkConstraintDataArray_peek(self)
    ccall((:spIkConstraintDataArray_peek, libspine), Ptr{spIkConstraintData}, (Ptr{spIkConstraintDataArray},), self)
end

function spTransformConstraintDataArray_create(initialCapacity)
    ccall((:spTransformConstraintDataArray_create, libspine), Ptr{spTransformConstraintDataArray}, (Cint,), initialCapacity)
end

function spTransformConstraintDataArray_dispose(self)
    ccall((:spTransformConstraintDataArray_dispose, libspine), Cvoid, (Ptr{spTransformConstraintDataArray},), self)
end

function spTransformConstraintDataArray_clear(self)
    ccall((:spTransformConstraintDataArray_clear, libspine), Cvoid, (Ptr{spTransformConstraintDataArray},), self)
end

function spTransformConstraintDataArray_setSize(self, newSize)
    ccall((:spTransformConstraintDataArray_setSize, libspine), Ptr{spTransformConstraintDataArray}, (Ptr{spTransformConstraintDataArray}, Cint), self, newSize)
end

function spTransformConstraintDataArray_ensureCapacity(self, newCapacity)
    ccall((:spTransformConstraintDataArray_ensureCapacity, libspine), Cvoid, (Ptr{spTransformConstraintDataArray}, Cint), self, newCapacity)
end

function spTransformConstraintDataArray_add(self, value)
    ccall((:spTransformConstraintDataArray_add, libspine), Cvoid, (Ptr{spTransformConstraintDataArray}, Ptr{spTransformConstraintData}), self, value)
end

function spTransformConstraintDataArray_addAll(self, other)
    ccall((:spTransformConstraintDataArray_addAll, libspine), Cvoid, (Ptr{spTransformConstraintDataArray}, Ptr{spTransformConstraintDataArray}), self, other)
end

function spTransformConstraintDataArray_addAllValues(self, values, offset, count)
    ccall((:spTransformConstraintDataArray_addAllValues, libspine), Cvoid, (Ptr{spTransformConstraintDataArray}, Ptr{Ptr{spTransformConstraintData}}, Cint, Cint), self, values, offset, count)
end

function spTransformConstraintDataArray_removeAt(self, index)
    ccall((:spTransformConstraintDataArray_removeAt, libspine), Cvoid, (Ptr{spTransformConstraintDataArray}, Cint), self, index)
end

function spTransformConstraintDataArray_contains(self, value)
    ccall((:spTransformConstraintDataArray_contains, libspine), Cint, (Ptr{spTransformConstraintDataArray}, Ptr{spTransformConstraintData}), self, value)
end

function spTransformConstraintDataArray_pop(self)
    ccall((:spTransformConstraintDataArray_pop, libspine), Ptr{spTransformConstraintData}, (Ptr{spTransformConstraintDataArray},), self)
end

function spTransformConstraintDataArray_peek(self)
    ccall((:spTransformConstraintDataArray_peek, libspine), Ptr{spTransformConstraintData}, (Ptr{spTransformConstraintDataArray},), self)
end

function spPathConstraintDataArray_create(initialCapacity)
    ccall((:spPathConstraintDataArray_create, libspine), Ptr{spPathConstraintDataArray}, (Cint,), initialCapacity)
end

function spPathConstraintDataArray_dispose(self)
    ccall((:spPathConstraintDataArray_dispose, libspine), Cvoid, (Ptr{spPathConstraintDataArray},), self)
end

function spPathConstraintDataArray_clear(self)
    ccall((:spPathConstraintDataArray_clear, libspine), Cvoid, (Ptr{spPathConstraintDataArray},), self)
end

function spPathConstraintDataArray_setSize(self, newSize)
    ccall((:spPathConstraintDataArray_setSize, libspine), Ptr{spPathConstraintDataArray}, (Ptr{spPathConstraintDataArray}, Cint), self, newSize)
end

function spPathConstraintDataArray_ensureCapacity(self, newCapacity)
    ccall((:spPathConstraintDataArray_ensureCapacity, libspine), Cvoid, (Ptr{spPathConstraintDataArray}, Cint), self, newCapacity)
end

function spPathConstraintDataArray_add(self, value)
    ccall((:spPathConstraintDataArray_add, libspine), Cvoid, (Ptr{spPathConstraintDataArray}, Ptr{spPathConstraintData}), self, value)
end

function spPathConstraintDataArray_addAll(self, other)
    ccall((:spPathConstraintDataArray_addAll, libspine), Cvoid, (Ptr{spPathConstraintDataArray}, Ptr{spPathConstraintDataArray}), self, other)
end

function spPathConstraintDataArray_addAllValues(self, values, offset, count)
    ccall((:spPathConstraintDataArray_addAllValues, libspine), Cvoid, (Ptr{spPathConstraintDataArray}, Ptr{Ptr{spPathConstraintData}}, Cint, Cint), self, values, offset, count)
end

function spPathConstraintDataArray_removeAt(self, index)
    ccall((:spPathConstraintDataArray_removeAt, libspine), Cvoid, (Ptr{spPathConstraintDataArray}, Cint), self, index)
end

function spPathConstraintDataArray_contains(self, value)
    ccall((:spPathConstraintDataArray_contains, libspine), Cint, (Ptr{spPathConstraintDataArray}, Ptr{spPathConstraintData}), self, value)
end

function spPathConstraintDataArray_pop(self)
    ccall((:spPathConstraintDataArray_pop, libspine), Ptr{spPathConstraintData}, (Ptr{spPathConstraintDataArray},), self)
end

function spPathConstraintDataArray_peek(self)
    ccall((:spPathConstraintDataArray_peek, libspine), Ptr{spPathConstraintData}, (Ptr{spPathConstraintDataArray},), self)
end

struct _Entry
    slotIndex::Cint
    name::Ptr{Cchar}
    attachment::Ptr{spAttachment}
    next::Ptr{_Entry}
end

const spSkinEntry = _Entry

struct _SkinHashTableEntry
    entry::Ptr{_Entry}
    next::Ptr{_SkinHashTableEntry}
end

struct _spSkin
    super::spSkin
    entries::Ptr{_Entry}
    entriesHashTable::NTuple{100, Ptr{_SkinHashTableEntry}}
end

function spSkin_create(name)
    ccall((:spSkin_create, libspine), Ptr{spSkin}, (Ptr{Cchar},), name)
end

function spSkin_dispose(self)
    ccall((:spSkin_dispose, libspine), Cvoid, (Ptr{spSkin},), self)
end

function spSkin_setAttachment(self, slotIndex, name, attachment)
    ccall((:spSkin_setAttachment, libspine), Cvoid, (Ptr{spSkin}, Cint, Ptr{Cchar}, Ptr{spAttachment}), self, slotIndex, name, attachment)
end

function spSkin_getAttachment(self, slotIndex, name)
    ccall((:spSkin_getAttachment, libspine), Ptr{spAttachment}, (Ptr{spSkin}, Cint, Ptr{Cchar}), self, slotIndex, name)
end

function spSkin_getAttachmentName(self, slotIndex, attachmentIndex)
    ccall((:spSkin_getAttachmentName, libspine), Ptr{Cchar}, (Ptr{spSkin}, Cint, Cint), self, slotIndex, attachmentIndex)
end

function spSkin_attachAll(self, skeleton, oldspSkin)
    ccall((:spSkin_attachAll, libspine), Cvoid, (Ptr{spSkin}, Ptr{spSkeleton}, Ptr{spSkin}), self, skeleton, oldspSkin)
end

function spSkin_addSkin(self, other)
    ccall((:spSkin_addSkin, libspine), Cvoid, (Ptr{spSkin}, Ptr{spSkin}), self, other)
end

function spSkin_copySkin(self, other)
    ccall((:spSkin_copySkin, libspine), Cvoid, (Ptr{spSkin}, Ptr{spSkin}), self, other)
end

function spSkin_getAttachments(self)
    ccall((:spSkin_getAttachments, libspine), Ptr{spSkinEntry}, (Ptr{spSkin},), self)
end

function spSkin_clear(self)
    ccall((:spSkin_clear, libspine), Cvoid, (Ptr{spSkin},), self)
end

function spSlot_create(data, bone)
    ccall((:spSlot_create, libspine), Ptr{spSlot}, (Ptr{spSlotData}, Ptr{spBone}), data, bone)
end

function spSlot_dispose(self)
    ccall((:spSlot_dispose, libspine), Cvoid, (Ptr{spSlot},), self)
end

function spSlot_setAttachment(self, attachment)
    ccall((:spSlot_setAttachment, libspine), Cvoid, (Ptr{spSlot}, Ptr{spAttachment}), self, attachment)
end

function spSlot_setAttachmentTime(self, time)
    ccall((:spSlot_setAttachmentTime, libspine), Cvoid, (Ptr{spSlot}, Cfloat), self, time)
end

function spSlot_getAttachmentTime(self)
    ccall((:spSlot_getAttachmentTime, libspine), Cfloat, (Ptr{spSlot},), self)
end

function spSlot_setToSetupPose(self)
    ccall((:spSlot_setToSetupPose, libspine), Cvoid, (Ptr{spSlot},), self)
end

function spSlotData_create(index, name, boneData)
    ccall((:spSlotData_create, libspine), Ptr{spSlotData}, (Cint, Ptr{Cchar}, Ptr{spBoneData}), index, name, boneData)
end

function spSlotData_dispose(self)
    ccall((:spSlotData_dispose, libspine), Cvoid, (Ptr{spSlotData},), self)
end

function spSlotData_setAttachmentName(self, attachmentName)
    ccall((:spSlotData_setAttachmentName, libspine), Cvoid, (Ptr{spSlotData}, Ptr{Cchar}), self, attachmentName)
end

function spTransformConstraint_create(data, skeleton)
    ccall((:spTransformConstraint_create, libspine), Ptr{spTransformConstraint}, (Ptr{spTransformConstraintData}, Ptr{spSkeleton}), data, skeleton)
end

function spTransformConstraint_dispose(self)
    ccall((:spTransformConstraint_dispose, libspine), Cvoid, (Ptr{spTransformConstraint},), self)
end

function spTransformConstraint_apply(self)
    ccall((:spTransformConstraint_apply, libspine), Cvoid, (Ptr{spTransformConstraint},), self)
end

function spTransformConstraintData_create(name)
    ccall((:spTransformConstraintData_create, libspine), Ptr{spTransformConstraintData}, (Ptr{Cchar},), name)
end

function spTransformConstraintData_dispose(self)
    ccall((:spTransformConstraintData_dispose, libspine), Cvoid, (Ptr{spTransformConstraintData},), self)
end

# no prototype is found for this function at Triangulator.h:52:24, please use with caution
function spTriangulator_create()
    ccall((:spTriangulator_create, libspine), Ptr{spTriangulator}, ())
end

function spTriangulator_triangulate(self, verticesArray)
    ccall((:spTriangulator_triangulate, libspine), Ptr{spShortArray}, (Ptr{spTriangulator}, Ptr{spFloatArray}), self, verticesArray)
end

function spTriangulator_decompose(self, verticesArray, triangles)
    ccall((:spTriangulator_decompose, libspine), Ptr{spArrayFloatArray}, (Ptr{spTriangulator}, Ptr{spFloatArray}, Ptr{spShortArray}), self, verticesArray, triangles)
end

function spTriangulator_dispose(self)
    ccall((:spTriangulator_dispose, libspine), Cvoid, (Ptr{spTriangulator},), self)
end

function spVertexAttachment_computeWorldVertices(self, slot, start, count, worldVertices, offset, stride)
    ccall((:spVertexAttachment_computeWorldVertices, libspine), Cvoid, (Ptr{spVertexAttachment}, Ptr{spSlot}, Cint, Cint, Ptr{Cfloat}, Cint, Cint), self, slot, start, count, worldVertices, offset, stride)
end

function spVertexAttachment_copyTo(self, other)
    ccall((:spVertexAttachment_copyTo, libspine), Cvoid, (Ptr{spVertexAttachment}, Ptr{spVertexAttachment}), self, other)
end

# typedef void ( * spVertexEffectBegin ) ( struct spVertexEffect * self , spSkeleton * skeleton )
const spVertexEffectBegin = Ptr{Cvoid}

# typedef void ( * spVertexEffectTransform ) ( struct spVertexEffect * self , float * x , float * y , float * u , float * v , spColor * light , spColor * dark )
const spVertexEffectTransform = Ptr{Cvoid}

# typedef void ( * spVertexEffectEnd ) ( struct spVertexEffect * self )
const spVertexEffectEnd = Ptr{Cvoid}

struct spVertexEffect
    _begin::spVertexEffectBegin
    transform::spVertexEffectTransform
    _end::spVertexEffectEnd
end

struct spJitterVertexEffect
    super::spVertexEffect
    jitterX::Cfloat
    jitterY::Cfloat
end

struct spSwirlVertexEffect
    super::spVertexEffect
    centerX::Cfloat
    centerY::Cfloat
    radius::Cfloat
    angle::Cfloat
    worldX::Cfloat
    worldY::Cfloat
end

function spJitterVertexEffect_create(jitterX, jitterY)
    ccall((:spJitterVertexEffect_create, libspine), Ptr{spJitterVertexEffect}, (Cfloat, Cfloat), jitterX, jitterY)
end

function spJitterVertexEffect_dispose(effect)
    ccall((:spJitterVertexEffect_dispose, libspine), Cvoid, (Ptr{spJitterVertexEffect},), effect)
end

function spSwirlVertexEffect_create(radius)
    ccall((:spSwirlVertexEffect_create, libspine), Ptr{spSwirlVertexEffect}, (Cfloat,), radius)
end

function spSwirlVertexEffect_dispose(effect)
    ccall((:spSwirlVertexEffect_dispose, libspine), Cvoid, (Ptr{spSwirlVertexEffect},), effect)
end

function _spAtlasPage_createTexture(self, path)
    ccall((:_spAtlasPage_createTexture, libspine), Cvoid, (Ptr{spAtlasPage}, Ptr{Cchar}), self, path)
end

function _spAtlasPage_disposeTexture(self)
    ccall((:_spAtlasPage_disposeTexture, libspine), Cvoid, (Ptr{spAtlasPage},), self)
end

function _spUtil_readFile(path, length)
    ccall((:_spUtil_readFile, libspine), Ptr{Cchar}, (Ptr{Cchar}, Ptr{Cint}), path, length)
end

function _spMalloc(size, file, line)
    ccall((:_spMalloc, libspine), Ptr{Cvoid}, (Csize_t, Ptr{Cchar}, Cint), size, file, line)
end

function _spCalloc(num, size, file, line)
    ccall((:_spCalloc, libspine), Ptr{Cvoid}, (Csize_t, Csize_t, Ptr{Cchar}, Cint), num, size, file, line)
end

function _spRealloc(ptr, size)
    ccall((:_spRealloc, libspine), Ptr{Cvoid}, (Ptr{Cvoid}, Csize_t), ptr, size)
end

function _spFree(ptr)
    ccall((:_spFree, libspine), Cvoid, (Ptr{Cvoid},), ptr)
end

# no prototype is found for this function at extension.h:177:7, please use with caution
function _spRandom()
    ccall((:_spRandom, libspine), Cfloat, ())
end

function _spSetMalloc(_malloc)
    ccall((:_spSetMalloc, libspine), Cvoid, (Ptr{Cvoid},), _malloc)
end

function _spSetDebugMalloc(_malloc)
    ccall((:_spSetDebugMalloc, libspine), Cvoid, (Ptr{Cvoid},), _malloc)
end

function _spSetRealloc(_realloc)
    ccall((:_spSetRealloc, libspine), Cvoid, (Ptr{Cvoid},), _realloc)
end

function _spSetFree(_free)
    ccall((:_spSetFree, libspine), Cvoid, (Ptr{Cvoid},), _free)
end

function _spSetRandom(_random)
    ccall((:_spSetRandom, libspine), Cvoid, (Ptr{Cvoid},), _random)
end

function _spReadFile(path, length)
    ccall((:_spReadFile, libspine), Ptr{Cchar}, (Ptr{Cchar}, Ptr{Cint}), path, length)
end

function _spMath_random(min, max)
    ccall((:_spMath_random, libspine), Cfloat, (Cfloat, Cfloat), min, max)
end

function _spMath_randomTriangular(min, max)
    ccall((:_spMath_randomTriangular, libspine), Cfloat, (Cfloat, Cfloat), min, max)
end

function _spMath_randomTriangularWith(min, max, mode)
    ccall((:_spMath_randomTriangularWith, libspine), Cfloat, (Cfloat, Cfloat, Cfloat), min, max, mode)
end

function _spMath_interpolate(apply, start, _end, a)
    ccall((:_spMath_interpolate, libspine), Cfloat, (Ptr{Cvoid}, Cfloat, Cfloat, Cfloat), apply, start, _end, a)
end

function _spMath_pow2_apply(a)
    ccall((:_spMath_pow2_apply, libspine), Cfloat, (Cfloat,), a)
end

function _spMath_pow2out_apply(a)
    ccall((:_spMath_pow2out_apply, libspine), Cfloat, (Cfloat,), a)
end

struct _spEventQueueItem
    data::NTuple{8, UInt8}
end

function Base.getproperty(x::Ptr{_spEventQueueItem}, f::Symbol)
    f === :type && return Ptr{Cint}(x + 0)
    f === :entry && return Ptr{Ptr{spTrackEntry}}(x + 0)
    f === :event && return Ptr{Ptr{spEvent}}(x + 0)
    return getfield(x, f)
end

function Base.getproperty(x::_spEventQueueItem, f::Symbol)
    r = Ref{_spEventQueueItem}(x)
    ptr = Base.unsafe_convert(Ptr{_spEventQueueItem}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{_spEventQueueItem}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct _spAnimationState
    super::spAnimationState
    eventsCount::Cint
    events::Ptr{Ptr{spEvent}}
    queue::Ptr{Cvoid} # queue::Ptr{_spEventQueue}
    propertyIDs::Ptr{Cint}
    propertyIDsCount::Cint
    propertyIDsCapacity::Cint
    animationsChanged::Cint
end

function Base.getproperty(x::_spAnimationState, f::Symbol)
    f === :queue && return Ptr{_spEventQueue}(getfield(x, f))
    return getfield(x, f)
end

struct _spEventQueue
    state::Ptr{_spAnimationState}
    objects::Ptr{_spEventQueueItem}
    objectsCount::Cint
    objectsCapacity::Cint
    drainDisabled::Cint
end

function _spAttachmentLoader_init(self, dispose, createAttachment, configureAttachment, disposeAttachment)
    ccall((:_spAttachmentLoader_init, libspine), Cvoid, (Ptr{spAttachmentLoader}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), self, dispose, createAttachment, configureAttachment, disposeAttachment)
end

function _spAttachmentLoader_deinit(self)
    ccall((:_spAttachmentLoader_deinit, libspine), Cvoid, (Ptr{spAttachmentLoader},), self)
end

function _spAttachmentLoader_setError(self, error1, error2)
    ccall((:_spAttachmentLoader_setError, libspine), Cvoid, (Ptr{spAttachmentLoader}, Ptr{Cchar}, Ptr{Cchar}), self, error1, error2)
end

function _spAttachmentLoader_setUnknownTypeError(self, type)
    ccall((:_spAttachmentLoader_setUnknownTypeError, libspine), Cvoid, (Ptr{spAttachmentLoader}, spAttachmentType), self, type)
end

function _spAttachment_init(self, name, type, dispose, copy)
    ccall((:_spAttachment_init, libspine), Cvoid, (Ptr{spAttachment}, Ptr{Cchar}, spAttachmentType, Ptr{Cvoid}, Ptr{Cvoid}), self, name, type, dispose, copy)
end

function _spAttachment_deinit(self)
    ccall((:_spAttachment_deinit, libspine), Cvoid, (Ptr{spAttachment},), self)
end

function _spVertexAttachment_init(self)
    ccall((:_spVertexAttachment_init, libspine), Cvoid, (Ptr{spVertexAttachment},), self)
end

function _spVertexAttachment_deinit(self)
    ccall((:_spVertexAttachment_deinit, libspine), Cvoid, (Ptr{spVertexAttachment},), self)
end

function _spTimeline_init(self, type, dispose, apply, getPropertyId)
    ccall((:_spTimeline_init, libspine), Cvoid, (Ptr{spTimeline}, spTimelineType, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), self, type, dispose, apply, getPropertyId)
end

function _spTimeline_deinit(self)
    ccall((:_spTimeline_deinit, libspine), Cvoid, (Ptr{spTimeline},), self)
end

function _spCurveTimeline_init(self, type, framesCount, dispose, apply, getPropertyId)
    ccall((:_spCurveTimeline_init, libspine), Cvoid, (Ptr{spCurveTimeline}, spTimelineType, Cint, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), self, type, framesCount, dispose, apply, getPropertyId)
end

function _spCurveTimeline_deinit(self)
    ccall((:_spCurveTimeline_deinit, libspine), Cvoid, (Ptr{spCurveTimeline},), self)
end

function _spCurveTimeline_binarySearch(values, valuesLength, target, step)
    ccall((:_spCurveTimeline_binarySearch, libspine), Cint, (Ptr{Cfloat}, Cint, Cfloat, Cint), values, valuesLength, target, step)
end

const SP_PATHCONSTRAINT_ = nothing

const SKIN_ENTRIES_HASH_TABLE_SIZE = 100

const DLLIMPORT = nothing

const DLLEXPORT = nothing

const SP_API = nothing

end # module
