class CS.engine.Scroller
  constructor: (stage) ->
    @far = new CS.background.Far()
    stage.addChild(@far)

    @mid = new CS.background.Mid()
    stage.addChild(@mid)

    @front = new CS.walls.Walls()
    stage.addChild(@front)

    @mapBuilder = new CS.engine.MapBuilder(@front)

    @viewportX = 0

  setViewportX: (viewportX) ->
    @viewportX = viewportX
    @far.setViewportX(viewportX)
    @mid.setViewportX(viewportX)
    @front.setViewportX(viewportX)

  getViewportX: ->
    @viewportX

  moveViewportXBy: (units) ->
    newViewportX = @viewportX + units
    @setViewportX(newViewportX)