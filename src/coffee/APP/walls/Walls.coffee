class CS.walls.Walls extends PIXI.DisplayObjectContainer
  @VIEWPORT_WIDTH = 512
  @VIEWPORT_NUM_SLICES = Math.ceil(Walls.VIEWPORT_WIDTH/CS.walls.WallSlice.WIDTH) + 1

  constructor: ->
    @_WallSlice = CS.walls.WallSlice
    @_SliceType = CS.walls.SliceType

    super()
    @pool = new CS.walls.WallSpritesPool()
    @createLookupTables()
    @slices = []
    @viewportX = 0
    @viewportSliceX = 0

  setViewportX: (viewportX) ->
    @viewportX = @checkViewportXBounds(viewportX)
    prevViewportSliceX = @viewportSliceX
    @viewportSliceX = Math.floor(@viewportX/@_WallSlice.WIDTH)

    @removeOldSlices(prevViewportSliceX)
    @addNewSlices()

  removeOldSlices: (prevViewportSliceX) ->
    numOldSlices = @viewportSliceX - prevViewportSliceX;
    if (numOldSlices > Walls.VIEWPORT_NUM_SLICES)
      numOldSlices = Walls.VIEWPORT_NUM_SLICES
    for i in [prevViewportSliceX...(prevViewportSliceX + numOldSlices)]
      slice = @slices[i]
      if (slice.sprite != null)
        @returnWallSprite(slice.type, slice.sprite)
        @removeChild(slice.sprite)
        slice.sprite = null

  addNewSlices: ->
    firstX = -(@viewportX % @_WallSlice.WIDTH)
    sliceIndex = 0
    for i in [@viewportSliceX...(@viewportSliceX + Walls.VIEWPORT_NUM_SLICES)]
      slice = @slices[i]
      if (slice.sprite == null && slice.type != @_SliceType.GAP)
        slice.sprite = @borrowWallSprite(slice.type)
        slice.sprite.position.x = firstX + (sliceIndex * @_WallSlice.WIDTH)
        slice.sprite.position.y = slice.y
        @addChild(slice.sprite)
      else if (slice.sprite != null)
        slice.sprite.position.x = firstX + (sliceIndex * @_WallSlice.WIDTH)
      sliceIndex++

  createLookupTables: ->
    @borrowWallSpriteLookup = []
    @borrowWallSpriteLookup[@_SliceType.FRONT] = @pool.borrowFrontEdge
    @borrowWallSpriteLookup[@_SliceType.BACK] = @pool.borrowBackEdge
    @borrowWallSpriteLookup[@_SliceType.STEP] = @pool.borrowStep
    @borrowWallSpriteLookup[@_SliceType.DECORATION] = @pool.borrowDecoration
    @borrowWallSpriteLookup[@_SliceType.WINDOW] = @pool.borrowWindow

    @returnWallSpriteLookup = [];
    @returnWallSpriteLookup[@_SliceType.FRONT] = @pool.returnFrontEdge
    @returnWallSpriteLookup[@_SliceType.BACK] = @pool.returnBackEdge
    @returnWallSpriteLookup[@_SliceType.STEP] = @pool.returnStep
    @returnWallSpriteLookup[@_SliceType.DECORATION] = @pool.returnDecoration
    @returnWallSpriteLookup[@_SliceType.WINDOW] = @pool.returnWindow

  borrowWallSprite: (sliceType) ->
    @borrowWallSpriteLookup[sliceType].call(@pool)

  returnWallSprite: (sliceType, sliceSprite) ->
    @returnWallSpriteLookup[sliceType].call(@pool, sliceSprite)

  addSlice: (sliceType, y) ->
    slice = new @_WallSlice(sliceType, y)
    @slices.push slice

  checkViewportXBounds: (viewportX) ->
    maxViewportX = (@slices.length - Walls.VIEWPORT_NUM_SLICES) * @_WallSlice.WIDTH
    if viewportX < 0 then viewportX = 0
    else if viewportX > maxViewportX then viewportX = maxViewportX
    viewportX
