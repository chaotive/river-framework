class APP.engine.Scroller
  constructor: (stage) ->
    @far = new APP.background.Far()
    stage.addChild(@far)

    @mid = new APP.background.Mid()
    stage.addChild(@mid)

    @front = new APP.walls.Walls()
    stage.addChild(@front)

    @mapBuilder = new APP.engine.MapBuilder(@front)

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