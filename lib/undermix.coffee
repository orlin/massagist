# TODO: define (require, exports, module) ->
_ =     require("underscore")
_.mixin require("underscore.string")
_.mixin

  # Borrowed [type function](http://coffeescriptcookbook.com/chapters/classes_and_objects/type-function)
  # to use instead of the [typeof operator](https://developer.mozilla.org/en/JavaScript/Reference/Operators/typeof)
  type: (obj) ->
    if obj == undefined or obj == null
      return String obj
    classToType = new Object
    for name in "Boolean Number String Function Array Date RegExp".split(" ")
      classToType["[object " + name + "]"] = name.toLowerCase()
    myClass = Object.prototype.toString.call obj
    if myClass of classToType
      return classToType[myClass]
    return "object"

  # Converts the arguments list to an Array
  aToArr: (list) ->
    if _.isArguments(list)
      _.toArray(list).slice(0)
    else
      console.log "aToArr called with these non-arguments: #{list}"
      [list]

  # Merges all from a list of objects in return for a single one
  # sequentially overwrites keys (with disrespect for nested values)
  allFurther: (into, rest...) ->
    # _.each rest, (item) -> _.map item, (val, key) -> into[key] = val
    for item in rest
      for key, val of item
        into[key] = val
    into

  # Handles Raphael (or any other) SVG icons - icon id must match a document's #id.
  # Requires opts.icons.icon.path - everything else is optional.
  # Add conf & attr to opts.pref or opts.icons - progressively overriding defaults.
  raiconize: (opts) ->
    # configure to work with http://raphaeljs.com/icons/ by default
    conf =
      path_size: 32 # raphael icons' size
      icon_size: 24 # desired size of icons (default)
    for id, icon of opts.icons
      conf = _.allFurther conf, opts.pref?.conf, icon?.conf
      attr = _.allFurther {}, opts.pref?.attr, icon?.attr
      unless conf.skip?
        # undefined skip means an icon is wanted
        $("##{id}").text("")
        surface = Raphael id, conf.icon_size, conf.icon_size
        surface.clear()
        ratio = (icon.size ? conf.icon_size) / conf.path_size
        thing = surface.path icon.path
        thing.scale(ratio, ratio, 0, 0)
        thing.attr(attr) if _.size(attr) > 0
      else if conf.skip is true
        # true skipping removes the icon #id div - altogether gone
        $("##{id}").remove()
      #else: a false skip let's stuff remain as is

exports._ = _
