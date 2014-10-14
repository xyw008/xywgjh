//
//  FlashMovieClip.m
//  FlashExporter
//
//  Created by HJC on 12-9-25.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#import "FlaMovieLayer.h"
#import "fla_DefineShape.h"
#import "fla_DefineImage.h"
#import "fla_DefineSprite.h"
#import "fla_DefineScene.h"
#import "fla_DefineRole.h"
#import "fla_BinaryReader.h"
#import "fla_DefineMorphShape.h"
#import "cocoa_platform.h"
#import "cocoa_CG.h"
#import "_FlaMovieUtils.h"
#import "fla_DefineUtils.h"
#import "fla_QuartzGraphics.h"


@interface __FlaMovieImpl : NSObject
{
@private
    fla::DefinePtr              _define;
    fla::DefinePtr              _state;
    fla::ColorTransform         _colorTransform;
}
@property (nonatomic, assign)   fla::DefinePtr          define;
@property (nonatomic, readonly) fla::DefinePtr          state;
@property (nonatomic, readonly) fla::ColorTransform&    colorTransform;
@property (nonatomic, readonly) FlaMovieType            movieType;
@property (nonatomic, readonly) NSString*               movieName;        // 定义的名字
@property (nonatomic, readonly) NSString*               stateName;        // 状态的名字
@end


@implementation __FlaMovieImpl

- (void) setDefine:(fla::DefinePtr)define
{
    if (_define != define)
    {
        _define = define;
        _state = define;
        if (define->type() == fla::DefineType_Role)
        {
            auto role = util::rc_static_cast<fla::DefineRole>(define);
            _state = role->defaultState();
        }
    }
}


- (NSString*) movieName
{
    if (!_define)
    {
        return @"";
    }
    return [NSString stringWithUTF8String:_define->name().c_str()];
}



- (NSString*) stateName
{
    if (!_state)
    {
        return @"";
    }
    
    if (_define->type() != fla::DefineType_Role)
    {
        return @"default";
    }
    
    auto& role = static_cast<const fla::DefineRole&>(*_define);
    return [NSString stringWithUTF8String:role.stateName(_state).c_str()];
}



- (FlaMovieType) movieType
{
    if (!_define)
    {
        return FlaMovieType_Null;
    }
    return (FlaMovieType)_define->type();
}



- (BOOL) changeState:(NSString*)stateName
{
    if (_define->type() != fla::DefineType_Role)
    {
        return FALSE;
    }
    
    auto role = util::rc_static_cast<fla::DefineRole>(_define);
    auto state = role->findDefine([stateName UTF8String]);
    if (_state != state)
    {
        _state = state;
        return TRUE;
    }
    return FALSE;
}


- (BOOL) changeStateIndex:(NSInteger)index
{
    if (_define->type() != fla::DefineType_Role)
    {
        return FALSE;
    }
    
    auto role = util::rc_static_cast<fla::DefineRole>(_define);
    auto state = role->states()[index].define();
    if (_state != state)
    {
        _state = state;
        return TRUE;
    }
    return FALSE;
}


@end


///////////////////////////////////////////////////////////////////////////////////////////////////


static inline bool typeIsSprite(fla::DefineType type)
{
    return (type == fla::DefineType_Sprite) || (type == fla::DefineType_Scene);
}


@implementation FlaMovieLayer


// 停止图层本身的切换动画
- (id<CAAction>) actionForKey:(NSString *)event
{
    return nil;
}


- (void) dealloc
{
    [_subMoviewLayers release];
    [_impl release];
    [super dealloc];
}



- (id) init
{
    self = [super init];
    if (self)
    {
        self.contentsScale = cocoa::mainScreenScale();
        _movieScale = 1.0;
        _impl = [[__FlaMovieImpl alloc] init];
    }
    return self;
}



- (void) setContentsScale:(CGFloat)contentsScale
{
    super.contentsScale = contentsScale;
    for (FlaMovieLayer* layer in _subMoviewLayers)
    {
        layer.contentsScale = contentsScale;
    }
}


- (NSString*) movieName
{
    return _impl.movieName;
}


- (NSString*) stateName
{
    return _impl.stateName;
}



- (FlaMovieType) movieType
{
    return _impl.movieType;
}



+ (id) layerWithPath:(NSString*)filePath scale:(CGFloat)scale frameRate:(CGFloat*)frameRate error:(FlaError**)error
{
    auto root = [_FlaMovieUtils loadDefine:filePath frameRate:frameRate error:error];
    if (root)
    {
        FlaMovieLayer* layer = [[[FlaMovieLayer alloc] init] autorelease];
        layer.movieScale = scale;
        [layer __setDefine:root];
        return layer;
    }
    return nil;
}


+ (id) layerWithPath:(NSString*)filePath frameRate:(CGFloat*)frameRate error:(FlaError**)error
{
    return [self layerWithPath:filePath scale:1.0 frameRate:frameRate error:error];
}


- (id) initWithDefinition:(FlaDefinition*)define scale:(CGFloat)scale
{
    self = [self init];
    if (self)
    {
        self.movieScale = scale;
        self.definition = define;
    }
    return self;
}


- (id) initWithDefinition:(FlaDefinition*)define
{
    return [self initWithDefinition:define scale:1];
}

+ (id) layerWithDefinition:(FlaDefinition*)define scale:(CGFloat)scale
{
    return [[[self alloc] initWithDefinition:define scale:scale] autorelease];
}


+ (id) layerWithDefinition:(FlaDefinition*)define
{
    return [[[self alloc] initWithDefinition:define scale:1] autorelease];
}


- (void) setCenterPoint:(CGPoint)centerPoint
{
    if (!_impl.define)
    {
        self.position = centerPoint;
        return;
    }
    auto bounds = fla::define_computeBounds(*_impl.define);
    bounds *= _movieScale;
    
    CGPoint pt;
    pt.x = (centerPoint.x - bounds.width * 0.5) - bounds.x;
    pt.y = (centerPoint.y - bounds.height * 0.5) - bounds.y;
    self.position = pt;
}



- (CGPoint) centerPoint
{
    if (!_impl.define)
    {
        return self.position;
    }
    auto bounds = fla::define_computeBounds(*_impl.define);
    bounds *= _movieScale;
    
    CGPoint pt = self.position;
    pt.x = pt.x + bounds.width * 0.5 + bounds.x;
    pt.y = pt.y + bounds.height * 0.5 + bounds.y;
    return pt;
}


- (CGSize) movieSize
{
    auto bounds = fla::define_computeBounds(*_impl.define);
    return CGSizeMake(bounds.width, bounds.height);
}


- (void) __setDefine:(fla::DefinePtr)define
{
    _impl.define = define;
    self.transform = CATransform3DIdentity;
    [self refreshLayers];
}


- (void) setDefinition:(FlaDefinition *)definition
{
    fla::Define* ptr = static_cast<fla::Define*>(definition.impl);
    [self __setDefine:fla::DefinePtr(ptr->retain())];
}


- (FlaDefinition*) definition
{
    auto ptr = _impl.define.get();
    if (!ptr)
    {
        return nil;
    }
    return [[[FlaDefinition alloc] initWithImpl:ptr] autorelease];
}


- (void) setMovieScale:(CGFloat)movieScale
{
    if (_movieScale != movieScale)
    {
        _movieScale = movieScale;
        auto define = _impl.define;
        auto state = _impl.state;
        if (define)
        {
            auto frameIndex = _curFrame;
            [self refreshLayers];
            if (typeIsSprite(state->type()))
            {
                if (_curFrame != frameIndex)
                {
                    [self clearLayers];
                    auto& sprite = *static_cast<fla::DefineSprite*>(state.get());
                    auto frame = sprite.gotoFrame((int)frameIndex);
                    [self placeFrame:frame frameIndex:frameIndex];
                    _curFrame = frameIndex;
                }
            }
            
        }
    }
}


- (BOOL) changeState:(NSString*)stateName
{
    if ([_impl changeState:stateName])
    {
        [self refreshLayers];
        return TRUE;
    }
    return FALSE;
}




- (BOOL) changeStateIndex:(NSInteger)index
{
    if ([_impl changeStateIndex:index])
    {
        [self refreshLayers];
        return TRUE;
    }
    return FALSE;
}



- (void) clearLayers
{
    if ([_subMoviewLayers count] > 0)
    {
        NSArray* array = [NSArray arrayWithArray:_subMoviewLayers];
        for (CALayer* layer in array)
        {
            [layer removeFromSuperlayer];
        }
        [_subMoviewLayers removeAllObjects];
    }
}



- (void) refreshLayers
{
    CGPoint pos = self.position;
    
    [self clearLayers];
    self.contents = nil;
    self.backgroundColor = NULL;
    self.anchorPoint = CGPointMake(0, 0);
    [self setNeedsDisplay];
    _curFrame = 0;
    
    self.masksToBounds = NO;
    auto type = _impl.state->type();
    if (type == fla::DefineType_Scene)
    {
        [self setupSceneLayer];
    }
    else if (type == fla::DefineType_Sprite)
    {
        [self setupSpriteLayer];
    }
    else
    {
        [self setupMovieLayer];
    }
    self.position = pos;
}



- (void) removeFromSuperlayer
{
    FlaMovieLayer* layer = (FlaMovieLayer*)self.superlayer;
    if ([layer isKindOfClass:[FlaMovieLayer class]])
    {
        [layer->_subMoviewLayers removeObject:self];
    }
    [super removeFromSuperlayer];
}



- (void) setupMovieLayer
{
    auto rt = fla::define_computeBounds(*_impl.state);
    rt *= _movieScale;
    
    rt.x = floorf(rt.x - 2);
    rt.y = floorf(rt.y - 2);
    rt.width = ceilf(rt.width + 4);
    rt.height = ceilf(rt.height + 4);
    
    self.anchorPoint = CGPointMake(-rt.x / rt.width, -rt.y / rt.height);
    self.bounds = rt.asRect();
    self.position = CGPointMake(0, 0);
    [self setNeedsDisplay];
}



- (void) setupSceneLayer
{
    auto& scene = static_cast<const fla::DefineScene&>(*_impl.state);
    auto rt = scene.bounds();
    rt *= _movieScale;
    
    self.bounds = rt.asRect();
    self.masksToBounds = YES;
    
    auto& color = scene.color();
    auto colorHolder = cocoa::CG::createColor(color.red, color.green, color.blue, color.alpha);
    self.backgroundColor = colorHolder.get();
    [self gotoFrame:0];
}



- (void) setupSpriteLayer
{
    [self gotoFrame:0];
}



- (void) drawInContext:(CGContextRef)ctx
{
    auto state = _impl.state;
    if (!state)
    {
        return;
    }
    
    if (!typeIsSprite(state->type()))
    {
        CGContextScaleCTM(ctx, _movieScale, _movieScale);
        fla::QuartzGraphics render(ctx);
        if (state->type() == fla::DefineType_MorphShape)
        {
            auto& shape = static_cast<const fla::DefineMorphShape&>(*state);
            shape.render(render, _impl.colorTransform, _ratio);
        }
        else
        {
            fla::define_drawInContext(*state, render, _impl.colorTransform);
        }
    }
}



- (void) FlaMovieLayerDidFinishMovie:(FlaMovieLayer*)layer
{
    auto& sprite = static_cast<const fla::DefineSprite&>(*_impl.state);
    if (sprite.frameCount() == 1 &&
        sprite.frames()[0].size() == 1 &&
        layer.superlayer == self)
    {
        if ([_movieDelegate respondsToSelector:@selector(FlaMovieLayerDidFinishMovie:)])
        {
            [_movieDelegate FlaMovieLayerDidFinishMovie:self];
        }
    }
    else
    {
        if ([_movieDelegate respondsToSelector:@selector(FlaMovieLayerDidFinishMovie:)])
        {
            [_movieDelegate FlaMovieLayerDidFinishMovie:layer];
        }
    }
}


- (void) stepFrame
{
    auto state = _impl.state;
    if (!typeIsSprite(state->type()))
    {
        return;
    }

    auto& sprite = static_cast<const fla::DefineSprite&>(*state);
    if (sprite.frameCount() > 1)
    {
        _curFrame = (_curFrame + 1) % sprite.frameCount();
        if (_curFrame == 0)
        {
            if ([_movieDelegate respondsToSelector:@selector(FlaMovieLayerDidFinishMovie:)])
            {
                [_movieDelegate FlaMovieLayerDidFinishMovie:self];
            }
        }
        [self gotoFrame:_curFrame];;
    }
    
    for (FlaMovieLayer* layer in _subMoviewLayers)
    {
        if (!layer.ignoreAutoStepFrame)
        {
            [layer stepFrame];
        }
    }
}



- (FlaMovieLayer*) childWithDepth:(NSInteger)depth
{
    FlaMovieLayer* foundLayer = nil;
    for (FlaMovieLayer* layer in _subMoviewLayers)
    {
        if (std::abs(layer.zPosition - depth) < 0.1)
        {
            foundLayer = layer;
            break;
        }
    }
    
    // 容错
    if (foundLayer && foundLayer.superlayer != self)
    {
        [_subMoviewLayers removeObject:foundLayer];
        foundLayer = nil;
    }
    return foundLayer;
}


// 查找应该插入的位置，保持zPositon从小到大
static unsigned findLayerInsertIndex(NSArray* array, NSInteger zPosition)
{
    auto count = [array count];
    auto index = 0;
    for (index = 0; index < count; index++)
    {
        if ([array[index] zPosition] > zPosition)
        {
            break;
        }
    }
    return index;
}



- (void) _addSubMovieLayer:(FlaMovieLayer*)subLayer
{
    if (_subMoviewLayers == nil)
    {
        _subMoviewLayers = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    // 增加图层的时候，数组的zPositon由小到大排序
    auto index = findLayerInsertIndex(_subMoviewLayers, subLayer.zPosition);
    [_subMoviewLayers insertObject:subLayer atIndex:index];
    
    index = findLayerInsertIndex(self.sublayers, subLayer.zPosition);
    [self insertSublayer:subLayer atIndex:index];
}




- (FlaMovieLayer*) newMovieClipWithPlaceObjct:(const fla::SpriteObject*)pObj
{
    auto state = _impl.state;
    auto obj = *pObj;
    auto& sprite = *static_cast<fla::DefineSprite*>(state.get());
    auto childDefine = sprite.findDefine(obj.characterID);
    
    if (childDefine)
    {
        FlaMovieLayer* layer = [[[FlaMovieLayer alloc] init] autorelease];
        layer.contentsScale = self.contentsScale;
        layer.movieDelegate = self;
        layer.movieScale = _movieScale;
        [layer __setDefine:childDefine];
        layer.zPosition = obj.depth;
        
        [self _addSubMovieLayer:layer];
        return layer;
    }
    return nil;
}



- (void) renderFrame
{
    // do nothing
}




- (void) gotoFirstFrame
{
    _curFrame = 0;
    [self gotoFrame:0];
    for (FlaMovieLayer* layer in _subMoviewLayers)
    {
        [layer gotoFirstFrame];
    }
}



- (void) placeFrame:(const fla::SpriteFrame&)frame frameIndex:(NSInteger)frameIndex
{
    NSMutableSet* allLayers = nil;
    NSMutableSet* layerUsed = nil;
    
    if (frameIndex == 0)
    {
        allLayers = [NSMutableSet setWithCapacity:_subMoviewLayers.count];
        layerUsed = [NSMutableSet setWithCapacity:_subMoviewLayers.count];
        [allLayers addObjectsFromArray:_subMoviewLayers];
        for (FlaMovieLayer* layer in _subMoviewLayers)
        {
            layer.opacity = 1;
            layer->_ratio = 0;
            layer->_impl.colorTransform = fla::ColorTransform::identity;
        }
    }
    
    for (auto& obj : frame)
    {
        FlaMovieLayer* layer = [self childWithDepth:obj.depth];
        if (obj.removeObject)
        {
            [layer removeFromSuperlayer];
        }
        else
        {
            if (obj.hasCharacterID)
            {
                if (layer && obj.characterID != layer->_impl.define->Id())
                {
                    FlaMovieLayer* newLayer = [self newMovieClipWithPlaceObjct:&obj];
                    if (newLayer)
                    {
                        newLayer.transform = layer.transform;
                        newLayer.opacity = layer.opacity;
                        newLayer->_impl.colorTransform = layer->_impl.colorTransform;
                    }
                    [layer removeFromSuperlayer];
                    layer = newLayer;
                }
                
                if (!layer)
                {
                    layer = [self newMovieClipWithPlaceObjct:&obj];
                }
            }
            
            if (obj.hasTrans)
            {
                CGAffineTransform trans = obj.trans;
                trans.tx *= _movieScale;
                trans.ty *= _movieScale;
                layer.transform = CATransform3DMakeAffineTransform(trans);
            }
            
            
            if (obj.hasColorTrans && layer)
            {
                layer.opacity = obj.colorTrans.aMult();
                auto trans = obj.colorTrans;
                trans.setAMult(1);
                
                if (layer->_impl.colorTransform != trans)
                {
                    layer->_impl.colorTransform = trans;
                    [layer setNeedsDisplay];
                }
            }
            
            if (obj.hasRatio && layer && layer->_ratio != obj.ratio)
            {
                layer->_ratio = obj.ratio;
                [layer setNeedsDisplay];
            }
            
            if (layer)
            {
                [layerUsed addObject:layer];
            }
        }
    }
    
    if (frameIndex == 0)
    {
        [allLayers minusSet:layerUsed];
        for (CALayer* layer in allLayers)
        {
            [layer removeFromSuperlayer];
        }
    }
}



- (void) gotoFrame:(NSInteger)frameIndex
{
    auto state = _impl.state;
    if (!typeIsSprite(state->type()))
    {
        return;
    }
    
    auto& sprite = static_cast<const fla::DefineSprite&>(*state);
    auto& frame = sprite.frames()[frameIndex];
    [self placeFrame:frame frameIndex:frameIndex];
}




- (CALayer*) hitTest:(CGPoint)pt
{
    if (self.sublayers)
    {
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.sublayers];
        [array sortUsingComparator:^NSComparisonResult(CALayer* obj1, CALayer* obj2)
        {
            if (obj1.zPosition < obj2.zPosition)
            {
                return NSOrderedDescending;
            }
            
            if (obj1.zPosition == obj2.zPosition)
            {
                return NSOrderedSame;
            }
            
            return NSOrderedAscending;
        }];
        
        for (CALayer* layer in array)
        {
            CGPoint hitPt = [self convertPoint:pt toLayer:layer];
            CALayer* hitLayer = [layer hitTest:hitPt];
            if (hitLayer)
            {
                return hitLayer;
            }
        }
    }

    if (!_impl.state)
    {
        return nil;
    }

    if (CGRectContainsPoint(self.bounds, pt))
    {
        return self;
    }

    return nil;
}


@end


////////////////////////////////////////////////////////////////////////////////

@implementation CALayer(FlaMovieLayerFinder)


- (FlaMovieLayer*) findSuperMovieLayer:(BOOL(^)(FlaMovieLayer* layer))block
{
    FlaMovieLayer* parent = (FlaMovieLayer*)self;
    while (parent)
    {
        if (![parent isKindOfClass:[FlaMovieLayer class]])
        {
            return nil;
        }
        
        if (block(parent))
        {
            return parent;
        }
        
        parent = (FlaMovieLayer*)parent.superlayer;
    }
    return nil;
}



- (FlaMovieLayer*) findSuperMovieLayerNamed:(NSString*)name
{
    return [self findSuperMovieLayer:^BOOL(FlaMovieLayer* layer)
            {
                return [layer.name isEqualToString:name];
            }];
}



- (FlaMovieLayer*) _transSubLayers:(BOOL(^)(FlaMovieLayer* layer))block
{
    for (FlaMovieLayer* layer in self.sublayers)
    {
        if ([layer isKindOfClass:[FlaMovieLayer class]] && block(layer))
        {
            return layer;
        }
    }

    for (FlaMovieLayer* layer in self.sublayers)
    {
        FlaMovieLayer* subLayer = [layer _transSubLayers:block];
        if (subLayer)
        {
            return subLayer;
        }
    }
    return nil;
}



- (FlaMovieLayer*) findSubMovieLayer:(BOOL(^)(FlaMovieLayer* layer))block
{
    FlaMovieLayer* layer = (FlaMovieLayer*)self;
    if ([layer isKindOfClass:[FlaMovieLayer class]] && block(layer))
    {
        return layer;
    }
    return [self _transSubLayers:block];
}



- (FlaMovieLayer*) findSubMovieLayerNamed:(NSString*)name
{
    return [self findSubMovieLayer:^BOOL(FlaMovieLayer* layer)
            {
                return [layer.movieName isEqualToString:name];
            }];
}


@end



